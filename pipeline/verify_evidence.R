# ==== Evidence Verification =====================================================
# Checks each evidence quote in a scored record against the SOURCE TEXT the model
# was given (the GROBID extraction), to catch quotes that don't actually appear
# in the document — fabricated/hallucinated evidence, codebook-example leakage
# (e.g. WA_SWAP example text surfacing in a Florida record), or context bleed.
#
# WHY THIS IS NOW POSSIBLE: with text ingestion, the exact bytes sent to the
# model are a string we hold (the extraction). With native-PDF ingestion there
# was no programmatic source of truth, so this gate was infeasible. Text
# ingestion unlocked it. Consequently this check is TEXT-PATH ONLY.
#
# DESIGN (per project decisions):
#   - LENIENT FUZZY matching: normalize away formatting noise (whitespace, case,
#     punctuation, hyphenation, [page]/[TABLE]/[FIGURE] markers), then score
#     similarity. "Lenient" = tolerant of formatting, NOT of content divergence.
#   - RECORD RAW SCORE for every quote (not just pass/fail) so the threshold can
#     be re-calibrated from the data after seeing the failure-rate distribution.
#   - FLAG, DON'T ENFORCE: low-similarity quotes are reported for review; the
#     record is NOT altered or rejected. Enforcement is decided later.
#   - SCALABLE matching: anchor on a rare token from the quote, fuzzy-match only
#     local windows around candidate anchors — avoids O(doc_len) per quote.

library(stringdist)

# ---- normalization -------------------------------------------------------------
# Collapse formatting differences so only CONTENT divergence affects similarity.
.norm_text <- function(x) {
      if (length(x) == 0 || is.na(x)) return("")
      x <- tolower(x)
      x <- gsub("\\[(page [^]]*|/?table|figure:[^]]*)\\]", " ", x)  # strip our markers
      x <- gsub("[\u2018\u2019\u201c\u201d]", "'", x)                # smart quotes -> '
      x <- gsub("[\u2013\u2014]", "-", x)                            # en/em dash -> -
      x <- gsub("([a-z])-\\s+([a-z])", "\\1\\2", x)                  # de-hyphenate wraps
      x <- gsub("[[:punct:]]", " ", x)                               # drop punctuation
      x <- gsub("\\s+", " ", x)                                      # collapse whitespace
      trimws(x)
}

# ---- windowed fuzzy match ------------------------------------------------------
# Returns the best similarity (0..1) of `quote` against any same-length window of
# `doc`. Both already normalized. Uses an anchor (longest token in the quote) to
# find candidate positions, then compares only local windows — fast on big docs.
.best_match_sim <- function(quote_norm, doc_norm, doc_tokens = NULL) {
      if (!nzchar(quote_norm)) return(NA_real_)
      qn <- nchar(quote_norm)
      
      # (1) Exact containment — the definitive pass case. Must fire reliably.
      if (grepl(quote_norm, doc_norm, fixed = TRUE)) return(1)
      
      # (2) Very short quote: compare against best same-length window globally.
      if (qn < 12) return(.coarse_sim(quote_norm, doc_norm))
      
      # (3) Anchor on the longest token (most distinctive), find its occurrences,
      # and around each do a FINE sliding comparison (step = 1) over a window. The
      # window is widened to qn on each side so the true alignment is always inside
      # it; fine stepping guarantees we don't skip the best-aligned frame (the bug
      # that scored a verbatim quote 0.43 was coarse stepping missing alignment).
      qtoks <- strsplit(quote_norm, " ", fixed = TRUE)[[1]]
      qtoks <- qtoks[nchar(qtoks) > 0]
      if (length(qtoks) == 0) return(.coarse_sim(quote_norm, doc_norm))
      anchor <- qtoks[which.max(nchar(qtoks))]
      
      starts <- gregexpr(anchor, doc_norm, fixed = TRUE)[[1]]
      if (length(starts) == 1 && starts[1] == -1) {
            # Distinctive anchor absent -> quote almost certainly not in doc.
            return(.coarse_sim(quote_norm, doc_norm))
      }
      if (length(starts) > 60) starts <- starts[seq(1, length(starts), length.out = 60)]
      
      best <- 0
      for (s in starts) {
            w0 <- max(1, s - qn)
            w1 <- min(nchar(doc_norm), s + qn + nchar(anchor))
            window <- substr(doc_norm, w0, w1)
            wlen <- nchar(window)
            if (wlen < qn) {
                  sim <- 1 - stringdist(quote_norm, window, method = "lv") / qn
                  if (sim > best) best <- sim
                  next
            }
            # Fine slide: step = 1 is correct but can be slow on many anchors; cap work
            # by stepping 1 when few anchors, coarser when many (still <= ~qn compares).
            step <- if (length(starts) <= 8) 1 else max(1, floor(qn / 8))
            for (p in seq(1, wlen - qn + 1, by = step)) {
                  cand <- substr(window, p, p + qn - 1)
                  sim <- 1 - stringdist(quote_norm, cand, method = "lv") / qn
                  if (sim > best) { best <- sim; if (best >= 0.999) return(1) }
            }
      }
      best
}

# Coarse fallback when the anchor isn't found: compare quote to a few evenly
# spaced doc windows. Returns a low score for genuinely-absent quotes.
.coarse_sim <- function(quote_norm, doc_norm) {
      qn <- nchar(quote_norm); dn <- nchar(doc_norm)
      if (dn < qn) return(1 - stringdist(quote_norm, doc_norm, method = "lv") / qn)
      best <- 0
      for (p in floor(seq(1, dn - qn + 1, length.out = 25))) {
            cand <- substr(doc_norm, p, p + qn - 1)
            sim <- 1 - stringdist(quote_norm, cand, method = "lv") / qn
            if (sim > best) best <- sim
      }
      best
}

# ---- per-record verification ---------------------------------------------------
# Walks a scored result, pulls every evidence quote (handles both array-of-structs
# and the single-call struct-of-arrays shape defensively), scores each against the
# document text, and returns a data frame: one row per quote with its similarity
# and a flag. threshold is LENIENT by default; raw scores are recorded regardless
# so you can re-threshold from the data later.
verify_evidence <- function(result, doc_text, doc_id = NA_character_,
                            threshold = 0.85) {
      doc_norm <- .norm_text(doc_text)
      rows <- list()
      
      walk <- function(node, path) {
            if (!is.list(node)) return(invisible())
            nms <- names(node)
            for (i in seq_along(node)) {
                  key <- if (!is.null(nms) && !is.na(nms[[i]])) nms[[i]] else ""
                  val <- node[[i]]
                  if (identical(key, "evidence")) {
                        quotes <- .extract_quotes(val)
                        for (q in quotes) {
                              # Coerce each field to a length-1 scalar: NULL, character(0), or a
                              # multi-element vector would all break data.frame's equal-rows rule.
                              scal <- function(v, default = NA_character_) {
                                    if (is.null(v) || length(v) == 0) return(default)
                                    as.character(v)[[1]]
                              }
                              qtext <- scal(q$text, "")
                              qn <- .norm_text(qtext)
                              is_empty <- !nzchar(qn)   # absent/empty evidence slot, not a real quote
                              sim <- if (!is_empty) .best_match_sim(qn, doc_norm) else NA_real_
                              rows[[length(rows) + 1]] <<- data.frame(
                                    doc_id = scal(doc_id), element = scal(path, ""),
                                    location = scal(q$location),
                                    similarity = round(sim, 4),
                                    # verified only applies to real quotes; empty slots are NA (not FALSE),
                                    # so they don't get counted as fabrications in the summary.
                                    verified = if (is_empty) NA else (!is.na(sim) && sim >= threshold),
                                    is_quote = !is_empty,
                                    quote = substr(qtext, 1, 200),
                                    stringsAsFactors = FALSE
                              )
                        }
                  } else if (is.list(val)) {
                        walk(val, if (nzchar(key)) paste(path, key, sep = ".") else path)
                  }
            }
      }
      walk(result, "")
      
      if (length(rows) == 0) {
            return(data.frame(doc_id = character(), element = character(),
                              location = character(), similarity = numeric(),
                              verified = logical(), is_quote = logical(),
                              quote = character()))
      }
      do.call(rbind, rows)
}

# Pull {text, location} pairs from an evidence value in either shape.
.extract_quotes <- function(ev) {
      if (is.null(ev)) return(list())
      # struct-of-arrays: a named list with a `text` vector
      if (is.list(ev) && !is.null(names(ev)) && "text" %in% names(ev) &&
          length(ev$text) >= 1 && !is.list(ev$text[[1]])) {
            n <- length(ev$text)
            return(lapply(seq_len(n), function(j) list(
                  text = ev$text[[j]],
                  location = if (!is.null(ev$location) && length(ev$location) >= j) ev$location[[j]] else NA
            )))
      }
      # array-of-structs: unnamed list of {text, location} objects
      out <- list()
      for (e in ev) {
            if (is.list(e) && !is.null(e$text)) {
                  out[[length(out) + 1]] <- list(text = e$text, location = e$location %||% NA)
            } else if (is.character(e)) {
                  out[[length(out) + 1]] <- list(text = e, location = NA)
            }
      }
      out
}

# ---- corpus-level driver -------------------------------------------------------
# Verify every cached result for the current ingest mode against its extracted
# text, writing a combined report. TEXT PATH ONLY (needs the extraction as truth).
# Runs over the cache at zero API cost — use it to scan already-scored docs.
verify_corpus <- function(config, threshold = 0.85,
                          report_path = NULL) {
      if (!identical(config$ingest, "text")) {
            stop("Evidence verification requires ingest='text' (needs extracted text as ",
                 "source of truth). Native-PDF records can't be verified this way.")
      }
      rds <- dir_ls(config$coded_dir, glob = "*__text.rds")
      if (length(rds) == 0) { message("No text-path coded results in ", config$coded_dir); return(invisible()) }
      
      all_rows <- list()
      for (f in rds) {
            res <- readRDS(f)
            doc_id <- res$doc_id
            # Re-derive the exact source text the model saw. PREFER reading the canonical
            # <doc_id>.md directly — it IS the text scored against (single source of
            # truth), it handles multi-PDF documents (whose .md is the combined text),
            # and it avoids re-running GROBID. Fall back to extraction only if the .md is
            # somehow missing.
            md_path <- path(config$extracted_dir, paste0(doc_id, ".md"))
            doc_text <- if (file_exists(md_path)) {
                  paste(readLines(md_path, warn = FALSE), collapse = "\n")
            } else {
                  # Fallback: reconstruct the descriptor (folder = multi-PDF) and re-extract.
                  dpath <- path(config$source_dir, doc_id)
                  gcfg <- modifyList(grobid_config, list(
                        cache_dir     = config$tei_dir %||%
                              path(path_dir(config$extracted_dir), "tei"),
                        extracted_dir = config$extracted_dir %||% grobid_config$extracted_dir))
                  tryCatch(
                        if (dir_exists(dpath)) {
                              extract_document_multi(doc_id, as.character(sort(dir_ls(dpath, glob = "*.pdf"))), gcfg)
                        } else {
                              extract_text_grobid(path(config$source_dir, paste0(doc_id, ".pdf")), gcfg)
                        },
                        error = function(e) { message("  [", doc_id,
                                                      "] could not get source text: ", conditionMessage(e)); NA })
            }
            if (is.na(doc_text)[1] || !nzchar(doc_text)) next
            rep <- verify_evidence(res$result, doc_text, doc_id = doc_id, threshold = threshold)
            all_rows[[length(all_rows) + 1]] <- rep
            # Count over REAL quotes only (is_quote), not empty evidence slots for
            # absent elements (which carry verified=NA and would otherwise inflate the
            # "flagged" count — an element scoring 0 with no evidence is not a fabrication).
            q <- rep[rep$is_quote %in% TRUE, , drop = FALSE]
            nfail <- sum(!q$verified, na.rm = TRUE)
            message(sprintf("  [%s] %d quotes (%d empty slots), %d flagged (%.0f%% of quotes verified)",
                            doc_id, nrow(q), sum(!(rep$is_quote %in% TRUE)), nfail,
                            if (nrow(q)) 100 * mean(q$verified, na.rm = TRUE) else 100))
      }
      report <- do.call(rbind, all_rows)
      rp <- report_path %||% config$verify_report %||%
            path(config$out_dir %||% config$finalized_dir, "verify_report.csv")
      write_csv(report, rp)
      message("\nReport: ", rp)
      
      # Summary computed over REAL quotes only (empty slots excluded from rates).
      q <- report[report$is_quote %in% TRUE, , drop = FALSE]
      n_empty <- nrow(report) - nrow(q)
      cat("\n==== verification summary ====\n")
      cat(sprintf("  real quotes checked: %d  (+%d empty evidence slots, excluded from rate)\n",
                  nrow(q), n_empty))
      cat(sprintf("  verified (>= %.2f): %d (%.1f%%)\n", threshold,
                  sum(q$verified, na.rm = TRUE),
                  if (nrow(q)) 100 * mean(q$verified, na.rm = TRUE) else 100))
      cat(sprintf("  flagged for review: %d\n", sum(!q$verified, na.rm = TRUE)))
      cat("\n  similarity distribution over real quotes (helps re-calibrate the threshold):\n")
      print(round(quantile(q$similarity,
                           probs = c(0, .05, .1, .25, .5, .75, .9, 1), na.rm = TRUE), 3))
      # Worst offenders among real quotes only.
      worst <- q[order(q$similarity), ][seq_len(min(10, nrow(q))), ]
      cat("\n  lowest-similarity quotes (likely fabrication/leak/extraction-miss):\n")
      for (i in seq_len(nrow(worst))) {
            cat(sprintf("   [%.2f] %s/%s: %s\n", worst$similarity[i], worst$doc_id[i],
                        worst$element[i], substr(worst$quote[i], 1, 90)))
      }
      invisible(report)
}

# ---- usage ---------------------------------------------------------------------
# source("pipeline/verify_evidence.R")
# config$ingest <- "text"
# report <- verify_corpus(config, threshold = 0.85)
# # inspect flagged quotes, look at the similarity distribution, THEN decide the
# # real threshold and whether to enforce. The WA-example leak should appear as a
# # very-low-similarity quote on the affected docs.