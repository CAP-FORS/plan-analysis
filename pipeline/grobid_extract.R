# ==== GROBID Text Extraction ====================================================
# Converts a PDF to reading-order plain text for model ingestion, via a running
# GROBID service. Produces layout-correct text (columns read in proper order),
# with page / section / table markers preserved so the model can (a) resolve the
# evidence `location` field and (b) read tabular regions as tabular.
#
# WHY GROBID rather than pdftools::pdf_text(): pdf_text() reads by internal
# text-object order and interleaves multi-column pages into scrambled prose.
# GROBID does true layout analysis (it was built to linearize multi-column
# academic PDFs in correct reading order), which is the core problem for SWAPs.
#
# CAVEAT: GROBID's full-text model is trained on academic articles. SWAPs are
# gray-literature government documents (tables, appendices, non-academic
# structure). Its LAYOUT analysis (reading order, columns) is still strong, but
# its SEMANTIC tagging (section vs. caption vs. header) is less reliable here.
# We therefore parse defensively: take reading-order text, mark structure where
# GROBID tags it, but don't depend on its section semantics being perfect.
# Validate output on a real SWAP before trusting it corpus-wide.

library(httr2)
library(xml2)
library(fs)

# ==== Configuration =============================================================

grobid_config <- list(
      url            = "http://localhost:8070",   # GROBID service base URL
      endpoint       = "/api/processFulltextDocument",
      # GROBID flags. consolidateHeader/Citations OFF: we want text, not bibliographic
      # consolidation (that was the citation phase). coordinates ON so segment-level
      # info is available if needed later.
      timeout_sec    = 300,                        # large SWAPs take a while
      segment_sentences = FALSE,
      # Where cached TEI / combined-text files go. NULL = alongside the PDF (old
      # behavior); set a path to keep intermediates out of the docs folder. The dir
      # is created on first use. Cache files are named {doc_id}.grobid.tei.xml and
      # (for chunked docs) {doc_id}.grobid.txt.
      cache_dir      = "data/pilot/grobid_cache"
)

# TEI namespace — every xml2 query against TEI must use this.
.tei_ns <- c(tei = "http://www.tei-c.org/ns/1.0")

# ==== Service call ==============================================================
# Sends a PDF to GROBID and returns the raw TEI XML as a string. Errors clearly
# if the service is unreachable (the most common failure: container not running).

grobid_process_pdf <- function(pdf_path, config = grobid_config) {
      if (!file_exists(pdf_path)) stop("PDF not found: ", pdf_path)
      
      # req_error(is_error = ~FALSE) tells httr2 NOT to throw on HTTP error status,
      # so we can inspect the response body ourselves. This matters because GROBID
      # reports TOO_MANY_TOKENS as an HTTP 500 with the reason in the body — if we
      # let httr2 throw on the 500, conditionMessage() would only say "HTTP 500" and
      # the size-fallback grep would miss it. We separate two failure classes:
      #   (a) connection-level error (service down) -> "is it running?"
      #   (b) HTTP error with a body (GROBID ran, rejected the doc) -> surface body.
      resp <- tryCatch(
            request(paste0(config$url, config$endpoint)) |>
                  req_body_multipart(
                        input = curl::form_file(pdf_path),
                        consolidateHeader    = "0",
                        consolidateCitations = "0",
                        segmentSentences     = if (isTRUE(config$segment_sentences)) "1" else "0"
                  ) |>
                  req_timeout(config$timeout_sec) |>
                  req_error(is_error = function(resp) FALSE) |>   # don't throw on 4xx/5xx
                  req_perform(),
            error = function(e) {
                  # Reaches here only on transport/connection failure, not HTTP status.
                  stop("GROBID connection failed (is the service running at ", config$url,
                       "?). Original error: ", conditionMessage(e))
            }
      )
      
      status <- resp_status(resp)
      if (status != 200) {
            body <- tryCatch(resp_body_string(resp), error = function(e) "")
            # Surface GROBID's own reason (e.g. [TOO_MANY_TOKENS] ...) in the message so
            # callers (and the size-fallback grep upstream) can act on it.
            stop("GROBID HTTP ", status, " for ", path_file(pdf_path), ": ",
                 substr(body, 1, 500))
      }
      resp_body_string(resp)
}

# ==== TEI -> reading-order text =================================================
# Walks the TEI body in document order, emitting plain text with markers:
#   [page N]            inserted when a page-break boundary is detected
#   ## <heading>        section/division headings
#   [TABLE] ... [/TABLE]  tabular regions, rendered as Markdown grids (caption +
# Everything else (paragraphs) becomes plain prose separated by blank lines.
#
# We read <text>/<body> and also <text>/<back> (appendices, where SWAPs hide a
# lot of substance). We skip <teiHeader> (GROBID's bibliographic metadata) and
# <figure> graphic content (no text to score), but keep <figDesc> captions.

tei_to_text <- function(tei_xml) {
      doc  <- read_xml(tei_xml)
      body <- xml_find_first(doc, "//tei:text", .tei_ns)
      if (is.na(body) || length(body) == 0) {
            warning("No <text> element found in TEI; returning empty string.")
            return("")
      }
      
      out <- character(0)
      emit <- function(x) if (nzchar(trimws(x))) out[[length(out) + 1]] <<- x
      
      # Page-break detection: GROBID emits <pb> milestones (page breaks) when
      # coordinates are available. We track them to insert [page N] markers.
      # n attribute holds the page number when present.
      walk <- function(node) {
            children <- xml_contents(node)
            for (ch in children) {
                  type <- xml_type(ch)
                  if (type == "text") {
                        txt <- xml_text(ch)
                        if (nzchar(trimws(txt))) emit(.fix_linebreaks(txt))
                        next
                  }
                  if (type != "element") next
                  
                  nm <- xml_name(ch)
                  
                  if (nm == "pb") {
                        pg <- xml_attr(ch, "n")
                        # Own line, blank lines around -> renders as a distinct annotation.
                        emit(paste0("\n\n[page ", if (!is.na(pg)) pg else "?", "]\n\n"))
                        
                  } else if (nm == "head") {
                        # ATX heading needs a blank line before it to render reliably.
                        emit(paste0("\n\n## ", trimws(xml_text(ch)), "\n\n"))
                        
                  } else if (nm == "table") {
                        # Bare <table> (not wrapped in a figure). Render as Markdown.
                        emit(.render_table_md(ch, caption = NULL))
                        
                  } else if (nm == "figure") {
                        # GROBID wraps tables as <figure type="table"> with a nested <table>.
                        # Render those AS TABLES (caption + Markdown grid); treat everything
                        # else as a genuine figure and keep only its caption.
                        if (identical(xml_attr(ch, "type"), "table")) {
                              tbl_node <- xml_find_first(ch, ".//tei:table", .tei_ns)
                              cap_node <- xml_find_first(ch, ".//tei:figDesc", .tei_ns)
                              head_node <- xml_find_first(ch, ".//tei:head", .tei_ns)
                              # Caption: prefer the head ("Table 2.") + figDesc ("Acreages of..."),
                              # whichever are present, so the model has table context.
                              cap_parts <- c(
                                    if (!is.na(head_node)) trimws(xml_text(head_node)) else NULL,
                                    if (!is.na(cap_node))  trimws(xml_text(cap_node))  else NULL
                              )
                              cap <- if (length(cap_parts)) paste(cap_parts, collapse = " ") else NULL
                              if (!is.na(tbl_node)) {
                                    emit(.render_table_md(tbl_node, caption = cap))
                              } else if (!is.null(cap)) {
                                    emit(paste0("[TABLE: ", cap, "]"))   # table tagged but no grid found
                              }
                        } else {
                              cap <- xml_find_first(ch, ".//tei:figDesc", .tei_ns)
                              if (!is.na(cap)) emit(paste0("\n\n[FIGURE: ", trimws(xml_text(cap)), "]\n\n"))
                        }
                        
                  } else if (nm == "p") {
                        # Paragraph: recurse so nested <pb>, refs, etc. are handled in order,
                        # then add a blank-line separator.
                        walk(ch)
                        emit("")
                        
                  } else {
                        # Any other container (div, list, etc.): recurse to preserve order.
                        walk(ch)
                  }
            }
      }
      
      walk(body)
      # Collapse runs of blank lines, trim, single trailing newline.
      text <- paste(out, collapse = "\n")
      text <- gsub("\n{3,}", "\n\n", text)
      trimws(text)
}

# Join hyphenated line-breaks (com-\nmon -> common) and normalize intra-line
# whitespace without destroying paragraph structure.
.fix_linebreaks <- function(x) {
      x <- gsub("([A-Za-z])-\\s*\n\\s*([a-z])", "\\1\\2", x)  # de-hyphenate wraps
      x <- gsub("[ \t]+", " ", x)                              # collapse spaces
      x
}

# Render a TEI <table> node as a Markdown table, wrapped in [TABLE]/[/TABLE]
# markers (so it's spottable in output for QA) with an optional caption line.
# Markdown is used because models read pipe-delimited tables reliably and the
# explicit column separators preserve column relationships better than tabs.
#
# Handling of GROBID table quirks:
#   - spanning cells (cols="N"): expanded to N columns (value in first, blanks
#     after) so column alignment is preserved across rows.
#   - empty cells (<cell/>): rendered as blank, keeping positional alignment.
#   - ragged rows: padded to the max column count so the Markdown grid is valid.
#   - pipe characters inside cell text: escaped so they don't break the grid.
# The first row is treated as the header (GROBID tables usually lead with one);
# this is a heuristic — if a table has no header row the model still reads it
# fine, just with the first data row styled as header.
.render_table_md <- function(table_node, caption = NULL) {
      rows <- xml_find_all(table_node, ".//tei:row", .tei_ns)
      if (length(rows) == 0) {
            return(if (!is.null(caption)) paste0("[TABLE: ", caption, "]") else "")
      }
      
      # Expand each row into a character vector of cells, honoring colspans.
      row_cells <- lapply(rows, function(r) {
            cells <- xml_find_all(r, ".//tei:cell", .tei_ns)
            vals <- character(0)
            for (cl in cells) {
                  txt <- gsub("\\|", "\\\\|", trimws(xml_text(cl)))   # escape pipes
                  span <- suppressWarnings(as.integer(xml_attr(cl, "cols")))
                  if (is.na(span) || span < 1) span <- 1
                  vals <- c(vals, txt, rep("", span - 1))             # value + blanks for span
            }
            vals
      })
      
      ncol <- max(vapply(row_cells, length, integer(1)))
      if (ncol == 0) {
            return(if (!is.null(caption)) paste0("[TABLE: ", caption, "]") else "")
      }
      pad <- function(v) c(v, rep("", ncol - length(v)))      # right-pad ragged rows
      row_cells <- lapply(row_cells, pad)
      
      mk_line <- function(v) paste0("| ", paste(v, collapse = " | "), " |")
      # Layout for valid Markdown rendering: [TABLE] and caption, BLANK LINE, the
      # pipe grid (blank-line-flanked so renderers recognize it), BLANK LINE,
      # [/TABLE]. The bracket markers stay as visible plain-text annotation; the
      # blank lines keep them from breaking the grid.
      grid <- character(0)
      grid <- c(grid, mk_line(row_cells[[1]]))                        # header
      grid <- c(grid, mk_line(rep("---", ncol)))                      # md delimiter
      if (length(row_cells) > 1) {
            for (i in 2:length(row_cells)) grid <- c(grid, mk_line(row_cells[[i]]))
      }
      
      lines <- c("", "[TABLE]")
      if (!is.null(caption) && nzchar(caption)) lines <- c(lines, paste0("*", caption, "*"))
      lines <- c(lines, "", grid, "", "[/TABLE]", "")
      paste(lines, collapse = "\n")
}

# ==== Public entry point ========================================================
# PDF path in, reading-order text out. Optionally caches the TEI alongside the
# PDF so re-runs don't re-hit GROBID (extraction is deterministic, so caching is
# safe and saves time on repeated pilot runs).

extract_text_grobid <- function(pdf_path, config = grobid_config,
                                cache_tei = TRUE, chunk_pages = 100) {
      doc_id    <- path_ext_remove(path_file(pdf_path))
      
      # ARTIFACT LAYOUT (single-source-of-truth design):
      #   - TEI cache ({doc_id}.grobid.tei.xml) is the rich upstream source, kept for
      #     citation/section parsing (Theme 5 reference workstream).
      #   - The rendered reading-order TEXT is written ONCE, as the canonical, human-
      #     readable {doc_id}.md in docs_extracted/. THIS SAME .md is what gets sent to
      #     the model (via prepare_document) AND what evidence verification checks
      #     against. There is deliberately no separate "raw" vs "pretty" text: the .md
      #     with its [TABLE]/[page N]/[FIGURE] annotations is the one true text, and
      #     verification normalizes those annotations at compare time.
      cache_loc <- if (!is.null(config$cache_dir)) config$cache_dir else path_dir(pdf_path)
      # docs_extracted/ is a sibling of the docs dir (files-or-subdirs rule); default
      # to config$extracted_dir if set, else a docs_extracted/ next to the cache.
      ext_loc   <- if (!is.null(config$extracted_dir)) config$extracted_dir
      else path(path_dir(cache_loc), "docs_extracted")
      if (cache_tei) { dir_create(cache_loc); dir_create(ext_loc) }
      tei_path  <- path(cache_loc, paste0(doc_id, ".grobid.tei.xml"))
      md_path   <- path(ext_loc, paste0(doc_id, ".md"))
      
      # Canonical-text fast-path: if the .md already exists, it IS the derived text —
      # read it directly (no re-render from TEI), so the scored/verified artifact is
      # exactly the file on disk. This unifies what used to be two derivations
      # (on-the-fly at scoring time vs. extract_corpus's .md) into one file.
      if (cache_tei && file_exists(md_path)) {
            return(paste(readLines(md_path, warn = FALSE), collapse = "\n"))
      }
      
      # No .md yet. If TEI is cached, render from it and write the canonical .md.
      if (cache_tei && file_exists(tei_path)) {
            tei_xml <- paste(readLines(tei_path, warn = FALSE), collapse = "\n")
            txt <- tei_to_text(tei_xml)
            writeLines(txt, md_path)
            return(txt)
      }
      
      # Try whole-document extraction first. If GROBID rejects it for size
      # (TOO_MANY_TOKENS), fall back to page-chunked extraction automatically.
      tei_xml <- tryCatch(
            grobid_process_pdf(pdf_path, config),
            error = function(e) {
                  msg <- conditionMessage(e)
                  # Triggers for the page-chunked fallback. Two distinct "document too big to
                  # process whole" signals from GROBID:
                  #   - TOO_MANY_TOKENS: the text layer exceeds GROBID's 1M-token cap.
                  #   - BAD_INPUT_DATA / "error code: 137": the pdfalto conversion step was
                  #     OOM-killed (137 = SIGKILL, typically out-of-memory) on a large PDF.
                  # Both are fixed by feeding GROBID smaller page ranges. We DON'T fall back
                  # on these for a single-page document — there, "too big" isn't the issue and
                  # chunking can't help, so a genuine bad PDF should surface as an error.
                  size_signal <- grepl("TOO_MANY_TOKENS|too many tokens", msg, ignore.case = TRUE) ||
                        grepl("BAD_INPUT_DATA|error code: 137|conversion failed", msg,
                              ignore.case = TRUE)
                  can_chunk <- tryCatch(pdftools::pdf_length(pdf_path) > 1, error = function(e2) FALSE)
                  
                  if (size_signal && can_chunk) {
                        message("  [", doc_id, "] whole-document extraction failed (",
                                if (grepl("137|BAD_INPUT", msg, ignore.case = TRUE))
                                      "likely OOM during conversion" else "token limit",
                                "); falling back to ", chunk_pages, "-page chunked extraction.")
                        return(NULL)  # signal: go chunked
                  }
                  stop(e)         # not a size problem, or can't chunk — re-raise
            }
      )
      
      if (!is.null(tei_xml)) {
            if (cache_tei) writeLines(tei_xml, tei_path)   # keep TEI (rich source)
            txt <- tei_to_text(tei_xml)
      } else {
            txt <- extract_text_grobid_chunked(pdf_path, config, chunk_pages = chunk_pages)
            # chunked path has no single TEI to cache; the .md below is the canonical text.
      }
      
      # Write the canonical .md — the one artifact scored and verified against.
      if (cache_tei) writeLines(txt, md_path)
      
      if (!nzchar(txt)) {
            warning("GROBID produced empty text for ", doc_id,
                    " — check the TEI; SWAP may have an unusual structure.")
      }
      txt
}

# ==== Multi-PDF documents (a SWAP split across several PDF files) ================
# Many SWAPs ship as a FOLDER of PDFs (e.g. main plan + appendices), not a single
# file. We extract each sub-PDF independently (clean per-file GROBID structure —
# better than merging PDFs, which makes GROBID analyze reading order across the
# seams), then concatenate the per-part text into ONE canonical <doc_id>.md with
# clear part separators. That combined .md is the single source of truth scored
# and verified against, exactly like a single-PDF document — the rest of the
# pipeline is unchanged. Per-part TEI caches are retained (each part has its own
# {part}.grobid.tei.xml) for the deferred citation/Theme 5 work.
#
# `pdf_paths` is ordered; parts are concatenated in that order. `doc_id` is the
# logical document id (the folder name). Returns the combined text and writes the
# canonical <doc_id>.md.
extract_document_multi <- function(doc_id, pdf_paths, config = grobid_config,
                                   cache_tei = TRUE, chunk_pages = 100) {
      ext_loc <- if (!is.null(config$extracted_dir)) config$extracted_dir
      else path(path_dir(if (!is.null(config$cache_dir)) config$cache_dir
                         else path_dir(pdf_paths[[1]])), "docs_extracted")
      if (cache_tei) dir_create(ext_loc)
      md_path <- path(ext_loc, paste0(doc_id, ".md"))
      
      # Canonical-combined fast-path: if the combined .md exists, it IS the document.
      if (cache_tei && file_exists(md_path)) {
            return(paste(readLines(md_path, warn = FALSE), collapse = "\n"))
      }
      
      # Extract each part. We force each part's OWN .md into a per-part subdir so the
      # single-file writer doesn't clobber the combined doc_id.md, but reuse all the
      # existing per-PDF extraction (TEI cache, chunking fallback, .md rendering).
      part_dir <- path(ext_loc, paste0(doc_id, "_parts"))
      if (cache_tei) dir_create(part_dir)
      part_cfg <- modifyList(config, list(extracted_dir = part_dir))
      
      parts <- lapply(seq_along(pdf_paths), function(i) {
            p <- pdf_paths[[i]]
            part_id <- path_ext_remove(path_file(p))
            message("    part ", i, "/", length(pdf_paths), ": ", part_id, " ... ",
                    appendLF = FALSE)
            txt <- tryCatch(
                  extract_text_grobid(p, part_cfg, cache_tei = cache_tei, chunk_pages = chunk_pages),
                  error = function(e) { message("FAILED: ", conditionMessage(e)); "" }
            )
            message(if (nzchar(txt)) paste0("ok (", nchar(txt), " chars)") else "empty")
            list(part_id = part_id, file = path_file(p), text = txt)
      })
      
      # Combine with a clear part separator so the model and a human reader can see
      # the seams, and so evidence `location` can reference which part a quote is in.
      combined <- paste(vapply(parts, function(pt) {
            header <- paste0("\n\n===== DOCUMENT PART: ", pt$file, " =====\n\n")
            paste0(header, pt$text)
      }, character(1)), collapse = "\n")
      combined <- sub("^\n+", "", combined)  # trim leading blank lines
      
      if (cache_tei) writeLines(combined, md_path)
      if (!nzchar(gsub("[[:space:]]|=|DOCUMENTPART:", "", combined))) {
            warning("Multi-PDF document ", doc_id, " produced empty combined text — ",
                    "check that the folder's PDFs extracted correctly.")
      }
      combined
}

# ==== Document discovery (single-PDF files AND multi-PDF folders) ===============
# A "document" in docs_dir is either:
#   - a single <doc_id>.pdf file, OR
#   - a subdirectory <doc_id>/ containing one or more PDFs (a split SWAP).
# Returns a list of documents, each: list(doc_id, pdf_paths, multi = TRUE/FALSE).
# For folders, PDFs are ordered by filename (sorted) — if a specific part order is
# needed, name the files so their sort order matches (e.g. 01_main.pdf,
# 02_appendix.pdf). page_count for a multi-PDF doc is the SUM of its parts.
discover_documents <- function(docs_dir) {
      entries <- dir_ls(docs_dir, recurse = FALSE)
      docs <- list()
      for (e in entries) {
            if (is_dir(e)) {
                  pdfs <- sort(dir_ls(e, glob = "*.pdf", recurse = FALSE))
                  if (length(pdfs) == 0) next  # a folder with no PDFs isn't a document
                  docs[[length(docs) + 1]] <- list(
                        doc_id    = path_file(e),
                        pdf_paths = as.character(pdfs),
                        multi     = TRUE
                  )
            } else if (grepl("\\.pdf$", e, ignore.case = TRUE)) {
                  docs[[length(docs) + 1]] <- list(
                        doc_id    = path_ext_remove(path_file(e)),
                        pdf_paths = as.character(e),
                        multi     = FALSE
                  )
            }
      }
      docs
}

# ==== Chunked extraction (for documents over GROBID's token limit) ==============
# Splits the PDF into page-range sub-PDFs (chunk_pages each), runs each through
# GROBID, converts each TEI to text, and concatenates in page order. Page
# boundaries are safe split points: GROBID does layout analysis per page, so
# splitting between pages doesn't disturb reading order within a page. A chunk
# boundary marker is inserted so you can see where stitching occurred (and so a
# chunk that itself somehow stays oversized is visible rather than silent).
#
# Note: the [page N] markers within each chunk's text come from GROBID's own
# page numbering, which resets per sub-PDF (each chunk starts at its page 1).
# We therefore renumber page markers to the document-global page number using
# the chunk's starting page, so the evidence `location` field stays accurate.

extract_text_grobid_chunked <- function(pdf_path, config = grobid_config,
                                        chunk_pages = 100) {
      doc_id  <- path_ext_remove(path_file(pdf_path))
      n_pages <- pdftools::pdf_length(pdf_path)
      message("  [", doc_id, "] ", n_pages, " pages -> ",
              ceiling(n_pages / chunk_pages), " chunks of ", chunk_pages, " pages.")
      
      tmp_dir <- path(tempdir(), paste0(doc_id, "_chunks"))
      dir_create(tmp_dir)
      on.exit(unlink(tmp_dir, recursive = TRUE), add = TRUE)
      
      starts <- seq(1, n_pages, by = chunk_pages)
      parts <- character(0)
      
      for (start in starts) {
            end <- min(start + chunk_pages - 1, n_pages)
            chunk_pdf <- path(tmp_dir, sprintf("%s_p%04d-%04d.pdf", doc_id, start, end))
            
            # Write the page-range sub-PDF.
            pdftools::pdf_subset(pdf_path, pages = start:end, output = chunk_pdf)
            
            message("    chunk pages ", start, "-", end, " ... ", appendLF = FALSE)
            tei <- tryCatch(
                  grobid_process_pdf(chunk_pdf, config),
                  error = function(e) {
                        msg <- conditionMessage(e)
                        oom <- grepl("137|BAD_INPUT|conversion failed", msg, ignore.case = TRUE)
                        # Surface clearly rather than silently dropping content. The right fix
                        # differs by cause: OOM during conversion -> give GROBID more memory;
                        # token limit -> use smaller page ranges.
                        stop("Chunk pages ", start, "-", end, " failed GROBID: ", msg,
                             if (oom) {
                                   paste0("\n  -> looks like an out-of-memory kill (code 137). ",
                                          "Give the GROBID container more memory, e.g. ",
                                          "docker run --memory=8g ... , and/or retry with ",
                                          "chunk_pages = ", max(1, chunk_pages %/% 2), ".")
                             } else {
                                   paste0("\n  -> retry extract_text_grobid(..., chunk_pages = ",
                                          max(1, chunk_pages %/% 2), ").")
                             })
                  }
            )
            txt <- tei_to_text(tei)
            # Renumber per-chunk [page K] -> document-global [page K + start - 1].
            txt <- .renumber_pages(txt, offset = start - 1)
            parts[[length(parts) + 1]] <- paste0(
                  "\n[chunk: pages ", start, "-", end, "]\n", txt
            )
            message("ok (", nchar(txt), " chars)")
      }
      
      paste(parts, collapse = "\n")
}

# Shift [page N] markers by an offset so chunk-local page numbers become
# document-global. GROBID numbers pages within each sub-PDF starting at 1.
.renumber_pages <- function(txt, offset) {
      if (offset == 0) return(txt)
      # Split on the page markers, capturing them, so we can transform each marker
      # independently and rejoin — robust to duplicate page numbers.
      pieces <- strsplit(txt, "(?=\\[page \\d+\\])", perl = TRUE)[[1]]
      shifted <- vapply(pieces, function(p) {
            m <- regmatches(p, regexpr("^\\[page (\\d+)\\]", p))
            if (length(m) == 0) return(p)
            n <- as.integer(sub("\\[page (\\d+)\\]", "\\1", m))
            sub("^\\[page \\d+\\]", paste0("[page ", n + offset, "]"), p)
      }, character(1))
      paste(shifted, collapse = "")
}


# ==== Usage =====================================================================
# 1. Start GROBID:  docker run -t --rm -p 8070:8070 lfoppiano/grobid:0.8.1
# 2. txt <- extract_text_grobid("data/pilot/docs/VT_SWAP_2015.pdf")
# 3. Inspect:  cat(substr(txt, 1, 3000))   # eyeball reading order on a column page
#    nchar(txt); length(strsplit(txt, "\\s+")[[1]])   # size, rough token proxy
#
# Validate on a multi-column SWAP BEFORE trusting corpus-wide: confirm columns
# read in order, [page N] markers look right, and tables aren't mangled.

# ==== Corpus extraction + quality report ========================================
# Runs extraction over every PDF in a directory, writes each document's text to
# {out_dir}/{doc_id}.txt, and returns a per-document quality report tibble. Run
# this as a deliberate FIRST step for the pilot: inspect the report (and spot-
# check a few .txt files) to confirm extraction quality BEFORE spending money on
# coding. Because TEI is cached, the later coding run reuses this work.
#
# The report flags the things most likely to be wrong with SWAP extraction:
#   - empty / very short output (GROBID failed or doc is scanned-image)
#   - token estimate vs. a payload threshold (does it fit the model's limit?)
#   - table / figure / page-marker counts (sanity on structure detection)
# These are heuristics for triage, not guarantees — eyeball the actual text too.

library(tibble)
library(readr)

extract_corpus <- function(docs_dir,
                           out_dir = path(path_dir(docs_dir),
                                          paste0(path_file(docs_dir), "_extracted")),
                           config = grobid_config,
                           payload_token_warn = 200000) {
      dir_create(out_dir)
      docs <- discover_documents(docs_dir)
      if (length(docs) == 0) stop("No documents (.pdf files or PDF folders) in ", docs_dir)
      n_multi <- sum(vapply(docs, function(d) isTRUE(d$multi), logical(1)))
      message("Extracting ", length(docs), " documents (", n_multi, " multi-PDF)...")
      
      # Point extraction at THIS out_dir as the canonical .md location, so the file
      # extract_text_grobid writes (and that scoring/verification later read) is the
      # same file this corpus pass produces. No separate .md write here — a single
      # source of truth.
      cfg <- modifyList(config, list(extracted_dir = out_dir))
      
      rows <- lapply(docs, function(doc) {
            doc_id <- doc$doc_id
            message("  [", doc_id, "]",
                    if (isTRUE(doc$multi)) paste0(" (", length(doc$pdf_paths), " parts)") else "",
                    " ", appendLF = FALSE)
            
            res <- tryCatch({
                  txt <- if (isTRUE(doc$multi)) {
                        extract_document_multi(doc_id, doc$pdf_paths, cfg)   # writes out_dir/{doc_id}.md
                  } else {
                        extract_text_grobid(doc$pdf_paths[[1]], cfg)          # writes out_dir/{doc_id}.md
                  }
                  
                  # Rough token estimate: ~0.75 words/token -> tokens ~= words / 0.75.
                  # This is a crude proxy; real tokenization differs, but it's good enough
                  # to flag "will this blow the payload limit" triage.
                  words  <- length(strsplit(txt, "\\s+")[[1]])
                  tok_est <- round(words / 0.75)
                  
                  flag <- if (nchar(txt) < 1000) {
                        "EMPTY/SHORT - check (scanned? GROBID fail?)"
                  } else if (tok_est > payload_token_warn) {
                        "LARGE - may exceed payload limit"
                  } else {
                        "ok"
                  }
                  
                  tibble(
                        doc_id        = doc_id,
                        chars         = nchar(txt),
                        words         = words,
                        est_tokens    = tok_est,
                        page_markers  = lengths(regmatches(txt, gregexpr("\\[page ", txt))),
                        table_blocks  = lengths(regmatches(txt, gregexpr("\\[TABLE\\]", txt))),
                        figures       = lengths(regmatches(txt, gregexpr("\\[FIGURE:", txt))),
                        over_payload  = tok_est > payload_token_warn,
                        flag          = flag,
                        status        = "ok"
                  )
            }, error = function(e) {
                  tibble(doc_id = doc_id, chars = NA_integer_, words = NA_integer_,
                         est_tokens = NA_integer_, page_markers = NA_integer_,
                         table_blocks = NA_integer_, figures = NA_integer_,
                         over_payload = NA, flag = paste("EXTRACT ERROR:", conditionMessage(e)),
                         status = "error")
            })
            message(res$flag)
            res
      })
      
      report <- do.call(rbind, rows)
      write_csv(report, path(out_dir, "extraction_report.csv"))
      message("\nReport written to ", path(out_dir, "extraction_report.csv"))
      message("Inspect .txt files in ", out_dir, " before coding — especially any ",
              "flagged EMPTY/SHORT or LARGE.")
      report
}

# ==== Usage =====================================================================
# Start GROBID:  docker run -t --rm -p 8070:8070 lfoppiano/grobid:0.8.1
#
# Single doc (eyeball first):
#   txt <- extract_text_grobid("data/pilot/docs/VT_SWAP_2015.pdf")
#   cat(substr(txt, 1, 3000))
#
# Whole pilot corpus + quality report:
#   report <- extract_corpus("data/pilot/docs")
#   print(report)
#   # then open data/pilot/docs_extracted/*.md and spot-check reading order,
#   # page markers, and tables on a multi-column document before coding.