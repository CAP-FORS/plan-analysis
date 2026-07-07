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
      # Extraction is held CONSTANT across reps (it's deterministic; we want to
      # measure pure model/scoring variance, not extraction noise). So tei_dir and
      # extracted_dir point at ONE shared location for all reps; only coded_dir,
      # finalized_dir, and the reports vary per rep. Extract once up front.
      shared_tei <- config$tei_dir
      shared_ext <- config$extracted_dir
      message("Extracting once (shared across reps)...")
      extract(config)   # populates shared extracted_dir; idempotent
      
      rep_dirs <- character(0)
      for (k in seq_len(n_reps)) {
            lab <- sprintf("rep_%02d", k)
            ro  <- fs::path(base_out, lab)
            cfg <- modifyList(config, list(
                  out_dir         = ro,
                  tei_dir         = shared_tei,   # shared — do NOT re-extract per rep
                  extracted_dir   = shared_ext,   # shared
                  coded_dir       = fs::path(ro, "coded"),      # per-rep: the varying scoring
                  finalized_dir   = fs::path(ro, "finalized"),
                  tables_dir      = fs::path(ro, "tables"),
                  code_report     = fs::path(ro, "code_report.csv"),
                  finalize_report = fs::path(ro, "finalize_report.csv"),
                  verify_report   = fs::path(ro, "verify_report.csv"),
                  tabulate_report = fs::path(ro, "tabulate_report.csv"),
                  overwrite       = TRUE          # each rep must actually re-score
            ))
            message("\n=== ", lab, " (scoring) ===")
            code(cfg); finalize(cfg)          # extraction already done + shared
            rep_dirs[[lab]] <- ro
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