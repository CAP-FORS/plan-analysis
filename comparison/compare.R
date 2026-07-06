# ==== Comparison Driver =========================================================
# The entry point that ties the harness together. Given a set of runs and the
# axis being tested, it:
#   1. normalizes all runs to the long table,
#   2. CONFOUND-CHECK: warns if runs differ on any axis OTHER than the named one
#      (enforces "hold everything constant except the axis under test"),
#   3. computes agreement + IRR (all evaluable modes),
#   4. attaches per-run verification (fabrication rate) and cost,
#   5. renders a report — default simple view, full kappa/alpha on demand,
#      and every result framed against the repeat-variance noise floor if given.
#
# Every comparison type is the same call with a different `axis`:
#   compare_runs(list(pdf="...", text="..."), axis="ingest")
#   compare_runs(list(two_pass="...", single="..."), axis="design")
#   compare_runs(list(sonnet46="...", sonnet5="..."), axis="model")
#   compare_runs(list(human="...", model="..."), axis="coder")   # human-vs-model
#   compare_runs(list(v0_2="...", v0_3="..."), axis="codebook")
#   compare_runs(list(rep_01="...", rep_02="...", rep_03="..."), axis="rep")  # variance

source("comparison/normalize_records.R")
source("comparison/agreement_metrics.R")
source("comparison/verification_summary.R")
source("comparison/cost_summary.R")

# Axes we track. The one named as `axis` is EXPECTED to vary; the rest are
# expected to be constant across runs. A constant-axis that varies = confound.
.AXES <- c("model", "provider", "codebook", "ingest", "design")

# runs: named list of directories, names are the run labels.
compare_runs <- function(runs, axis,
                         variance_floor = NULL,   # optional: a prior variance report
                         evaluable_mode = "category",
                         full = FALSE,            # TRUE -> print kappa/alpha breakdown
                         verify = TRUE, cost = TRUE,
                         config = NULL) {          # needed for verify/cost
      stopifnot(length(runs) >= 2)
      long <- normalize_runs(runs)
      
      # ---- confound check --------------------------------------------------------
      # For each tracked axis that is NOT the one under test, all runs should share a
      # single value. If not, the comparison mixes >1 variable — flag it loudly.
      # `axis` may be a single axis or a VECTOR of axes you intend to vary together
      # (e.g. axis = c("ingest","design") when deliberately comparing sets that
      # differ on both). Any tracked axis NOT declared is expected constant.
      axis <- as.character(axis)
      axis_label <- paste(axis, collapse = " + ")
      confounds <- character(0)
      # For each non-tested axis, classify into one of three states (silence must
      # mean "confirmed constant", never "no data"):
      #   VARIES     - two+ distinct known values across runs -> confound.
      #   UNVERIFIED - some run has NA/unknown for this axis -> can't confirm it's
      #                held constant (e.g. legacy records lacking structured tags).
      #   constant   - a single known value across all runs -> clean, no message.
      tag_summary <- long %>%
            distinct(run, model, provider, codebook, ingest, design)
      unverifiable <- character(0)
      for (ax in setdiff(.AXES, axis)) {
            col <- tag_summary[[ax]]
            known <- unique(stats::na.omit(col))
            n_missing <- sum(is.na(col))
            if (length(known) > 1) {
                  confounds <- c(confounds, sprintf(
                        "  ! axis '%s' VARIES across runs (%s) but was not declared in axis=[%s]",
                        ax, paste(known, collapse = " / "), axis_label))
            } else if (n_missing > 0) {
                  # A single (or zero) known value BUT some runs don't declare it: cannot
                  # certify it's constant. Name which runs are missing it.
                  missing_runs <- tag_summary$run[is.na(col)]
                  unverifiable <- c(unverifiable, sprintf(
                        "  ? axis '%s' could NOT be verified constant — %s do not record it%s",
                        ax, paste(missing_runs, collapse = ", "),
                        if (length(known) == 1) sprintf(" (others report '%s')", known) else ""))
            }
      }
      if (length(confounds) > 0) {
            message("CONFOUND WARNING — this comparison varies on more than the declared axis:")
            message(paste(confounds, collapse = "\n"))
            message("  Differences may not be attributable to [", axis_label, "] alone.")
      }
      if (length(unverifiable) > 0) {
            message("CONFOUND CHECK INCOMPLETE — an axis could not be confirmed constant:")
            message(paste(unverifiable, collapse = "\n"))
            message("  (Records predating structured metadata lack these tags. Re-score ",
                    "to enable a full check, or confirm manually that these are held constant.)")
      }
      if (length(confounds) == 0 && length(unverifiable) == 0) {
            message("Confound check: all non-declared axes confirmed constant. Clean comparison on [",
                    axis_label, "].")
      }
      
      # ---- agreement + IRR -------------------------------------------------------
      agree <- agreement_report(long, evaluable_mode)
      agree_all <- if (full) agreement_report_all_modes(long) else NULL
      
      # ---- verification + cost per run ------------------------------------------
      verif <- if (verify && !is.null(config)) verification_by_run(runs, config) else NULL
      costs <- if (cost) cost_by_run(runs) else NULL
      
      out <- list(axis = axis, runs = names(runs), long = long,
                  agreement = agree, agreement_all_modes = agree_all,
                  verification = verif, cost = costs,
                  confounds = confounds, unverifiable = unverifiable,
                  variance_floor = variance_floor)
      class(out) <- "run_comparison"
      print_comparison(out, full = full)
      invisible(out)
}

# ---- report rendering ----------------------------------------------------------
print_comparison <- function(x, full = FALSE) {
      cat("\n==== COMPARISON:", paste(x$axis, collapse = " + "), "====\n")
      cat("runs:", paste(x$runs, collapse = " vs "), "\n")
      if (length(x$confounds)) cat("  [!] CONFOUNDED — an axis other than '", x$axis,
                                   "' varies (see warning above)\n", sep = "")
      if (length(x$unverifiable)) cat("  [?] confound check incomplete — an axis ",
                                      "could not be confirmed constant (see above)\n", sep = "")
      
      ov <- x$agreement$overall
      cat(sprintf("\nOVERALL agreement (evaluable=%s): exact=%.1f%%  adjacent=%.1f%%\n",
                  x$agreement$evaluable_mode, 100*ov$exact, 100*ov$adjacent))
      cat(sprintf("  IRR: Krippendorff alpha (ordinal)=%.3f", ov$alpha))
      if (!is.na(ov$kappa)) cat(sprintf("  |  Cohen kappa=%.3f", ov$kappa))
      cat(sprintf("\n  evaluable-flag agreement=%.1f%%\n", 100*x$agreement$evaluable_agreement))
      
      # noise-floor framing
      if (!is.null(x$variance_floor)) {
            vf <- x$variance_floor$agreement$overall$exact
            delta <- ov$exact - vf
            verdict <- if (ov$exact >= vf - 0.01) "WITHIN the repeat-scoring noise floor (no real effect)"
            else "BELOW the noise floor (a real, systematic difference)"
            cat(sprintf("  vs variance floor (%.1f%% exact): %s\n", 100*vf, verdict))
      }
      
      # per-theme (always) — this is where the interesting structure lives
      cat("\nby theme (exact / adjacent / alpha):\n")
      for (i in seq_len(nrow(x$agreement$per_theme))) {
            r <- x$agreement$per_theme[i, ]
            cat(sprintf("  %-22s %.0f%% / %.0f%% / a=%.2f\n",
                        sub("theme:", "", r$scope), 100*r$exact, 100*r$adjacent, r$alpha))
      }
      
      # cost + verification side by side
      if (!is.null(x$cost)) {
            cat("\ncost per run:\n"); print(x$cost, row.names = FALSE)
      }
      if (!is.null(x$verification)) {
            cat("\nverification (fabrication/leak) per run:\n")
            print(x$verification, row.names = FALSE)
      }
      
      # full breakdown on demand
      if (full) {
            cat("\n---- per-element detail ----\n")
            print(x$agreement$per_element, row.names = FALSE)
            cat("\n---- evaluable-mode sensitivity (overall exact / alpha) ----\n")
            for (mm in names(x$agreement_all_modes)) {
                  o <- x$agreement_all_modes[[mm]]$overall
                  cat(sprintf("  %-9s exact=%.1f%%  alpha=%.3f\n", mm, 100*o$exact, o$alpha))
            }
      } else {
            cat("\n(call with full=TRUE for per-element breakdown and evaluable-mode sensitivity)\n")
      }
      invisible(x)
}