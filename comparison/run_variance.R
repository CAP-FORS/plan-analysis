# ==== Repeat-Scoring Variance Runner ============================================
# The FOUNDATIONAL comparison: score the SAME documents with the SAME method N
# times, to measure the model's run-to-run variance. This is the noise floor for
# every other comparison — a pdf-vs-text or model-vs-model difference only means
# something if it EXCEEDS this baseline. Run this FIRST.
#
# It re-scores (real API cost: N x docs x per-doc), writing each repetition to
# its own labeled dir (rep_01, rep_02, ...). Then compare_runs(..., axis="rep")
# treats the reps as the runs and reports how much identical-method scoring
# varies — the number you subtract from all other comparisons.

source("pipeline/pipeline.R")

# n_reps: how many times to score each doc (>=3 recommended; 5 is better).
# docs_dir: the fixed evaluation subsample.
# base_out: parent dir; reps land in base_out/rep_01, rep_02, ...
run_variance <- function(config, n_reps = 5,
                         base_out = "data/pilot/coded/variance") {
      message("Repeat-scoring variance: ", n_reps, " reps. ",
              "NOTE: this makes ", n_reps, " x N_docs scoring calls (real cost).")
      rep_dirs <- character(0)
      for (k in seq_len(n_reps)) {
            lab <- sprintf("rep_%02d", k)
            cfg <- modifyList(config, list(
                  out_dir  = fs::path(base_out, lab),
                  log_file = fs::path(base_out, lab, "run_log.csv"),
                  overwrite = TRUE   # each rep must actually re-score, not skip
            ))
            message("\n=== ", lab, " ===")
            run_pipeline(cfg)
            rep_dirs[[lab]] <- fs::path(base_out, lab)
      }
      
      # Build the runs list and compare with axis = "rep".
      runs <- as.list(rep_dirs); names(runs) <- names(rep_dirs)
      message("\nComputing variance (noise floor)...")
      vc <- compare_runs(runs, axis = "rep", config = config,
                         verify = FALSE, cost = TRUE)
      cat("\n>>> This is your NOISE FLOOR. Pass it as `variance_floor=` to other",
          "\n>>> compare_runs() calls so their results are judged against it.\n")
      invisible(vc)
}

# Convenience: load an existing variance result's dirs for reuse as the floor
# without re-scoring (once you've run it once, reuse the cached comparison).
variance_from_dirs <- function(config, base_out = "data/pilot/coded/variance") {
      rep_dirs <- fs::dir_ls(base_out, type = "directory")
      runs <- as.list(rep_dirs)
      names(runs) <- fs::path_file(rep_dirs)
      compare_runs(runs, axis = "rep", config = config, verify = FALSE, cost = TRUE)
}