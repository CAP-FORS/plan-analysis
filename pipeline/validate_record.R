# ==== Record Schema Validation ==================================================
# Validates each finalized record against schema_merged.json (the validation
# contract) using a real JSON Schema validator. This is the codebook §7
# validation pass — previously described in comments/pseudocode but not
# implemented. It enforces what the ellmer generation constraint deliberately
# does NOT: per-element score ranges (0-1 / 0-2 / 0-3), required fields, correct
# types (e.g. 3.1 as a checklist, not a score), and structural conformance.
#
# WHY HERE, NOT AT GENERATION: schema.R (the JSON-Schema -> ellmer converter)
# deliberately drops minimum/maximum/required-strictness because provider
# structured output doesn't reliably enforce them. So the contract is enforced
# post-generation, here, against the merged schema.
#
# DESIGN (mirrors verify_evidence.R):
#   - Runs in finalize (cheap, re-runnable) so it validates cached results at
#     zero API cost and can be re-run over an existing corpus.
#   - FLAG, don't block by default: a failing record is written but flagged, with
#     the specific violations recorded, so nothing is silently discarded. The
#     codebook's "route to human review after repeated failures" policy is a
#     caller decision; this function surfaces the violations.
#   - Uses jsonvalidate with the ajv engine (JSON Schema draft 2020-12 support,
#     which our schema uses via $defs/$ref and 2020-12 $schema).

library(jsonvalidate)

# Validate one finalized record (an R list, as built in finalize) against the
# merged schema file. Returns a list: ok (logical), errors (character vector of
# human-readable violations), n_errors.
validate_record <- function(record, schema_merged_file) {
      if (is.null(schema_merged_file) || !file.exists(schema_merged_file)) {
            return(list(ok = NA, errors = "schema_merged_file not found; validation skipped",
                        n_errors = NA_integer_))
      }
      # Serialize the record exactly as written to disk (same array protection /
      # unboxing) so we validate what's actually saved, not a different shape.
      json_txt <- jsonlite::toJSON(record, auto_unbox = TRUE, null = "null", na = "null")
      
      # ajv engine supports draft 2020-12 ($defs, $ref, minimum/maximum). verbose=TRUE
      # returns the per-error detail; greedy=TRUE collects ALL errors, not just first.
      res <- tryCatch(
            jsonvalidate::json_validate(
                  json_txt, schema_merged_file,
                  engine = "ajv", verbose = TRUE, greedy = TRUE, error = FALSE
            ),
            error = function(e) structure(FALSE, validation_error = conditionMessage(e))
      )
      
      if (isTRUE(res)) {
            return(list(ok = TRUE, errors = character(0), n_errors = 0L))
      }
      # Extract the error table ajv attaches to a FALSE result.
      errs <- attr(res, "errors")
      if (is.null(errs) && !is.null(attr(res, "validation_error"))) {
            return(list(ok = FALSE, errors = attr(res, "validation_error"), n_errors = 1L))
      }
      msgs <- if (is.data.frame(errs) && nrow(errs) > 0) {
            # ajv's error data frame can contain a LIST-COLUMN (`params`), so apply(errs,
            # 1, ...) fails: it coerces via as.matrix(), which can't rectangularize a
            # list-column (the "length of 'dimnames' not equal to array extent" error).
            # Iterate by row index and pull columns by name instead — robust to the
            # list-column and to missing columns across ajv versions.
            gcol <- function(nm) if (nm %in% names(errs)) errs[[nm]] else NULL
            ipath <- gcol("instancePath"); if (is.null(ipath)) ipath <- gcol("dataPath")
            mcol  <- gcol("message")
            scol  <- gcol("schemaPath")
            vapply(seq_len(nrow(errs)), function(i) {
                  p <- if (!is.null(ipath)) as.character(ipath[[i]]) else ""
                  if (is.na(p) || !nzchar(p)) p <- "(root)"
                  m <- if (!is.null(mcol)) as.character(mcol[[i]]) else "constraint violation"
                  s <- if (!is.null(scol)) as.character(scol[[i]]) else ""
                  # append the schema clause (e.g. #/$defs/scored_element_0_1/.../maximum) so
                  # range failures are self-explaining about which limit was exceeded.
                  if (nzchar(s)) paste0(p, ": ", m, "  [", s, "]") else paste0(p, ": ", m)
            }, character(1))
      } else if (is.character(errs) && length(errs) > 0) {
            errs
      } else {
            "schema validation failed (no detailed errors returned)"
      }
      list(ok = FALSE, errors = as.character(msgs), n_errors = length(msgs))
}

# Validate every record JSON in a directory against the contract. Writes a
# per-run report (validation_report.csv) and returns it. Zero API cost — use it
# to validate an already-scored corpus retroactively.
validate_corpus <- function(config, out_dir = NULL, report_path = NULL) {
      dir <- out_dir %||% config$finalized_dir
      smf <- config$schema_merged_file
      files <- fs::dir_ls(dir, glob = "*.json")
      files <- files[!grepl("truncated|verification|validation|report", files)]
      if (length(files) == 0) { message("No records in ", dir); return(invisible()) }
      
      rows <- lapply(files, function(f) {
            rec <- tryCatch(jsonlite::fromJSON(f, simplifyVector = FALSE),
                            error = function(e) NULL)
            if (is.null(rec)) return(data.frame(
                  doc_id = fs::path_ext_remove(fs::path_file(f)), ok = FALSE,
                  n_errors = NA_integer_, errors = "unparseable JSON", stringsAsFactors = FALSE))
            v <- validate_record(rec, smf)
            data.frame(
                  doc_id = fs::path_ext_remove(fs::path_file(f)),
                  ok = v$ok, n_errors = v$n_errors,
                  errors = paste(v$errors, collapse = " | "),
                  stringsAsFactors = FALSE
            )
      })
      report <- do.call(rbind, rows)
      rp <- report_path %||% fs::path(dir, "validation_report.csv")
      readr::write_csv(report, rp)
      
      n_fail <- sum(!report$ok %in% TRUE)
      cat("\n==== schema validation ====\n")
      cat(sprintf("  records: %d | valid: %d | flagged: %d\n",
                  nrow(report), sum(report$ok %in% TRUE), n_fail))
      if (n_fail > 0) {
            cat("  flagged records and violations:\n")
            bad <- report[!report$ok %in% TRUE, ]
            for (i in seq_len(nrow(bad))) {
                  cat(sprintf("   [%s] %s\n", bad$doc_id[i], substr(bad$errors[i], 1, 200)))
            }
      }
      cat("  report: ", rp, "\n")
      invisible(report)
}

`%||%` <- function(a, b) if (is.null(a) || length(a) == 0 ||
                             (length(a) == 1 && is.na(a))) b else a

# Validate an on-disk JSON record FILE directly against the merged schema, without
# round-tripping through R (jsonvalidate accepts a file path). Use this to validate
# already-written records (e.g. finalize() re-validating skipped docs) so we check
# exactly what's on disk — no toJSON re-serialization that could re-introduce an
# array/unbox discrepancy the on-disk file doesn't have. Same return shape as
# validate_record().
validate_json_file <- function(json_path, schema_merged_file) {
      if (is.null(schema_merged_file) || !file.exists(schema_merged_file)) {
            return(list(ok = NA, errors = "schema_merged_file not found; validation skipped",
                        n_errors = NA_integer_))
      }
      if (!file.exists(json_path)) {
            return(list(ok = NA, errors = paste0("record not found: ", json_path),
                        n_errors = NA_integer_))
      }
      res <- tryCatch(
            jsonvalidate::json_validate(json_path, schema_merged_file,
                                        engine = "ajv", verbose = TRUE, greedy = TRUE,
                                        error = FALSE),
            error = function(e) structure(FALSE, validation_error = conditionMessage(e)))
      if (isTRUE(res)) return(list(ok = TRUE, errors = character(0), n_errors = 0L))
      errs <- attr(res, "errors")
      if (is.null(errs) && !is.null(attr(res, "validation_error"))) {
            return(list(ok = FALSE, errors = attr(res, "validation_error"), n_errors = 1L))
      }
      if (is.null(errs) || nrow(errs) == 0) {
            return(list(ok = FALSE, errors = "validation failed (no detail)", n_errors = 1L))
      }
      msgs <- if (!is.null(errs$instancePath))
            paste0(errs$instancePath, ": ", errs$message) else as.character(errs$message)
      list(ok = FALSE, errors = msgs, n_errors = length(msgs))
}