# ==== Cost Summary (per run) ====================================================
# Reads each run's run_log.csv and computes per-document token usage and dollar
# cost, so cost sits beside agreement/verification in the comparison report —
# answering "how much quality for how much money" that drives the pdf/text and
# single/two-pass decisions. Uses the token/cache breakdown the pipeline logs.
#
# Rates are configurable (they change; intro pricing etc.). Defaults below reflect
# Claude Sonnet 5 INTRODUCTORY pricing ($2/$10 per M, through 2026-08-31); after
# that it becomes $3/$15. Sonnet 4.6 is $3/$15. SET rates to match the model the
# run actually used (the harness compares runs, which may use different models) —
# pass a per-run rates list if comparing across models with different pricing.
# Cache-write billed at 1.25x input; cache-read at ~0.1x input.

# Default rates reflect the model CURRENTLY IN USE: Claude Sonnet 4.6 ($3/$15 per
# M). Verified against the Claude console (~$0.80/doc for these ~170K-input runs),
# which the earlier $2/$10 default under-reported by ~1.5x. When you run the
# Sonnet 5 comparison, price that run with .RATE_PRESETS$sonnet5_intro (or
# _std after 2026-08-31): pass rates=.RATE_PRESETS$<preset> to cost_by_run /
# compare_runs, OR — cleaner — select the preset per run from the `model` field
# in coding_meta so a mixed-model comparison prices each run correctly and can't
# drift from the model actually used. Cache-write billed 1.25x input; cache-read
# ~0.1x input; batch mode would be 0.5x all (not yet wired).

.RATES <- list(
      input_per_m     = 3.00,   # $/M input tokens (Sonnet 4.6; current default model)
      output_per_m    = 15.00,  # $/M output tokens (Sonnet 4.6)
      cache_write_mult = 1.25,  # cache_creation billed at input * this
      cache_read_mult  = 0.10   # cache_read billed at input * this
)

# Convenience presets so a comparison across models can price each run correctly.
.RATE_PRESETS <- list(
      sonnet5_intro = list(input_per_m = 2.00, output_per_m = 10.00,
                           cache_write_mult = 1.25, cache_read_mult = 0.10),
      sonnet5_std   = list(input_per_m = 3.00, output_per_m = 15.00,
                           cache_write_mult = 1.25, cache_read_mult = 0.10),
      sonnet46      = list(input_per_m = 3.00, output_per_m = 15.00,
                           cache_write_mult = 1.25, cache_read_mult = 0.10)
)

# runs: named list of run dirs (each expected to contain run_log.csv).
cost_by_run <- function(runs, rates = .RATES, log_name = "run_log.csv") {
      rows <- lapply(names(runs), function(lab) {
            lp <- fs::path(runs[[lab]], log_name)
            n_json <- length(fs::dir_ls(runs[[lab]], glob = "*.json"))
            if (!fs::file_exists(lp)) {
                  message("  [cost] no ", log_name, " in ", runs[[lab]],
                          " (", n_json, " JSONs present) — cost unavailable for run '", lab, "'.")
                  return(data.frame(run = lab, docs = NA, mean_in = NA, mean_out = NA,
                                    mean_cache_read = NA, cost_per_doc = NA,
                                    log_status = "log missing", stringsAsFactors = FALSE))
            }
            log <- tryCatch(readr::read_csv(lp, show_col_types = FALSE),
                            error = function(e) NULL)
            if (is.null(log) || nrow(log) == 0)
                  return(data.frame(run = lab, docs = 0, mean_in = NA, mean_out = NA,
                                    mean_cache_read = NA, cost_per_doc = NA,
                                    log_status = "log empty", stringsAsFactors = FALSE))
            # Flag when the log covers fewer docs than there are JSON records.
            status <- if (nrow(log) < n_json)
                  sprintf("partial (%d/%d docs logged)", nrow(log), n_json) else "ok"
            if (status != "ok")
                  message("  [cost] run '", lab, "' log covers ", nrow(log), " of ", n_json,
                          " docs — cost is a partial average.")
            
            g <- function(col) if (col %in% names(log)) suppressWarnings(as.numeric(log[[col]])) else rep(NA, nrow(log))
            tin <- g("tokens_in"); tout <- g("tokens_out")
            cw  <- g("cache_creation"); cr <- g("cache_read")
            # Non-cache input = tokens_in minus the cache portions (approx; logs vary).
            base_in <- pmax(0, tin - ifelse(is.na(cw),0,cw) - ifelse(is.na(cr),0,cr))
            
            cost <- (base_in * rates$input_per_m +
                           ifelse(is.na(cw),0,cw) * rates$input_per_m * rates$cache_write_mult +
                           ifelse(is.na(cr),0,cr) * rates$input_per_m * rates$cache_read_mult +
                           ifelse(is.na(tout),0,tout) * rates$output_per_m) / 1e6
            
            data.frame(
                  run = lab, docs = nrow(log),
                  mean_in = round(mean(tin, na.rm = TRUE)),
                  mean_out = round(mean(tout, na.rm = TRUE)),
                  mean_cache_read = round(mean(cr, na.rm = TRUE)),
                  cost_per_doc = round(mean(cost, na.rm = TRUE), 3),
                  log_status = status,
                  stringsAsFactors = FALSE
            )
      })
      do.call(rbind, rows)
}