# ==== SWAP Coding Pipeline ======================================================
# Bulk LLM coding of State Wildlife Action Plans via ellmer.
# Supports Claude Sonnet (primary) and Gemini (long-context / comparison).
# Sequential processing with per-document checkpointing and token capture.
#
# Implements the SINGLE-CALL procedure (extraction_prompt.md v0.4):
#   One API call per document. The model builds the orientation object (a summary
#   + an evidence_index of candidate passages with locations) FIRST, then scores
#   element-by-element drawing on that index, then runs the cross-element check —
#   all in one structured-output call. The document is ingested ONCE, and the
#   cacheable prefix (codebook + dictionary + prompt) stays stable across
#   documents, so cross-document prompt caching works.
#
# Quote verification is a separate, re-runnable postprocessing pass
# (verify_evidence.R) that checks each evidence quote against the source text.

library(ellmer)
library(jsonlite)
library(fs)
library(tibble)
library(readr)

source("pipeline/schema.R")   # load_coding_schema(): JSON Schema -> ellmer types
source("pipeline/grobid_extract.R")  # extract_text_grobid(): PDF -> reading-order text
source("pipeline/verify_evidence.R") # verify_evidence(): quote-vs-source checking
source("pipeline/validate_record.R") # validate_record(): record vs schema contract
source("pipeline/tabulate.R")        # tabulate(): finalized JSON -> analysis CSVs
source("pipeline/batch.R")           # code_batch(), check_batch_status(): batch scoring

# ==== Configuration =============================================================

# ==============================================================================
# CONFIG CONSTRUCTOR
# ==============================================================================
# Build a run config from just source_dir + out_dir. Every phase directory and
# report file DEFAULTS to a conventional location nested under out_dir, so the
# common case is two lines:
#
#   config <- make_config(source_dir = "docs/swap_latest", out_dir = "data/run02")
#
# which yields:
#   data/run02/tei/         (extract: TEI XML, one subdir per doc)
#   data/run02/extracted/   (extract: canonical <doc>.md)
#   data/run02/coded/       (code:    <doc>__<ingest>.rds raw results)
#   data/run02/finalized/   (finalize:<doc>.json validated records)
#   data/run02/extract_report.csv    (extract:  per-doc extraction status/size)
#   data/run02/code_report.csv       (code:     per-doc scoring log — tokens/cost/status)
#   data/run02/finalize_report.csv   (finalize: per-doc schema-validation pass/fail)
#   data/run02/verify_report.csv     (verify:   per-quote evidence-vs-source similarity)
# Records live in the phase subdirs; the four reports sit at the out_dir root, one
# per phase, each named for the phase that writes it (<phase>_report.csv).
#
# ANY directory or report path can be overridden to break the convention — e.g.
# re-finalize a PRIOR run's cache into a fresh finalized dir:
#   make_config("docs/swap_latest", "data/run02", coded_dir = "data/run01/coded")
# Non-path settings (model, prompt files, sampling, etc.) have defaults matching
# the pilot config and can be overridden by name.
make_config <- function(source_dir, out_dir,
                        # --- per-dir / per-report overrides (NULL -> derive from out_dir) ---
                        tei_dir = NULL, extracted_dir = NULL, coded_dir = NULL,
                        finalized_dir = NULL,
                        tables_dir = NULL,
                        extract_report = NULL, code_report = NULL,
                        finalize_report = NULL, verify_report = NULL,
                        tabulate_report = NULL,
                        # --- prompt artifacts ---
                        codebook_file = "pipeline/codebook.md",
                        dictionary_file = "pipeline/concept_dictionary.md",
                        prompt_file = "pipeline/extraction_prompt.md",
                        schema_file = "pipeline/schema.json",
                        schema_merged_file = "pipeline/schema_merged.json",
                        # --- model / provider ---
                        provider = "claude", model_gemini = "gemini-2.5-pro",
                        model_claude = "claude-sonnet-4-6", codebook_version = "0.4",
                        # --- sampling / thinking ---
                        temperature = NULL, max_tokens = 16000,
                        thinking = NULL, thinking_effort = NULL,
                        # --- design axes ---
                        design = "single", ingest = "text",
                        # --- GROBID connection overrides ---
                        url = NULL, endpoint = NULL, timeout_sec = NULL,
                        segment_sentences = NULL,
                        # --- scoring mode / re-run ---
                        scoring_mode = "sequential", overwrite = FALSE,
                        batch_wait = FALSE,
                        verify_threshold = 0.85) {
      list(
            source_dir    = source_dir,
            out_dir       = out_dir,
            # Phase dirs default to conventional subdirs of out_dir; records live here.
            tei_dir       = tei_dir       %||% path(out_dir, "tei"),
            extracted_dir = extracted_dir %||% path(out_dir, "extracted"),
            coded_dir     = coded_dir     %||% path(out_dir, "coded"),
            finalized_dir = finalized_dir %||% path(out_dir, "finalized"),
            tables_dir    = tables_dir    %||% path(out_dir, "tables"),
            # Reports sit at the out_dir ROOT, one per phase, named for the phase that
            # writes it: <phase>_report.csv — same vocabulary as the functions and dirs.
            extract_report  = extract_report  %||% path(out_dir, "extract_report.csv"),
            code_report     = code_report     %||% path(out_dir, "code_report.csv"),
            finalize_report = finalize_report %||% path(out_dir, "finalize_report.csv"),
            verify_report   = verify_report   %||% path(out_dir, "verify_report.csv"),
            tabulate_report = tabulate_report %||% path(out_dir, "tabulate_report.csv"),
            codebook_file = codebook_file, dictionary_file = dictionary_file,
            prompt_file = prompt_file, schema_file = schema_file,
            schema_merged_file = schema_merged_file,
            provider = provider, model_gemini = model_gemini,
            model_claude = model_claude, codebook_version = codebook_version,
            temperature = temperature, max_tokens = max_tokens,
            thinking = thinking, thinking_effort = thinking_effort,
            design = design, ingest = ingest,
            url = url, endpoint = endpoint, timeout_sec = timeout_sec,
            segment_sentences = segment_sentences,
            scoring_mode = scoring_mode, overwrite = overwrite,
            batch_wait = batch_wait,
            verify_threshold = verify_threshold
      )
}

# Default config: a working pilot config so `source("pipeline.R")` gives you
# something to run/tweak immediately. Real runs: call make_config() with your
# source_dir + out_dir (see above).
config <- make_config(source_dir = "data/pilot/source",
                      out_dir    = "data/pilot")


# ==== API key check =============================================================
# ellmer reads keys from environment variables — never pass them in code.
# Set them in .Renviron (usethis::edit_r_environ()), restart R, and .gitignore
# the file. This fails early with a clear message instead of dying mid-corpus.
#   Gemini: GOOGLE_API_KEY (or GEMINI_API_KEY)
#   Claude: ANTHROPIC_API_KEY

check_api_key <- function(provider) {
      if (provider == "gemini") {
            if (Sys.getenv("GOOGLE_API_KEY") == "" && Sys.getenv("GEMINI_API_KEY") == "") {
                  stop("No Gemini key found. Set GOOGLE_API_KEY in .Renviron and restart R.")
            }
      } else if (provider == "claude") {
            if (Sys.getenv("ANTHROPIC_API_KEY") == "") {
                  stop("No Claude key found. Set ANTHROPIC_API_KEY in .Renviron and restart R.")
            }
      }
      invisible(TRUE)
}

# ==== System prompt assembly ====================================================
# Per extraction_prompt.md: system prompt = codebook + concept dictionary +
# the system-prompt portion of extraction_prompt.md (everything below the
# "### SYSTEM PROMPT BEGINS HERE" marker, above "### SYSTEM PROMPT ENDS HERE").
# These ~50K tokens are identical across all documents -> cache aggressively.

build_system_prompt <- function(config) {
      codebook   <- read_file(config$codebook_file)
      dictionary <- read_file(config$dictionary_file)
      prompt_raw <- read_file(config$prompt_file)
      
      # Extract just the system-prompt section of the extraction prompt file.
      sys_section <- sub(
            ".*### SYSTEM PROMPT BEGINS HERE\\s*",
            "",
            prompt_raw
      )
      sys_section <- sub(
            "### SYSTEM PROMPT ENDS HERE.*",
            "",
            sys_section
      )
      if (identical(sys_section, prompt_raw)) {
            warning("System-prompt markers not found in ", config$prompt_file,
                    " — using full file. Check the marker text.")
            sys_section <- prompt_raw
      }
      
      paste(codebook, dictionary, sys_section, sep = "\n\n---\n\n")
}

# ==== User-message instructions =================================================
# One call per document: the model builds the orientation object (summary +
# evidence_index) first, then scores element-by-element drawing on that index,
# then runs the cross-element check, all in a single structured-output call.

# Single-call instructions: the user-message text directing the model to build
# the orientation (summary + evidence_index) first, then score element-by-element
# drawing on that index, then run the cross-element check — all in one call.
singlecall_instructions <- function(doc_id) {
      paste0(
            "Code this document in a single response, producing one JSON record.\n\n",
            "FIRST, build the `orientation` object (the first field of the schema): ",
            "a 3-5 sentence summary (genre/jurisdiction/year, posture toward climate ",
            "change, posture toward range shifts, and what analysis the document ",
            "performs itself versus references), and an `evidence_index` of candidate ",
            "passages with locations that are potentially relevant to any element. ",
            "Build this index BEFORE scoring — it is your notes; be high-recall here ",
            "and apply strict thresholds later. Scoring should draw on this index.\n\n",
            "THEN, apply the codebook element by element in the order in codebook §5 ",
            "(1.1 -> 1.2 -> 1.3 -> 1.4 -> 2.1 -> 2.2 -> 2.3 -> 2.4 -> 3.1 -> 3.2 -> ",
            "3.3 -> 3.4 -> 3.5 -> 3.6 -> 3.7 -> 4.1 -> 4.2 -> 4.3 -> 4.4 -> 4.5), ",
            "drawing on your ",
            "evidence index and the full document. After element-by-element scoring, ",
            "perform the cross-element check and adjust any scores affected by ",
            "cross-cutting evidence. Then emit the final JSON record conforming to the ",
            "schema. Return only the JSON object.\n\n",
            "DOCUMENT ID: ", doc_id
      )
}

# ==== Chat constructor ==========================================================
# A fresh chat per document keeps token accounting per-doc clean.

# Does this model REJECT non-default sampling params (temperature/top_p/top_k)?
# True for Sonnet 5+ and Opus 4.7+ (they 400 on non-default temperature and use
# adaptive thinking instead). For those, we omit temperature and route thinking
# through api_args; for older models (Sonnet 4.6, Gemini) we apply temperature.
.model_rejects_sampling <- function(model_string) {
      grepl("sonnet-5|opus-4-[789]|opus-[5-9]", model_string %||% "", ignore.case = TRUE)
}

make_chat <- function(config, system_prompt) {
      max_tok <- config$max_tokens %||% 16000
      
      if (config$provider == "gemini") {
            p <- params(max_tokens = max_tok)
            if (!is.null(config$temperature)) p <- params(max_tokens = max_tok,
                                                          temperature = config$temperature)
            return(chat_google_gemini(model = config$model_gemini,
                                      system_prompt = system_prompt, params = p))
      }
      if (config$provider != "claude") stop("Unknown provider: ", config$provider)
      
      model <- config$model_claude
      rejects <- .model_rejects_sampling(model)
      
      # Build params(): always max_tokens; add temperature ONLY if the model accepts
      # it (else it's a 400). Applying temperature=0 to 4.6 is a real reproducibility
      # lever; on Sonnet 5 temperature must be omitted.
      p <- if (!rejects && !is.null(config$temperature)) {
            params(max_tokens = max_tok, temperature = config$temperature)
      } else {
            if (rejects && !is.null(config$temperature)) {
                  warning("Model '", model, "' rejects non-default temperature; ",
                          "ignoring config$temperature=", config$temperature,
                          " (would 400). Use system-prompt instructions for style.")
            }
            params(max_tokens = max_tok)
      }
      
      # Thinking (Sonnet 5+): route via api_args. NULL -> model default (adaptive ON
      # for 5). "disabled" turns it off (recommended for tight structured-output
      # budgets); "adaptive" keeps it on, optionally with an effort level. Held
      # constant across a comparison and stamped into coding_meta by the caller.
      api_args <- list()
      if (rejects && !is.null(config$thinking)) {
            th <- if (identical(config$thinking, "disabled")) {
                  list(type = "disabled")
            } else {
                  tt <- list(type = "adaptive")
                  if (!is.null(config$thinking_effort)) tt$effort <- config$thinking_effort
                  tt
            }
            api_args$thinking <- th
      }
      
      chat_anthropic(model = model, system_prompt = system_prompt,
                     params = p,
                     api_args = if (length(api_args)) api_args else list())
}

# ==== Document ingestion ========================================================
# Returns the content to hand the model for a given document, per config$ingest:
#   "pdf"  -> a native PDF content part (model sees rendered layout)
#   "text" -> GROBID reading-order text, wrapped with a short note telling the
#             model what it's reading and how to quote from it.
# The text-path note lives HERE (pipeline-injected), not in extraction_prompt.md,
# so the prompt file stays ingestion-agnostic and the note is sent ONLY when the
# input is actually text — no asking the model to guess its own input format.
# Returns a list: $content (to pass into chat) and $kind ("pdf"|"text").
# `doc` is a document descriptor: list(doc_id, pdf_paths, multi). pdf_paths is a
# character vector — length 1 for a single-PDF document, N for a multi-PDF folder.
prepare_document <- function(doc, config) {
      if (identical(config$ingest, "text")) {
            # Build the GROBID config (connection + TEI-cache/extracted-dir locations) via
            # the single .grobid_cfg() helper, so the TEI cache resolves to the SAME place
            # here (code phase) as in extract() — no divergent fallback that would split
            # the cache across two directories.
            gcfg <- .grobid_cfg(config)
            body <- if (isTRUE(doc$multi)) {
                  extract_document_multi(doc$doc_id, doc$pdf_paths, gcfg)
            } else {
                  extract_text_grobid(doc$pdf_paths[[1]], gcfg)
            }
            multi_note <- if (isTRUE(doc$multi))
                  paste0("This document is assembled from multiple source PDFs; parts are ",
                         "separated by '===== DOCUMENT PART: <filename> =====' markers. Treat ",
                         "it as one document, but you may cite the part filename in `location` ",
                         "when helpful. ") else ""
            note <- paste0(
                  "The document below is TEXT extracted from a PDF via layout-aware ",
                  "extraction (reading order preserved). ", multi_note,
                  "Markers: '## ' = section heading ",
                  "(USE THE NEAREST PRECEDING SECTION HEADING for the evidence `location` ",
                  "field, e.g. 'Ch. 4: Climate Adaptation'); '[TABLE]...[/TABLE]' = tabular ",
                  "region (read row by row); '[FIGURE: ...]' = a figure caption. Printed page ",
                  "numbers occasionally appear as '## pg. N' headings but are not reliable — ",
                  "prefer the descriptive section heading for `location`. Extraction may ",
                  "contain minor artifacts (stray headers/footers, imperfect tables). Quote ",
                  "text AS IT APPEARS here for evidence; do NOT silently correct or reorder ",
                  "it.\n\n",
                  "=== BEGIN DOCUMENT TEXT ===\n", body, "\n=== END DOCUMENT TEXT ==="
            )
            list(content = note, kind = "text")
      } else {
            # Native-PDF ingest for a multi-PDF doc isn't supported (would need PDF merge);
            # text ingest is the committed default and handles multi-PDF. Guard clearly.
            if (isTRUE(doc$multi)) {
                  stop("Multi-PDF documents require ingest='text' (native-pdf ingest can't ",
                       "combine parts). Document: ", doc$doc_id)
            }
            list(content = content_pdf_file(doc$pdf_paths[[1]]), kind = "pdf")
      }
}

# ==== Turn-level usage extraction ===============================================
# get_tokens() doesn't expose the cache split or stop_reason; those live on each
# assistant turn's @json. We walk the turns to sum cache tokens (Anthropic:
# cache_creation_input_tokens / cache_read_input_tokens) and to capture the LAST
# turn's stop_reason — which tells us whether the structured output
# completed ("end_turn"/"stop") or was cut off ("max_tokens"). Gemini reports
# these differently and may be absent; we degrade to NA / NA_character_.
extract_turn_usage <- function(chat) {
      out <- list(cache_creation = NA_integer_, cache_read = NA_integer_,
                  stop_reason = NA_character_)
      turns <- tryCatch(chat$get_turns(), error = function(e) NULL)
      if (is.null(turns) || length(turns) == 0) return(out)
      
      cc <- 0L; cr <- 0L; saw_cache <- FALSE
      for (tn in turns) {
            usage <- tryCatch(tn@json$usage, error = function(e) NULL)
            if (is.null(usage)) next
            if (!is.null(usage$cache_creation_input_tokens)) {
                  cc <- cc + as.integer(usage$cache_creation_input_tokens); saw_cache <- TRUE
            }
            if (!is.null(usage$cache_read_input_tokens)) {
                  cr <- cr + as.integer(usage$cache_read_input_tokens); saw_cache <- TRUE
            }
      }
      if (saw_cache) { out$cache_creation <- cc; out$cache_read <- cr }
      
      # stop_reason from the final assistant turn (the structured call).
      last <- turns[[length(turns)]]
      sr <- tryCatch(last@json$stop_reason, error = function(e) NULL)
      # Gemini uses finishReason; fall back to it if stop_reason is absent.
      if (is.null(sr)) sr <- tryCatch(last@json$finishReason, error = function(e) NULL)
      if (!is.null(sr) && length(sr) == 1) out$stop_reason <- as.character(sr)
      out
}

# ==== Single-document coding ====================================================
# One structured call: the model builds the orientation (summary + evidence_index)
# and scores in a single message, so the document is ingested ONCE and the
# cacheable prefix stays stable across documents (which is what makes
# cross-document prompt caching work). Returns status, the parsed result, the
# orientation summary (surfaced on res for R-level access),
# and token/cache/stop_reason capture. Does NOT write to disk — caller's job.
# Metadata merge happens in finalize_result(), keeping the cached raw result
# pristine so the cheap, re-runnable finalize phase owns all post-processing.
code_document <- function(doc, config, system_prompt, coding_schema) {
      doc_id  <- doc$doc_id
      payload <- prepare_document(doc, config)$content
      chat    <- make_chat(config, system_prompt)
      
      # Physical page count — authoritative, pipeline-owned (not model-guessed).
      # For a multi-PDF document, sum the page counts of all parts. Captured here
      # so finalize can inject it into document_meta; carried on `res` so
      # finalize_from_cache has it without re-opening the PDF(s).
      page_count <- tryCatch(
            sum(vapply(doc$pdf_paths, pdftools::pdf_length, integer(1))),
            error = function(e) NA_integer_)
      
      result <- tryCatch(
            chat$chat_structured(
                  singlecall_instructions(doc_id),
                  payload,
                  type = coding_schema
            ),
            error = function(e) list(.error = conditionMessage(e))
      )
      if (!is.null(result$.error)) {
            return(list(doc_id = doc_id, status = "call_error",
                        error = result$.error, result = NULL,
                        summary = NA_character_,
                        tokens_in = NA_integer_, tokens_out = NA_integer_))
      }
      
      # Metadata merge happens in finalize_result(), not here (see code_document).
      
      tok <- tryCatch(chat$get_tokens(), error = function(e) NULL)
      tokens_in  <- if (!is.null(tok)) sum(tok$input,  na.rm = TRUE) else NA_integer_
      tokens_out <- if (!is.null(tok)) sum(tok$output, na.rm = TRUE) else NA_integer_
      
      usage <- extract_turn_usage(chat)
      status <- if (!is.na(usage$stop_reason) &&
                    usage$stop_reason %in% c("max_tokens", "MAX_TOKENS", "length")) {
            "truncated"
      } else {
            "ok"
      }
      
      # The single call emits the orientation (summary + evidence_index) as the
      # first field of the JSON (orientation.summary is the source of truth). We
      # also surface the summary text on `res` for convenient R-level access (e.g.
      # a corpus-summary helper) — it is NOT written to a separate file.
      summary_txt <- tryCatch(result$orientation$summary, error = function(e) NA_character_)
      if (is.null(summary_txt) || length(summary_txt) == 0) summary_txt <- NA_character_
      
      list(
            doc_id     = doc_id,
            status     = status,
            error      = NA_character_,
            result     = result,
            page_count = page_count,
            summary    = summary_txt,
            tokens_in  = tokens_in,
            tokens_out = tokens_out,
            cache_creation = usage$cache_creation,
            cache_read     = usage$cache_read,
            stop_reason    = usage$stop_reason
      )
}

# ==== JSON array protection =====================================================
# write_json(auto_unbox = TRUE) unboxes every length-1 vector, which is correct
# for scalar fields (score, evaluable, ...) but WRONG for array-typed fields: a
# single-element array like ["SDM"] collapses to the bare string "SDM", which
# then iterates as characters downstream. This walks the record and wraps known
# array-typed fields in I() so jsonlite keeps them as arrays regardless of length,
# while genuine scalars still unbox normally.
#
# Transpose any struct-of-arrays evidence into array-of-structs. Walks the whole
# record; when it finds an `evidence` OR `evidence_index` field shaped like
# {text:[...], location:[...], ...} (parallel arrays), it rebuilds it as
# [{text,location,...}, ...] pairing the i-th element of each field. The single-
# call model exhibits this struct-of-arrays collapse on BOTH the scored-element
# `evidence` arrays and the orientation `evidence_index` (which has 45+ entries
# with fields text/location/relevant_elements). The transpose is field-agnostic,
# so one code path handles both. Array-of-structs (the correct shape) and
# scalar/empty values pass through untouched.
.normalize_evidence <- function(x) {
      if (!is.list(x)) return(x)
      nms <- names(x)
      # Rebuild via lapply over indices (not in-place x[[i]] <- ...), so NULL elements
      # and empty lists can't desync the subscript (the "subscript out of bounds"
      # crash came from x[[i]] <- ... when an element was NULL/absent). Returns a list
      # of exactly length(x), preserving names.
      out <- lapply(seq_along(x), function(i) {
            key <- if (!is.null(nms) && length(nms) >= i && !is.na(nms[[i]])) nms[[i]] else ""
            val <- x[[i]]
            if (key %in% c("evidence", "evidence_index") && is.list(val) &&
                !is.null(names(val)) && "text" %in% names(val)) {
                  # struct-of-arrays: names() present and a `text` field -> transpose.
                  flds <- names(val)
                  n <- length(val$text)
                  if (n == 0) {
                        list()
                  } else if (n == 1) {
                        one <- lapply(flds, function(f) {
                              v <- val[[f]]; if (length(v) >= 1) v[[1]] else NULL
                        })
                        names(one) <- flds
                        list(one)
                  } else {
                        lapply(seq_len(n), function(j) {
                              obj <- lapply(flds, function(f) {
                                    v <- val[[f]]
                                    if (length(v) >= j) v[[j]] else NULL
                              })
                              names(obj) <- flds
                              obj
                        })
                  }
            } else if (is.list(val)) {
                  .normalize_evidence(val)  # recurse only into lists
            } else {
                  val                        # scalars/NULL/atomic pass through untouched
            }
      })
      if (!is.null(nms)) names(out) <- nms
      out
}

# ARRAY_FIELDS lists every schema field whose value is an array of primitives.
# (Arrays of OBJECTS — e.g. `evidence` — don't need this: a length-1 list of
# objects isn't unboxed to a scalar. Only primitive arrays hit the bug.)
# `relevant_elements` (in orientation.evidence_index entries) is a string array
# of element IDs — a single-element one like ["1.4"] would unbox to "1.4" without
# this protection, failing the schema's array type.
.ARRAY_FIELDS <- c("named_tools", "emission_scenarios", "time_horizon_years",
                   "citations", "named_entities", "relevant_elements", "projects")

.protect_arrays <- function(x, key = "") {
      # If THIS node is a known primitive-array field and holds an atomic vector
      # (character/numeric/logical, possibly length 1), force array representation
      # so write_json(auto_unbox=TRUE) doesn't collapse ["SDM"] -> "SDM".
      if (!is.na(key) && key %in% .ARRAY_FIELDS && is.atomic(x) && length(x) >= 1) {
            return(I(x))
      }
      # Recurse into lists/objects. lapply over names() returns a list of EXACTLY
      # the same length as x (one element per input element, even NULLs), so the
      # output length can't desync from the names — avoiding the [[<-]] pitfalls
      # where a NULL return deletes a slot or a multi-element return expands one.
      if (is.list(x)) {
            nms <- names(x)
            idx <- seq_along(x)
            out <- lapply(idx, function(i) {
                  child_key <- if (!is.null(nms) && !is.na(nms[[i]])) nms[[i]] else ""
                  .protect_arrays(x[[i]], key = child_key)
            })
            if (!is.null(nms)) names(out) <- nms
            return(out)
      }
      # Atomic, non-array-field: leave as-is (scalars unbox normally).
      x
}

# ==== Logging helper ============================================================

# Upsert one row into the run log, keyed by doc_id: if a row for this doc_id
# already exists (from a prior run of the same doc), it is REPLACED, not
# duplicated. This keeps the log at exactly one row per doc so re-running a single
# doc (via code_one or the code() phase) leaves a correct log — and the cost/agreement
# harness, which reads this log, never averages over stale or double-counted rows.
# The replaced row is dropped wholesale; the new row wins (last-write-wins per doc).
append_log <- function(log_file, row) {
      dir_create(path_dir(log_file))
      new_row <- as_tibble(row)
      if (file_exists(log_file)) {
            existing <- tryCatch(
                  readr::read_csv(log_file, show_col_types = FALSE,
                                  col_types = readr::cols(.default = "c")),
                  error = function(e) NULL)
            if (!is.null(existing) && "doc_id" %in% names(existing)) {
                  # Drop any prior row(s) for this doc_id, then re-append all.
                  keep <- existing[as.character(existing$doc_id) !=
                                         as.character(new_row$doc_id[[1]]), , drop = FALSE]
                  # Coerce new_row to character cols to match the re-read frame,
                  # so rbind aligns types (read_csv-as-character avoids type drift).
                  new_chr <- new_row
                  new_chr[] <- lapply(new_chr, as.character)
                  # Align columns (in case schema differs across versions): union
                  # of columns, missing filled with NA, then rbind.
                  all_cols <- union(names(keep), names(new_chr))
                  for (cc in setdiff(all_cols, names(keep)))    keep[[cc]]    <- NA_character_
                  for (cc in setdiff(all_cols, names(new_chr))) new_chr[[cc]] <- NA_character_
                  combined <- rbind(keep[all_cols], new_chr[all_cols])
                  readr::write_csv(combined, log_file)
                  return(invisible(TRUE))
            }
      }
      # No existing log (or no doc_id column) — write/append fresh.
      write_csv(new_row, log_file, append = file_exists(log_file))
      invisible(TRUE)
}

# ==== Raw-result cache + finalize (two-phase: score once, finalize cheaply) =====
# Scoring (the API call) is expensive; post-processing (metadata merge, array
# protection, JSON write, validation) is cheap but iterate-heavy while debugging
# edge cases. We split them: code_document() returns the raw result, which we
# saveRDS to a cache; finalize turns a cached result into the final JSON. This
# means (a) debugging post-processing costs zero API calls — re-run finalize over
# the cache — and (b) a finalize crash mid-corpus never wastes paid scoring,
# since every scored result is durably cached and finalize is re-runnable.
#
# Cache is keyed by doc_id AND ingest mode (pdf/text results must not collide).

.cache_path <- function(config, doc_id) {
      dir_create(config$coded_dir)
      path(config$coded_dir, paste0(doc_id, "__", config$ingest %||% "text", ".rds"))
}

# Turn a raw scored result (res, as returned by code_document) into the final
# on-disk JSON. This is ALL the post-processing — metadata merge,
# array protection, truncation routing, file writes — in one re-runnable place.
finalize_result <- function(res, config) {
      doc_id <- res$doc_id
      if (is.null(res$result)) {
            message("  [finalize] ", doc_id, ": no result (status=", res$status, "); skipped.")
            return(invisible(FALSE))
      }
      dir_create(config$finalized_dir)
      out_path <- path(config$finalized_dir, paste0(doc_id, ".json"))
      
      # ---- normalize evidence shape ----------------------------------------------
      # Single-call sometimes emits evidence as a struct-of-arrays
      # ({text:[...], location:[...]}) instead of the schema's array-of-structs
      # ([{text,location}, ...]). Transpose it back so downstream (verbatim-quote
      # verification, per-evidence analysis) sees uniform array-of-structs.
      result <- .normalize_evidence(res$result)
      
      # ---- metadata merge (moved here from the scoring functions) ----------------
      # Every comparison axis is stamped as a FIRST-CLASS field so records fully
      # self-describe their provenance and the comparison harness can group/confound-
      # check on them without sniffing free-text notes. Axes: model, provider,
      # codebook_version, ingest, design. `coder` kept for backward-compat display.
      model_string <- config[[paste0("model_", config$provider)]]
      result$coding_meta <- list(
            coder            = paste0("llm:", model_string),   # legacy display field
            model            = model_string,                    # structured: exact model id
            provider         = config$provider,                 # "claude" | "gemini"
            codebook_version = config$codebook_version,
            ingest           = config$ingest %||% "text",
            design           = config$design %||% "single",     # structured axis
            temperature      = config$temperature %||% NA,       # sampling provenance (NA if
            #   model default / omitted)
            thinking         = config$thinking %||% NA,          # Sonnet 5+ thinking mode
            thinking_effort  = config$thinking_effort %||% NA,   # Sonnet 5+ effort level
            coded_at         = format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC"),
            notes            = NULL
      )
      if (is.null(result$document_meta)) result$document_meta <- list()
      result$document_meta$document_id <- doc_id
      # Pipeline-owned, authoritative physical page count. Normally captured at scoring
      # time (res$page_count). If the cached result predates that capture (e.g. an .rds
      # from an older pipeline), fall back to computing it now from the source PDF(s)
      # under source_dir — so re-finalizing old records still gets a valid page_count.
      pc <- res$page_count
      if (is.null(pc) || is.na(pc)) {
            pc <- tryCatch({
                  src <- if (!is.null(config$source_dir)) {
                        # single file <doc>.pdf, or a multi-PDF folder <doc>/
                        f <- path(config$source_dir, paste0(doc_id, ".pdf"))
                        d <- path(config$source_dir, doc_id)
                        if (file_exists(f)) f else if (dir_exists(d)) as.character(dir_ls(d, glob = "*.pdf")) else character(0)
                  } else character(0)
                  if (length(src) == 0) NA_integer_
                  else sum(vapply(src, pdftools::pdf_length, integer(1)))
            }, error = function(e) NA_integer_)
      }
      if (!is.null(pc) && !is.na(pc)) {
            result$document_meta$page_count <- as.integer(pc)
      }
      
      # ---- array protection + write ----------------------------------------------
      result_out <- .protect_arrays(result)
      if (identical(res$status, "truncated")) {
            write_json(result_out, path(config$finalized_dir, paste0(doc_id, ".truncated.json")),
                       auto_unbox = TRUE, pretty = TRUE)
      } else {
            write_json(result_out, out_path, auto_unbox = TRUE, pretty = TRUE)
      }
      
      # ---- schema validation (codebook §7) ---------------------------------------
      # Validate the finalized record against schema_merged.json (the contract):
      # per-element score ranges, required fields, correct types. Flag-not-block —
      # the record is already written; a failure is surfaced for review, not
      # discarded. Runs at zero API cost and is re-run by finalize().
      #
      # We append a row for EVERY doc (passed or failed), so the report is a COMPLETE
      # per-run picture that reflects current state — not a failures-only, append-
      # forever file that can show stale failures a later fix has already resolved.
      # The finalize() phase clears this file once at the start of the run (see
      # .reset_validation_report), so each run's report reflects only that run.
      v <- validate_record(result_out, config$schema_merged_file)
      vlog <- config$finalize_report %||% path(config$finalized_dir, "finalize_report.csv")
      readr::write_csv(
            data.frame(doc_id  = doc_id,
                       passed  = isTRUE(v$ok),
                       n_errors = if (isTRUE(v$ok)) 0L else v$n_errors,
                       errors  = if (isTRUE(v$ok)) "" else paste(v$errors, collapse = " | "),
                       stringsAsFactors = FALSE),
            vlog, append = file_exists(vlog))
      if (isFALSE(v$ok)) {
            message("  [validate] ", doc_id, " FAILED schema validation (",
                    v$n_errors, " issue", if (v$n_errors != 1) "s" else "", "): ",
                    substr(paste(v$errors, collapse = " | "), 1, 200))
      } else {
            message("  [validate] ", doc_id, " ok")
      }
      
      invisible(TRUE)
}


# ==============================================================================
# HORIZONTAL PIPELINE PHASES
# ==============================================================================
# The corpus is processed one PHASE at a time (not one doc at a time). Each phase
# reads the previous phase's output directory and writes its own, so intermediate
# results are saved after every step and every phase is independently re-runnable:
#
#   source_dir  --extract()-->  extracted_dir  --code()-->  coded_dir
#     (.pdf)                       (.md)                      (.rds)
#                                                               |
#                              finalized_dir  <--finalize()----+
#                                (.json)          |
#                                                 +--verify()--> verification CSV
#
#   run_all(config) runs extract -> code -> finalize -> verify in sequence.
#
# All phases share ONE config and are idempotent: with overwrite=FALSE they SKIP
# docs whose output already exists (resumable after an interruption); overwrite=
# TRUE forces re-processing.
# ==============================================================================

# Fail-fast GROBID readiness guard. Only relevant for ingest="text" (the GROBID
# path). Does NOT launch anything and creates NO Docker dependency: it runs the
# health check ONLY if grobid_docker.R has been sourced (grobid_is_alive exists).
# If that module isn't loaded, this is a silent no-op.
.check_grobid_ready <- function(config) {
      if (!identical(config$ingest, "text")) return(invisible(TRUE))
      if (!exists("grobid_is_alive")) return(invisible(TRUE))  # docker module not sourced
      url  <- config$url %||% grobid_config$url %||% "http://localhost:8070"
      port <- suppressWarnings(as.integer(sub(".*:(\\d+).*", "\\1", url)))
      if (is.na(port)) port <- 8070
      if (!grobid_is_alive(port)) {
            stop("GROBID is not reachable on :", port, ". Start it first --\n",
                 "  source(\"pipeline/grobid_docker.R\"); ensure_grobid()\n",
                 "-- or launch it manually, then re-run.")
      }
      invisible(TRUE)
}

# Build the grobid config (connection + phase dir locations) from the run config.
# Build the grobid config (connection + phase dir locations) from the run config.
# The TEI XML goes to tei_dir (a first-class phase output); grobid_extract.R's
# internal field for that location is `cache_dir`, so we map tei_dir -> cache_dir.
.grobid_cfg <- function(config) {
      modifyList(grobid_config, list(
            cache_dir     = config$tei_dir %||%
                  path(path_dir(config$extracted_dir), "tei"),
            extracted_dir = config$extracted_dir,
            url           = config$url        %||% grobid_config$url,
            endpoint      = config$endpoint   %||% grobid_config$endpoint,
            timeout_sec   = config$timeout_sec %||% grobid_config$timeout_sec,
            segment_sentences = config$segment_sentences %||% grobid_config$segment_sentences
      ))
}

# ---- PHASE 1: extract ---------------------------------------------------------
# source_dir (.pdf files and/or multi-PDF folders) -> extracted_dir/<doc>.md
# Sequential (GROBID is not safe to hit concurrently). Per-doc errors (e.g. a
# GROBID timeout) are caught so one bad doc never halts corpus extraction; failed
# docs appear in the returned report with status="error". Idempotent: skips docs
# whose .md already exists unless overwrite=TRUE.
extract <- function(config) {
      .check_grobid_ready(config)
      dir_create(config$extracted_dir)
      dir_create(config$tei_dir %||% path(path_dir(config$extracted_dir), "tei"))
      gcfg <- .grobid_cfg(config)
      docs <- discover_documents(config$source_dir)
      if (length(docs) == 0) stop("No documents (.pdf or PDF folders) in ",
                                  config$source_dir)
      n_multi <- sum(vapply(docs, function(d) isTRUE(d$multi), logical(1)))
      message("[extract] ", length(docs), " documents (", n_multi,
              " multi-PDF) -> ", config$tei_dir, " (.xml) + ",
              config$extracted_dir, " (.md)")
      
      rows <- lapply(docs, function(doc) {
            md_path <- path(config$extracted_dir, paste0(doc$doc_id, ".md"))
            if (file_exists(md_path) && !isTRUE(config$overwrite)) {
                  message("  [skip] ", doc$doc_id, " (.md exists)")
                  return(data.frame(doc_id = doc$doc_id, status = "skipped",
                                    chars = NA_integer_, stringsAsFactors = FALSE))
            }
            message("  [", doc$doc_id, "]",
                    if (isTRUE(doc$multi)) paste0(" (", length(doc$pdf_paths), " parts)")
                    else "", " ... ", appendLF = FALSE)
            tryCatch({
                  txt <- if (isTRUE(doc$multi))
                        extract_document_multi(doc$doc_id, doc$pdf_paths, gcfg)
                  else  extract_text_grobid(doc$pdf_paths[[1]], gcfg)
                  message(nchar(txt), " chars")
                  data.frame(doc_id = doc$doc_id, status = "ok",
                             chars = nchar(txt), stringsAsFactors = FALSE)
            }, error = function(e) {
                  message("FAILED: ", conditionMessage(e))
                  data.frame(doc_id = doc$doc_id, status = "error",
                             chars = NA_integer_, stringsAsFactors = FALSE)
            })
      })
      report <- do.call(rbind, rows)
      # Persist the extraction report so extraction outcomes are recoverable from
      # disk — essential when extract and code are separated in time (extract the
      # corpus now, batch-score later): come back and see which docs failed to
      # extract before committing to scoring. Overwrites each run (current state).
      erp <- config$extract_report %||% path(config$out_dir %||% config$extracted_dir,
                                             "extract_report.csv")
      tryCatch(write_csv(report, erp), error = function(e)
            message("  (could not write extract_report: ", conditionMessage(e), ")"))
      n_err <- sum(report$status == "error")
      message("[extract] done: ", sum(report$status == "ok"), " ok, ",
              sum(report$status == "skipped"), " skipped, ", n_err, " failed.")
      if (n_err > 0) message("  failed: ",
                             paste(report$doc_id[report$status == "error"], collapse = ", "))
      invisible(report)
}

# ---- PHASE 2: code ------------------------------------------------------------
# extracted_dir (.md, via discover_documents on source_dir) -> coded_dir/<doc>.rds
# Sends each doc to the model, writes the RAW result (+ token/cache/stop_reason
# metadata) as .rds. Does NOT finalize — that's a separate phase. Per-doc errors
# are caught and logged; the run continues. Idempotent: skips docs whose .rds
# exists unless overwrite=TRUE. Sequential now; batch is a stub (see code_batch).
code <- function(config) {
      if (identical(config$scoring_mode %||% "sequential", "batch")) {
            return(code_batch(config))
      }
      check_api_key(config$provider)
      .check_grobid_ready(config)
      dir_create(config$coded_dir)
      system_prompt <- build_system_prompt(config)
      coding_schema <- load_coding_schema(config$schema_file)
      docs <- discover_documents(config$source_dir)
      message("[code] ", length(docs), " documents -> ", config$coded_dir,
              " (model=", config[[paste0("model_", config$provider)]], ")")
      
      for (doc in docs) {
            rds_path <- .cache_path(config, doc$doc_id)
            if (file_exists(rds_path) && !isTRUE(config$overwrite)) {
                  message("  [skip] ", doc$doc_id, " (.rds exists)"); next
            }
            message("  [", doc$doc_id, "]",
                    if (isTRUE(doc$multi)) paste0(" (", length(doc$pdf_paths), " parts)")
                    else "", " ... ", appendLF = FALSE)
            t0 <- Sys.time()
            tryCatch({
                  res <- code_document(doc, config, system_prompt, coding_schema)
                  dt  <- round(as.numeric(difftime(Sys.time(), t0, units = "secs")), 1)
                  # Persist the raw result (even on non-ok status, if a result
                  # exists) so finalize/inspection can use it.
                  if (!is.null(res$result)) saveRDS(res, rds_path)
                  .log_code_row(config, res, dt)
                  message(res$status, " (", dt, "s)",
                          if (!identical(res$status, "ok"))
                                paste0(" >> ", res$error %||% "") else "")
            }, error = function(e) {
                  dt <- round(as.numeric(difftime(Sys.time(), t0, units = "secs")), 1)
                  message("FAILED (", dt, "s) >> ", substr(conditionMessage(e), 1, 200),
                          "\n         [skipped; continuing]")
                  .log_code_row(config, list(doc_id = doc$doc_id, status = "doc_error",
                                             error = conditionMessage(e)), dt)
            })
      }
      message("[code] done. Raw results in ", config$coded_dir,
              "; run finalize(config) next.")
      invisible(TRUE)
}

# code_batch() and check_batch_status() are defined in batch.R (sourced above) —
# the batch scoring band (Anthropic Message Batches API via ellmer, ~50% cheaper,
# async up to 24h). code() routes to code_batch() when scoring_mode="batch"; the
# batch writes coded_dir/<doc>.rds in the SAME shape code_document() returns, so
# finalize()/verify()/tabulate() consume batch and sequential output identically.

# Shared log-row writer for the code phase (upsert keyed by doc_id).
.log_code_row <- function(config, res, dt) {
      append_log(config$code_report, list(
            doc_id     = res$doc_id,
            status     = res$status,
            error      = substr(res$error %||% NA_character_, 1, 300),
            tokens_in  = res$tokens_in %||% NA_integer_,
            tokens_out = res$tokens_out %||% NA_integer_,
            cache_creation = res$cache_creation %||% NA_integer_,
            cache_read     = res$cache_read %||% NA_integer_,
            stop_reason    = res$stop_reason %||% NA_character_,
            seconds    = dt,
            provider   = config$provider,
            timestamp  = format(Sys.time(), "%Y-%m-%d %H:%M:%S")
      ))
}

# ---- PHASE 3: finalize --------------------------------------------------------
# coded_dir/<doc>.rds -> finalized_dir/<doc>.json (+ finalize_report.csv)
# Normalizes evidence shape, merges metadata, protects arrays, writes final JSON,
# and validates against the merged schema contract. No API cost — fully
# re-runnable after any post-processing fix. Reads all .rds for the current
# ingest mode. Idempotent via overwrite (re-finalizes existing JSON if TRUE).
finalize <- function(config) {
      if (!dir_exists(config$coded_dir)) stop("No coded_dir: ", config$coded_dir)
      dir_create(config$finalized_dir)
      mode <- config$ingest %||% "text"
      rds <- dir_ls(config$coded_dir, glob = paste0("*__", mode, ".rds"))
      if (length(rds) == 0) {
            message("[finalize] no coded results for ingest='", mode, "' in ",
                    config$coded_dir); return(invisible())
      }
      message("[finalize] ", length(rds), " coded results -> ", config$finalized_dir)
      # Start a fresh validation report for THIS run (see per-doc writes below).
      vlog <- config$finalize_report %||% path(config$finalized_dir, "finalize_report.csv")
      if (file_exists(vlog)) file_delete(vlog)
      val_rows <- list()
      for (f in rds) {
            res <- readRDS(f)
            json_path <- path(config$finalized_dir, paste0(res$doc_id, ".json"))
            skip_write <- file_exists(json_path) && !isTRUE(config$overwrite)
            # Always finalize_result unless the JSON already exists AND we're not
            # overwriting — BUT even when we skip the (re)write, we still validate
            # the existing record and record a report row, so finalize_report.csv
            # reflects the CURRENT STATE OF THE WHOLE finalized set, not just the
            # docs this run happened to rewrite.
            if (skip_write) {
                  v <- validate_json_file(json_path, config$schema_merged_file)
                  val_rows[[length(val_rows) + 1]] <- data.frame(
                        doc_id = res$doc_id, passed = isTRUE(v$ok),
                        n_errors = if (isTRUE(v$ok)) 0L else (v$n_errors %||% NA_integer_),
                        errors = if (isTRUE(v$ok)) "" else paste(v$errors, collapse = " | "),
                        stringsAsFactors = FALSE)
                  message("  [skip] ", res$doc_id, " (.json exists; validated)")
                  next
            }
            ok <- tryCatch(finalize_result(res, config),
                           error = function(e) { message("  [finalize ERROR] ",
                                                         res$doc_id, ": ", conditionMessage(e)); FALSE })
            message("  ", if (isTRUE(ok)) "[ok] " else "[--] ", res$doc_id)
      }
      # finalize_result() writes its own report rows for docs it (re)finalized;
      # append the rows we collected for skipped-but-validated docs so the report
      # is complete. (Read-back + re-append keeps a single consistent file.)
      if (length(val_rows) > 0) {
            skipped_df <- do.call(rbind, val_rows)
            existing <- if (file_exists(vlog))
                  tryCatch(readr::read_csv(vlog, show_col_types = FALSE),
                           error = function(e) NULL) else NULL
            readr::write_csv(if (is.null(existing)) skipped_df
                             else rbind(existing, skipped_df), vlog)
      }
      message("[finalize] done. Final records in ", config$finalized_dir)
      invisible(TRUE)
}

# ---- PHASE 4: verify ----------------------------------------------------------
# finalized_dir/<doc>.json + extracted_dir/<doc>.md -> verify_report.csv
# Checks every evidence quote against the canonical source text (the same .md the
# model scored). No API cost. Thin wrapper over verify_corpus(), which reads the
# coded .rds cache and the .md source.
verify <- function(config, threshold = NULL) {
      threshold <- threshold %||% config$verify_threshold %||% 0.85
      message("[verify] checking evidence quotes against source .md ...")
      verify_corpus(config, threshold = threshold)
}

# ---- run_all: the four phases in sequence -------------------------------------
# extract -> code -> finalize -> verify, sharing one config. Each phase saves its
# intermediate output, so you can also run them individually or resume after an
# interruption. For batch scoring, set config$scoring_mode="batch" (stub for now).
run_all <- function(config, do_verify = TRUE, do_tabulate = TRUE) {
      message("==== run_all: extract -> code -> finalize",
              if (do_verify) " -> verify" else "",
              if (do_tabulate) " -> tabulate" else "", " ====")
      extract(config)
      code(config)
      finalize(config)
      if (do_verify) verify(config)
      if (do_tabulate) tabulate(config)
      message("==== run_all complete ====")
      invisible(read_csv(config$code_report, show_col_types = FALSE))
}

# ---- code_one: single-doc convenience (iteration / spot-checks) ---------------
# Runs one doc through code + finalize (not the whole corpus). `doc_path` may be a
# single .pdf or a folder of PDFs. Upserts the log row. For quick checks and the
# cache test (call twice, inspect cache_read on the second).
code_one <- function(doc_path, config, return_res = TRUE) {
      check_api_key(config$provider)
      .check_grobid_ready(config)
      dir_create(config$coded_dir)
      system_prompt <- build_system_prompt(config)
      coding_schema <- load_coding_schema(config$schema_file)
      
      doc <- if (dir_exists(doc_path)) {
            list(doc_id = path_file(doc_path),
                 pdf_paths = as.character(sort(dir_ls(doc_path, glob = "*.pdf"))),
                 multi = TRUE)
      } else {
            list(doc_id = path_ext_remove(path_file(doc_path)),
                 pdf_paths = as.character(doc_path), multi = FALSE)
      }
      
      message("[code_one] ", doc$doc_id, " (ingest=", config$ingest %||% "text",
              if (isTRUE(doc$multi)) paste0(", ", length(doc$pdf_paths), " parts") else "",
              ") ... ", appendLF = FALSE)
      t0  <- Sys.time()
      res <- code_document(doc, config, system_prompt, coding_schema)
      dt  <- round(as.numeric(difftime(Sys.time(), t0, units = "secs")), 1)
      message(res$status, " (", dt, "s)")
      
      if (!is.null(res$result)) saveRDS(res, .cache_path(config, doc$doc_id))
      finalize_result(res, config)
      .log_code_row(config, res, dt)
      
      message(sprintf("  tokens_in=%s tokens_out=%s cache_creation=%s cache_read=%s",
                      res$tokens_in %||% NA, res$tokens_out %||% NA,
                      res$cache_creation %||% NA, res$cache_read %||% NA))
      if (return_res) invisible(res) else invisible(NULL)
}

# ---- Example -----------------------------------------------------------------
# source("pipeline/grobid_docker.R"); ensure_grobid()   # start GROBID
# extract(config)      # PDFs  -> .md
# code(config)         # .md   -> .rds   (raw model results)
# finalize(config)     # .rds  -> .json  (validated final records)
# verify(config)       # .json -> verify_report.csv
# # or all at once:
# run_all(config)