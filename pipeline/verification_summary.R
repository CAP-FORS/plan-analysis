# ==== Verification Summary (per run) ============================================
# Wraps the evidence-verification gate (pipeline/verify_evidence.R) to produce a
# per-run fabrication/leak summary that slots into the comparison report. For
# each run, reports the % of evidence quotes that verify against source text and
# the count flagged below threshold — so "agreement" and "fabrication" sit side
# by side (a run can agree well yet fabricate, or vice versa).
#
# TEXT PATH ONLY (needs the extraction as source of truth), consistent with the
# gate itself. Runs over cached raw results at zero API cost.

# runs: named list of run dirs. config: the pipeline config (for cache + docs).
verification_by_run <- function(runs, config) {
      if (!exists("verify_evidence")) {
            # verify_evidence.R lives with the pipeline; source if needed.
            src <- "pipeline/verify_evidence.R"
            if (file.exists(src)) source(src) else {
                  warning("verify_evidence.R not found; skipping verification summary.")
                  return(NULL)
            }
      }
      rows <- lapply(names(runs), function(lab) {
            dir <- runs[[lab]]
            # Verify each record in the run dir against its source text.
            files <- fs::dir_ls(dir, glob = "*.json")
            files <- files[!grepl("truncated|verification|report", files)]
            sims <- c(); flagged <- 0; total <- 0
            for (f in files) {
                  rec <- tryCatch(jsonlite::fromJSON(f, simplifyVector = FALSE),
                                  error = function(e) NULL)
                  if (is.null(rec)) next
                  doc_id <- rec$document_meta$document_id %||% NA
                  doc_path <- fs::path(config$source_dir, paste0(doc_id, ".pdf"))
                  doc_text <- tryCatch(extract_text_grobid(doc_path,
                                                           modifyList(grobid_config, list(
                                                                 cache_dir     = config$tei_dir %||%
                                                                       fs::path(fs::path_dir(config$extracted_dir), "tei"),
                                                                 extracted_dir = config$extracted_dir %||% grobid_config$extracted_dir))),
                                       error = function(e) NA)
                  if (is.na(doc_text)[1]) next
                  rep <- verify_evidence(rec, doc_text, doc_id = doc_id,
                                         threshold = config$verify_threshold %||% 0.85)
                  sims <- c(sims, rep$similarity)
                  flagged <- flagged + sum(!rep$verified, na.rm = TRUE)
                  total <- total + nrow(rep)
            }
            data.frame(
                  run = lab,
                  quotes = total,
                  verified_pct = if (total) round(100 * (1 - flagged / total), 1) else NA,
                  flagged = flagged,
                  median_sim = if (length(sims)) round(median(sims, na.rm = TRUE), 3) else NA,
                  min_sim = if (length(sims)) round(min(sims, na.rm = TRUE), 3) else NA,
                  stringsAsFactors = FALSE
            )
      })
      do.call(rbind, rows)
}

`%||%` <- function(a, b) if (is.null(a) || length(a) == 0 ||
                             (length(a) == 1 && is.na(a))) b else a