# ==== ellmer batch_chat() Smoke Test ============================================
# Cheap go/no-go test of the in-R batch path BEFORE committing to a full-corpus
# batch run. Runs 2-3 docs through ellmer's batch_chat() with the project schema
# and reports whether: (a) batch submission works, (b) structured output over
# batch returns parseable results matching coding_schema, (c) tokens are
# recoverable for cost projection.
#
# If this passes, the in-R batch path is viable and you get the 50% batch
# discount without leaving R. If it fails or is flaky, that's your signal to
# use the reticulate -> Python batch SDK bridge instead. Either way you learn
# this cheaply, before the full corpus.
#
# Usage:
#   source("swap_pipeline.R")     # for config, coding_schema, make_chat, check_api_key
#   source("swap_batch_smoketest.R")
#   res <- run_batch_smoketest(config, n = 3)

library(ellmer)
library(fs)
library(readr)

# ==== Test runner ===============================================================

run_batch_smoketest <- function(config, n = 3) {
      check_api_key(config$provider)
      system_prompt <- read_file(config$prompt_file)
      
      docs <- head(dir_ls(config$docs_dir, glob = "*.pdf"), n)
      if (length(docs) == 0) stop("No .pdf documents found in ", config$docs_dir)
      message("Smoke-testing batch_chat() on ", length(docs), " docs. Provider: ",
              config$provider)
      
      # ---- Step 1: does batch_chat() even exist in this ellmer version? -----------
      if (!exists("batch_chat", where = asNamespace("ellmer"), inherits = FALSE) &&
          is.null(getNamespace("ellmer")$batch_chat)) {
            message("\n[FAIL] batch_chat() not found in your ellmer version.")
            message("       -> Upgrade ellmer, or plan on the reticulate/Python bridge.")
            return(invisible(list(ok = FALSE, reason = "no_batch_chat")))
      }
      
      # ---- Step 2: build one prompt list, each entry = instructions + PDF ----------
      # batch_chat() takes a chat object and a list of prompt contents (one per call).
      chat <- make_chat(config, system_prompt)
      
      prompts <- lapply(docs, function(doc_path) {
            doc_id <- path_ext_remove(path_file(doc_path))
            list(
                  paste0("Code the following SWAP document according to the codebook and ",
                         "schema.\nDOCUMENT ID: ", doc_id),
                  content_pdf_file(doc_path)
            )
      })
      
      # ---- Step 3: submit as a structured batch -----------------------------------
      # API shape varies by ellmer version. The two most likely signatures:
      #   batch_chat_structured(chat, prompts, type = coding_schema)
      #   batch_chat(chat, prompts, type = coding_schema)
      # We try the structured variant first, then fall back, capturing any error.
      
      t0 <- Sys.time()
      result <- tryCatch({
            if (exists("batch_chat_structured", where = asNamespace("ellmer"))) {
                  batch_chat_structured(chat, prompts, type = coding_schema)
            } else {
                  batch_chat(chat, prompts, type = coding_schema)
            }
      }, error = function(e) list(.error = conditionMessage(e)))
      dt <- round(as.numeric(difftime(Sys.time(), t0, units = "secs")), 1)
      
      if (!is.null(result$.error)) {
            message("\n[FAIL] batch call errored after ", dt, "s:")
            message("       ", result$.error)
            message("       -> Note the error, then test the reticulate/Python bridge.")
            return(invisible(list(ok = FALSE, reason = "call_error",
                                  error = result$.error)))
      }
      
      # ---- Step 4: validate the shape of what came back ----------------------------
      # Expect one structured result per input doc, each parseable against the schema
      # (i.e. has a $document_id and an $elements list).
      n_returned <- length(result)
      shape_ok <- is.list(result) && n_returned == length(docs)
      
      validate_one <- function(r) {
            is.list(r) && !is.null(r$elements) && length(r$elements) > 0
      }
      per_doc_ok <- vapply(result, validate_one, logical(1))
      
      message("\n---- Smoke test summary --------------------------------------")
      message("  submission:        OK (", dt, "s wall, async turnaround varies)")
      message("  results returned:  ", n_returned, " / ", length(docs))
      message("  schema-valid docs: ", sum(per_doc_ok), " / ", n_returned)
      
      # ---- Step 5: token recoverability for cost projection ------------------------
      tok <- tryCatch(chat$get_tokens(), error = function(e) NULL)
      tokens_ok <- !is.null(tok) && nrow(tok) > 0
      message("  tokens captured:   ", if (tokens_ok) "yes" else "NO (cost projection needs another source)")
      
      overall <- shape_ok && all(per_doc_ok) && tokens_ok
      message("  VERDICT:           ", if (overall) "PASS — in-R batch path is viable"
              else "PARTIAL/FAIL — consider reticulate/Python bridge")
      message("--------------------------------------------------------------\n")
      
      invisible(list(
            ok           = overall,
            n_returned   = n_returned,
            per_doc_ok   = per_doc_ok,
            tokens_ok    = tokens_ok,
            result       = result,
            tokens       = tok,
            seconds      = dt
      ))
}

# ==== Usage =====================================================================
# source("swap_pipeline.R")
# smoke <- run_batch_smoketest(config, n = 3)
# smoke$ok        # TRUE -> proceed with batch_chat() for the full corpus
#                 # FALSE -> inspect smoke$reason / smoke$error, plan the bridge