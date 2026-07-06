# ==== Cost Projection ===========================================================
# Project full-corpus cost from pilot token counts, synchronous vs batch.
# Reads the run_log.csv produced by swap_pipeline.R.
#
# Source swap_pipeline.R first (or run a pilot) so the log exists.

library(readr)
library(tibble)

# ==== Rates =====================================================================
# USD per 1M tokens. VERIFY current rates before trusting output — these are
# placeholders, not live prices. Note: Gemini 2.5 Pro has tiered input pricing
# above a 200K-token prompt; if your per-doc input crosses that, the simple
# mean-token projection understates cost. Check pilot token counts against it.

cost_rates <- list(
      gemini = list(input = 1.25, output = 10.00),   # PLACEHOLDER — verify
      claude = list(input = 3.00, output = 15.00)     # PLACEHOLDER — verify
)

# ==== Projection ================================================================
# Batch mode (Anthropic Batch API / Gemini Batch Mode) is 50% off synchronous
# rates for both providers. We project both from the same pilot token means.

project_cost <- function(log_file, corpus_size, provider, rates = cost_rates) {
      log <- read_csv(log_file, show_col_types = FALSE)
      log <- log[log$status %in% c("ok", "quote_fail"), ]  # only successful calls
      pilot_n <- nrow(log)
      if (pilot_n == 0) stop("No successful pilot runs in log.")
      
      mean_in  <- mean(log$tokens_in,  na.rm = TRUE)
      mean_out <- mean(log$tokens_out, na.rm = TRUE)
      r <- rates[[provider]]
      
      per_doc_sync  <- (mean_in / 1e6) * r$input + (mean_out / 1e6) * r$output
      per_doc_batch <- per_doc_sync * 0.5  # both providers: 50% off
      
      tibble(
            provider        = provider,
            pilot_docs      = pilot_n,
            mean_tokens_in  = round(mean_in),
            mean_tokens_out = round(mean_out),
            corpus_size     = corpus_size,
            cost_sync       = round(per_doc_sync  * corpus_size, 2),
            cost_batch      = round(per_doc_batch * corpus_size, 2),
            savings_batch   = round(per_doc_sync * corpus_size * 0.5, 2)
      )
}

# ==== Usage =====================================================================
# After running a pilot:
# project_cost(config$log_file, corpus_size = 56, provider = "gemini")
#
# To compare both providers, run pilots under each (separate out_dir / log_file)
# and call project_cost() against each log.