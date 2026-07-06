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

# ==== Configuration =============================================================

config <- list(
      # ---- Inputs & outputs ----------------------------------------------------
      docs_dir       = "docs/swap",            # SWAP sources: one .pdf per doc,
      #   OR a subfolder of PDFs per doc
      #   (multi-PDF SWAPs). Both discovered.
      out_dir        = "data/swap",    # per-doc JSON results land here.
      #   CHANGE THIS per variance rep so each
      #   rep re-scores into its own folder.
      log_file       = "data/swap/run_log.csv",
      
      # ---- Prompt artifacts ----------------------------------------------------
      # The system prompt is the concatenation of these three, in this order (per
      # extraction_prompt.md "How to use this file"):
      #   codebook -> concept dictionary -> extraction prompt (system-prompt portion).
      codebook_file  = "pipeline/codebook.md",
      dictionary_file = "pipeline/concept_dictionary.md",
      prompt_file    = "pipeline/extraction_prompt.md",
      schema_file    = "pipeline/schema.json",          # model-facing (generation)
      schema_merged_file = "pipeline/schema_merged.json", # validation contract
      
      # ---- Model / provider ----------------------------------------------------
      provider       = "claude",               # "gemini" | "claude"
      model_gemini   = "gemini-2.5-pro",
      model_claude   = "claude-sonnet-4-6",    # 4-6 or 5
      codebook_version = "0.4",                # stamped into coding_meta
      
      # ---- Sampling / thinking (model-dependent — see make_chat) ---------------
      # temperature: applied ONLY to models that accept non-default sampling.
      #   Sonnet 4.6 and earlier accept it (use 0 for max reproducibility). Sonnet 5
      #   / Opus 4.7+ REJECT non-default temperature/top_p/top_k with a 400 error —
      #   make_chat omits it for those models automatically. NULL = provider default.
      temperature    = NULL,                     # e.g. 0 for 4.6 reproducibility
      max_tokens     = 16000,                    # cap on output tokens. NOTE: on
      #   Sonnet 5, adaptive thinking is ON by
      #   default and its thinking tokens count
      #   against this — raise it (or disable
      #   thinking) or structured output may
      #   truncate. 4.6 doesn't have this issue.
      thinking       = NULL,                     # Sonnet 5+ only. NULL = model default
      #   (adaptive ON for 5). "disabled" turns
      #   thinking off; "adaptive" keeps it on.
      thinking_effort = NULL,                    # Sonnet 5+ only: "low"|"medium"|"high"|
      #   "xhigh"|"max" (default high). Hold
      #   constant + stamp for clean comparison.
      
      # ---- Design axes (stamped into coding_meta for the comparison harness) ----
      design         = "single",               # single-call: orientation (summary +
      #   evidence_index) emitted as the first
      #   JSON field, then scoring, then
      #   cross-check, all in one cached call.
      ingest         = "text",                  # "text" (GROBID reading-order text) |
      #   "pdf" (native, content_pdf_file).
      #   text is the committed default: ~7x
      #   cheaper, fits big docs, and is the
      #   source of truth for evidence
      #   verification. pdf retained for compare.
      
      # ---- Extraction cache locations (GROBID / .md) ---------------------------
      # IMPORTANT: these are INDEPENDENT of out_dir. They control where the TEI
      # cache and the canonical .md live. Keeping them CONSTANT across variance
      # reps is what holds extraction fixed so you measure pure model noise —
      # changing only out_dir reuses these automatically.
      cache_dir      = NULL,                    # dir for GROBID TEI cache. NULL ->
      #   grobid_config$cache_dir (else beside
      #   the PDF). Set a path to keep TEI out
      #   of the docs folder.
      extracted_dir  = NULL,                    # dir for canonical <doc_id>.md (the text
      #   scored AND verified against). NULL ->
      #   a docs_extracted/ beside cache_dir.
      #   This is the single source of truth.
      
      # ---- GROBID connection overrides -----------------------------------------
      # NULL = inherit from grobid_config (url/endpoint/timeout/segmentation). Set
      # here only to override the GROBID service for THIS run (rarely needed).
      url            = NULL,                     # e.g. "http://localhost:8070"
      endpoint       = NULL,                     # e.g. "/api/processFulltextDocument"
      timeout_sec    = NULL,                     # GROBID request timeout (large SWAPs)
      segment_sentences = NULL,                  # GROBID sentence segmentation flag
      
      # ---- Raw-result cache & re-run behavior ----------------------------------
      result_cache   = NULL,                    # dir for cached raw model results
      #   (saveRDS). NULL -> out_dir/_raw_cache.
      #   Enables finalize_from_cache() to
      #   re-run post-processing cost-free.
      #   Tied to out_dir, so it's per-rep too.
      overwrite      = FALSE                     # skip docs already coded unless TRUE.
      #   Set TRUE (or use a fresh out_dir) for
      #   variance reps, or they silently SKIP
      #   already-coded docs -> fake zero variance.
)

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
            # Extraction needs GROBID CONNECTION fields (url/endpoint, from grobid_config)
            # AND the run's location fields (cache_dir/extracted_dir), so it reads/writes
            # the same canonical .md the rest of the run uses. Merge the run's location
            # overrides onto grobid_config rather than replacing it (replacing dropped the
            # url and broke the connection).
            gcfg <- modifyList(grobid_config, list(
                  cache_dir     = config$cache_dir     %||% grobid_config$cache_dir,
                  extracted_dir = config$extracted_dir %||% grobid_config$extracted_dir
            ))
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
# orientation summary (surfaced from the JSON for the _pass1.txt sidecar / QA),
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
      
      # The single call now emits the orientation (summary + evidence_index) as the
      # first field of the JSON. Surface the summary text so the _pass1.txt sidecar
      # and any QA continue to work — no separate orientation API call needed.
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
# doc (via code_one or run_pipeline) leaves a correct log — and the cost/agreement
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
      cache_dir <- config$result_cache %||% path(config$out_dir, "_raw_cache")
      dir_create(cache_dir)
      path(cache_dir, paste0(doc_id, "__", config$ingest %||% "pdf", ".rds"))
}

# Turn a raw scored result (res, as returned by code_document) into the final
# on-disk JSON + pass1 sidecar. This is ALL the post-processing — metadata merge,
# array protection, truncation routing, file writes — in one re-runnable place.
finalize_result <- function(res, config) {
      doc_id <- res$doc_id
      if (is.null(res$result)) {
            message("  [finalize] ", doc_id, ": no result (status=", res$status, "); skipped.")
            return(invisible(FALSE))
      }
      out_path <- path(config$out_dir, paste0(doc_id, ".json"))
      
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
      # Pipeline-owned, authoritative physical page count (from pdftools::pdf_length
      # at scoring time). Overrides any value the model may have guessed. NA only if
      # the PDF couldn't be read.
      if (!is.null(res$page_count) && !is.na(res$page_count)) {
            result$document_meta$page_count <- as.integer(res$page_count)
      }
      
      # ---- array protection + write ----------------------------------------------
      result_out <- .protect_arrays(result)
      if (identical(res$status, "truncated")) {
            write_json(result_out, path(config$out_dir, paste0(doc_id, ".truncated.json")),
                       auto_unbox = TRUE, pretty = TRUE)
      } else {
            write_json(result_out, out_path, auto_unbox = TRUE, pretty = TRUE)
      }
      if (!is.na(res$summary %||% NA_character_)) {
            write_file(res$summary, path(config$out_dir, paste0(doc_id, "_pass1.txt")))
      }
      
      # ---- schema validation (codebook §7) ---------------------------------------
      # Validate the finalized record against schema_merged.json (the contract):
      # per-element score ranges, required fields, correct types. Flag-not-block —
      # the record is already written; a failure is surfaced for review, not
      # discarded. Runs at zero API cost and is re-run by finalize_from_cache().
      v <- validate_record(result_out, config$schema_merged_file)
      if (isFALSE(v$ok)) {
            message("  [validate] ", doc_id, " FAILED schema validation (",
                    v$n_errors, " issue", if (v$n_errors != 1) "s" else "", "): ",
                    substr(paste(v$errors, collapse = " | "), 1, 200))
            # Append to a per-run validation log so failures are auditable in bulk.
            vlog <- path(config$out_dir, "validation_failures.csv")
            readr::write_csv(
                  data.frame(doc_id = doc_id, n_errors = v$n_errors,
                             errors = paste(v$errors, collapse = " | "),
                             stringsAsFactors = FALSE),
                  vlog, append = file_exists(vlog))
      } else if (isTRUE(v$ok)) {
            message("  [validate] ", doc_id, " ok")
      }
      
      invisible(TRUE)
}

# Re-run finalize over all cached raw results for the current ingest mode WITHOUT
# re-querying the model. Use this after fixing a post-processing bug: fix code,
# call finalize_from_cache(config), get corrected JSON for free.
finalize_from_cache <- function(config) {
      cache_dir <- config$result_cache %||% path(config$out_dir, "_raw_cache")
      if (!dir_exists(cache_dir)) stop("No cache dir: ", cache_dir)
      mode <- config$ingest %||% "pdf"
      rds <- dir_ls(cache_dir, glob = paste0("*__", mode, ".rds"))
      if (length(rds) == 0) {
            message("No cached results for ingest='", mode, "' in ", cache_dir); return(invisible())
      }
      message("Finalizing ", length(rds), " cached results (ingest=", mode, ")...")
      for (f in rds) {
            res <- readRDS(f)
            ok <- tryCatch(finalize_result(res, config),
                           error = function(e) { message("  [finalize ERROR] ", res$doc_id,
                                                         ": ", conditionMessage(e)); FALSE })
            message("  ", if (isTRUE(ok)) "[ok] " else "[--] ", res$doc_id)
      }
      invisible()
}

# ==== Single-document entry point ===============================================
# Code ONE document end to end (score -> cache -> finalize), returning the raw
# result invisibly. Handy for iterating, spot-checks, and the cache test (call it
# twice in a row and inspect the second result's cache_read). Respects config$
# config$ingest (pdf|text) like run_pipeline does. `doc_path` may be a single
# .pdf file OR a folder of PDFs (a multi-PDF document).
# Set return_res=TRUE to get the result back for inspecting tokens/cache fields.
code_one <- function(doc_path, config, return_res = TRUE) {
      check_api_key(config$provider)
      .check_grobid_ready(config)
      dir_create(config$out_dir)
      system_prompt <- build_system_prompt(config)
      coding_schema <- load_coding_schema(config$schema_file)
      
      # Resolve the path to a document descriptor (single-PDF or multi-PDF folder).
      doc <- if (dir_exists(doc_path)) {
            pdfs <- sort(dir_ls(doc_path, glob = "*.pdf"))
            list(doc_id = path_file(doc_path), pdf_paths = as.character(pdfs), multi = TRUE)
      } else {
            list(doc_id = path_ext_remove(path_file(doc_path)),
                 pdf_paths = as.character(doc_path), multi = FALSE)
      }
      doc_id <- doc$doc_id
      
      message("[code] ", doc_id, " (design=", config$design %||% "single",
              ", ingest=", config$ingest %||% "text",
              if (isTRUE(doc$multi)) paste0(", ", length(doc$pdf_paths), " parts") else "",
              ") ... ", appendLF = FALSE)
      t0  <- Sys.time()
      res <- code_document(doc, config, system_prompt, coding_schema)
      dt  <- round(as.numeric(difftime(Sys.time(), t0, units = "secs")), 1)
      message(res$status, " (", dt, "s)")
      
      if (!is.null(res$result)) saveRDS(res, .cache_path(config, doc_id))
      finalize_result(res, config)
      
      # Upsert this doc's row into the SAME run log run_pipeline uses, so a single-doc
      # re-run updates the shared log in place (one row per doc) — no manual merging,
      # and the cost/agreement harness reads correct, non-duplicated data. Identical
      # schema to run_pipeline's log row.
      append_log(config$log_file, list(
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
      
      # Print the token/cache breakdown so the cache test is one call.
      message(sprintf("  tokens_in=%s tokens_out=%s cache_creation=%s cache_read=%s",
                      res$tokens_in %||% NA, res$tokens_out %||% NA,
                      res$cache_creation %||% NA, res$cache_read %||% NA))
      if (return_res) invisible(res) else invisible(NULL)
}

# ==== Bulk run (sequential) =====================================================
# Sequential by design — matches the localhost-Docker stability lessons and keeps
# rate-limiting / debugging tractable. Checkpoints each doc as it finishes.

# Fail-fast GROBID readiness guard. Only relevant for ingest="text" (the GROBID
# path). Does NOT launch anything and creates NO Docker dependency: it runs the
# health check ONLY if grobid_docker.R has been sourced (grobid_is_alive exists).
# If that module isn't loaded, this is a silent no-op — the pipeline still works,
# you just don't get the early warning. Catches the "forgot to start GROBID" and
# "GROBID died mid-project" cases before the scoring loop wastes time failing per
# doc.
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

run_pipeline <- function(config) {
      check_api_key(config$provider)
      .check_grobid_ready(config)
      dir_create(config$out_dir)
      
      system_prompt <- build_system_prompt(config)
      coding_schema <- load_coding_schema(config$schema_file)
      
      docs <- discover_documents(config$docs_dir)
      if (length(docs) == 0) stop("No documents (.pdf files or PDF folders) found in ",
                                  config$docs_dir)
      n_multi <- sum(vapply(docs, function(d) isTRUE(d$multi), logical(1)))
      message("Found ", length(docs), " documents (",
              n_multi, " multi-PDF). Provider: ", config$provider)
      
      for (doc in docs) {
            doc_id   <- doc$doc_id
            out_path <- path(config$out_dir, paste0(doc_id, ".json"))
            
            if (file_exists(out_path) && !config$overwrite) {
                  message("[skip] ", doc_id, " (already coded)")
                  next
            }
            
            message("[code] ", doc_id,
                    if (isTRUE(doc$multi)) paste0(" (", length(doc$pdf_paths),
                                                  " parts)") else "",
                    " ... ", appendLF = FALSE)
            t0  <- Sys.time()
            
            # Per-doc isolation: ANY failure in this doc (GROBID timeout or other
            # extraction error, an unexpected crash in scoring/finalize) is caught
            # here, logged as a failed row, and the loop CONTINUES to the next doc.
            # One bad document never kills a corpus run. code_document already
            # handles API errors gracefully (status="call_error"); this catches the
            # errors that throw instead of returning — notably extraction timeouts.
            doc_ok <- tryCatch({
                  res <- code_document(doc, config, system_prompt, coding_schema)
                  dt  <- round(as.numeric(difftime(Sys.time(), t0, units = "secs")), 1)
                  
                  # Cache the raw result BEFORE any post-processing, so finalize is
                  # re-runnable and a finalize bug never wastes this paid scoring.
                  if (!is.null(res$result)) {
                        saveRDS(res, .cache_path(config, doc_id))
                  }
                  
                  # Finalize: metadata merge + array protection + JSON write + pass1
                  # sidecar. Re-runnable later via finalize_from_cache().
                  finalize_result(res, config)
                  
                  append_log(config$log_file, list(
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
                  
                  if (res$status == "ok") {
                        message(res$status, " (", dt, "s)")
                  } else if (res$status == "truncated") {
                        message("truncated (", dt, "s)  >> structured call hit ",
                                "max_tokens; record is incomplete. Raise max_tokens ",
                                "and re-run this doc.")
                  } else {
                        message(res$status, " (", dt, "s)  >> ",
                                res$error %||% "(no error message)")
                  }
                  TRUE
            }, error = function(e) {
                  # Uncaught failure (e.g. GROBID timeout throwing from extraction).
                  # Log it as a failed doc so the run's log is complete, then move on.
                  dt <- round(as.numeric(difftime(Sys.time(), t0, units = "secs")), 1)
                  msg <- conditionMessage(e)
                  message("FAILED (", dt, "s)  >> ", substr(msg, 1, 200),
                          "\n         [skipped; continuing to next document]")
                  tryCatch(append_log(config$log_file, list(
                        doc_id     = doc_id,
                        status     = "doc_error",
                        error      = substr(msg, 1, 300),
                        tokens_in  = NA_integer_, tokens_out = NA_integer_,
                        cache_creation = NA_integer_, cache_read = NA_integer_,
                        stop_reason = NA_character_,
                        seconds    = dt,
                        provider   = config$provider,
                        timestamp  = format(Sys.time(), "%Y-%m-%d %H:%M:%S")
                  )), error = function(e2) NULL)  # never let logging failure crash
                  FALSE
            })
      }
      
      message("Run complete. Log: ", config$log_file)
      invisible(read_csv(config$log_file, show_col_types = FALSE))
}

# ==== Entry point ===============================================================

# log <- run_pipeline(config)
# print(log)