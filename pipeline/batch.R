# ==============================================================================
# BATCH SCORING — the horizontal, cost-optimized scoring band
# ==============================================================================

# WORKAROUND: ellmer 0.4.1's batch-retrieval path calls withr::local_tempfile()
# without importing it into its namespace, so retrieval fails with
# 'could not find function "local_tempfile"' UNLESS withr is attached. Attaching
# it here makes batch retrieval robust regardless of session state. (Remove once
# ellmer fixes the missing @importFrom; harmless to leave.)
if (requireNamespace("withr", quietly = TRUE)) suppressMessages(library(withr))

# Anthropic Message Batches API via ellmer's batch_chat_structured(): submit all
# documents at once, ~50% cheaper, async (up to 24h). Fits the horizontal design:
# it only touches the SCORING band — it writes coded_dir/<doc>__<ingest>.rds in
# the SAME shape code_document() returns, so finalize()/verify()/tabulate()
# consume batch and sequential output identically.
#
# WORKFLOW (config$scoring_mode = "batch"):
#   code(config)                # submits the batch, returns immediately
#   check_batch_status(config)  # poll interactively; retrieves + writes .rds when done
#   finalize(config)            # as normal
#
# ellmer's state FILE is the mechanism: batch_chat_structured(path=, wait=FALSE)
# submits and stores all state in that .json. Re-calling with the same path (or
# batch_chat_completed()) resumes/retrieves. We keep the state file in coded_dir.
#
# KEY SETTINGS:
#   convert = FALSE  — REQUIRED. Our schema is deeply nested (orientation with a
#     45-entry evidence_index, per-element evidence arrays). convert=TRUE would try
#     to rectangle that into a data frame and mangle it. FALSE returns the raw
#     nested list per doc, matching what chat_structured() gives the sync path.
#   wait = config$batch_wait (default FALSE) — submit-and-return; walk away.

# Path to ellmer's batch state file (one per ingest mode, in coded_dir).
.batch_state_path <- function(config) {
      dir_create(config$coded_dir)
      path(config$coded_dir, paste0("_batch_state__", config$ingest %||% "text", ".json"))
}

# Build the ordered doc list + matching prompts for the corpus. Each prompt is the
# single-call instructions + the prepared document payload, combined into one
# string (ellmer batch prompts are one element per request). Returns a list with
# aligned vectors: docs (descriptors), doc_ids, prompts, page_counts.
.batch_build_prompts <- function(config) {
      docs <- discover_documents(config$source_dir)
      if (length(docs) == 0) stop("No documents in ", config$source_dir)
      doc_ids    <- vapply(docs, function(d) d$doc_id, character(1))
      message("[code/batch] preparing ", length(docs), " prompts ...")
      prompts <- vector("list", length(docs))
      pcs     <- integer(length(docs))
      for (i in seq_along(docs)) {
            doc <- docs[[i]]
            payload <- prepare_document(doc, config)$content   # extraction (cached .md)
            prompts[[i]] <- paste0(singlecall_instructions(doc$doc_id), "\n\n", payload)
            pcs[i] <- tryCatch(sum(vapply(doc$pdf_paths, pdftools::pdf_length, integer(1))),
                               error = function(e) NA_integer_)
      }
      list(docs = docs, doc_ids = doc_ids, prompts = prompts, page_counts = pcs)
}

# Map ONE batch result (a raw nested structured-data list from convert=FALSE) plus
# its usage row into the standard `res` shape code_document() returns, and write it
# to coded_dir/<doc_id>__<ingest>.rds. Keeps finalize/verify/tabulate unchanged.
.batch_write_rds <- function(result, doc_id, page_count, usage_row, config) {
      # ellmer's batch retrieval (convert=FALSE) USUALLY returns a parsed nested list,
      # but sometimes (ellmer issue #830 — a JSON that trips its per-item parsing)
      # returns the RAW JSON STRING instead. Detect that and parse it ourselves, so
      # these docs become proper records instead of a character string that would
      # break .normalize_evidence downstream. If it won't parse, mark it an error.
      if (is.character(result) && length(result) == 1) {
            parsed <- tryCatch(jsonlite::fromJSON(result, simplifyVector = FALSE),
                               error = function(e) NULL)
            if (is.null(parsed)) {
                  message("  [batch] ", doc_id, ": result was an unparseable string; marking error.")
                  result <- NULL
            } else {
                  message("  [batch] ", doc_id, ": recovered raw-string result via JSON parse.")
                  result <- parsed
            }
      }
      
      # Surface the orientation summary for R-level convenience (same as sync path).
      summary_txt <- tryCatch(result$orientation$summary, error = function(e) NA_character_)
      if (is.null(summary_txt) || length(summary_txt) == 0) summary_txt <- NA_character_
      
      status <- if (is.null(result)) "call_error" else "ok"
      res <- list(
            doc_id     = doc_id,
            status     = status,
            error      = if (is.null(result)) "batch returned no result for this doc" else NA_character_,
            result     = result,
            page_count = page_count,
            summary    = summary_txt,
            # Per-request usage: NOTE ellmer does NOT expose per-doc token counts for
            # batch with convert=FALSE — include_tokens only adds columns to a data-frame
            # (convert=TRUE) result, and chat$get_tokens() stays empty after batch
            # retrieval. So these are typically NA for batch; get corpus-level cost from
            # the Anthropic console (Batches -> your batch) instead. Kept here so the
            # shape matches the sync path; populated only if a usage_row is ever supplied.
            tokens_in      = usage_row$input        %||% NA_integer_,
            tokens_out     = usage_row$output       %||% NA_integer_,
            cache_creation = usage_row$cache_creation %||% NA_integer_,
            cache_read     = usage_row$cached_input %||% usage_row$cache_read %||% NA_integer_,
            stop_reason    = usage_row$stop_reason  %||% "batch"
      )
      saveRDS(res, path(config$coded_dir, paste0(doc_id, "__", config$ingest %||% "text", ".rds")))
      res
}

# ---- SUBMIT: code_batch(config) ----------------------------------------------
# Called by code() when scoring_mode="batch". Builds prompts, submits the batch
# (wait defaults FALSE), and — if results are already available (wait=TRUE, or a
# fast batch) — writes them. Otherwise reports "pending" and returns; the user
# polls with check_batch_status(config).
code_batch <- function(config) {
      check_api_key(config$provider)
      .check_grobid_ready(config)
      dir_create(config$coded_dir)
      system_prompt <- build_system_prompt(config)
      schema        <- load_coding_schema(config$schema_file)
      chat          <- make_chat(config, system_prompt)
      
      b  <- .batch_build_prompts(config)
      sp <- .batch_state_path(config)
      waitp <- isTRUE(config$batch_wait)   # default FALSE
      
      message("[code/batch] submitting ", length(b$prompts), " documents to the ",
              "Anthropic batch API (state: ", sp, ", wait=", waitp, ") ...")
      # convert=FALSE: keep the nested structure. include_tokens/cost: capture usage.
      # NOTE: with wait=FALSE on a JUST-submitted batch (0 results ready), ellmer's
      # batch_chat_structured tries to assemble result turns and errors with
      # "unexpected number of responses ... Expected N, got 0" instead of returning
      # NULL as documented. The batch itself submits fine (state file is written); the
      # error is only in client-side result assembly. So we catch that specific case
      # and treat it as "submitted, pending" — retrieval happens later via
      # check_batch_status() once results exist.
      out <- tryCatch(
            ellmer::batch_chat_structured(
                  chat = chat, prompts = b$prompts, path = sp, type = schema,
                  wait = waitp, convert = FALSE, include_tokens = TRUE, include_cost = TRUE),
            error = function(e) {
                  msg <- conditionMessage(e)
                  assembling_empty <- grepl("unexpected number of responses|Expected .* got 0",
                                            msg, ignore.case = TRUE)
                  if (assembling_empty && file_exists(sp)) {
                        structure("pending", class = "batch_pending")  # sentinel: submitted, not ready
                  } else {
                        stop(e)  # a real submission failure — re-raise
                  }
            })
      
      if (inherits(out, "batch_pending") || is.null(out)) {
            message("[code/batch] submitted; batch is PROCESSING (up to 24h, often less).\n",
                    "  Poll with:  check_batch_status(config)\n",
                    "  When it reports complete, results are written and you can finalize(config).")
            return(invisible(FALSE))
      }
      # Results already available (wait=TRUE or fast completion) — write them.
      .batch_retrieve_and_write(config, b, out)
      invisible(TRUE)
}

# Given the batch output `out` (aligned to prompt order), write each doc's .rds
# and log a row. `out` from convert=FALSE is a list with one element per prompt
# (the nested result), possibly with attached tokens/cost columns when it's a
# data frame; we handle both shapes defensively.
.batch_retrieve_and_write <- function(config, b, out) {
      n <- length(b$doc_ids)
      # Normalize `out` into: results[[i]] (nested list) and usage[[i]] (named list).
      get_result <- function(i) {
            if (is.data.frame(out)) out$result[[i]]        # structured col
            else if (is.list(out)) out[[i]]
            else NULL
      }
      get_usage <- function(i) {
            if (is.data.frame(out)) as.list(out[i, intersect(
                  c("input","output","cached_input","cache_creation","cache_read",
                    "cost","stop_reason"), names(out)), drop = FALSE])
            else list()
      }
      ok <- 0L
      for (i in seq_len(n)) {
            result <- tryCatch(get_result(i), error = function(e) NULL)
            res <- tryCatch(
                  .batch_write_rds(result, b$doc_ids[i], b$page_counts[i], get_usage(i), config),
                  error = function(e) { message("  [batch write ERROR] ", b$doc_ids[i], ": ",
                                                conditionMessage(e)); NULL })
            if (!is.null(res)) {
                  .log_code_row(config, res, NA_real_)  # batch has no per-doc wall time
                  if (identical(res$status, "ok")) ok <- ok + 1L
            }
      }
      message("[code/batch] retrieved ", ok, "/", n, " documents -> ", config$coded_dir,
              "\n  Next: finalize(config)")
      invisible(TRUE)
}

# ---- POLL: check_batch_status(config) ----------------------------------------
# Interactive status check. Reports whether the submitted batch is complete; when
# it IS, retrieves the results and writes the .rds (so finalize(config) works
# right after). Safe to call repeatedly. Returns TRUE when complete+written.
check_batch_status <- function(config) {
      sp <- .batch_state_path(config)
      if (!file_exists(sp)) {
            message("No batch in progress (no state file at ", sp, ").\n",
                    "  Submit one with: code(config)   # scoring_mode='batch'")
            return(invisible(NA))
      }
      system_prompt <- build_system_prompt(config)
      schema        <- load_coding_schema(config$schema_file)
      chat          <- make_chat(config, system_prompt)
      b <- .batch_build_prompts(config)   # rebuild prompts (must match the state hash)
      
      done <- tryCatch(
            ellmer::batch_chat_completed(chat, b$prompts, sp),
            error = function(e) { message("  status check error: ", conditionMessage(e)); NA })
      
      if (isTRUE(done)) {
            message("[batch] COMPLETE — retrieving results ...")
            out <- tryCatch(
                  ellmer::batch_chat_structured(
                        chat = chat, prompts = b$prompts, path = sp, type = schema,
                        wait = FALSE, convert = FALSE, include_tokens = TRUE, include_cost = TRUE),
                  error = function(e) {
                        message("  retrieval error: ", conditionMessage(e),
                                "\n  (If this says 'unexpected number of responses', some requests may ",
                                "have failed provider-side; try again, or inspect the batch in the ",
                                "Anthropic console.)")
                        NULL
                  })
            if (is.null(out)) {
                  message("  (no results assembled yet — try check_batch_status(config) again shortly.)")
                  return(invisible(FALSE))
            }
            .batch_retrieve_and_write(config, b, out)
            return(invisible(TRUE))
      } else if (isFALSE(done)) {
            message("[batch] still PROCESSING. Check again with check_batch_status(config).")
            return(invisible(FALSE))
      } else {
            return(invisible(NA))
      }
}