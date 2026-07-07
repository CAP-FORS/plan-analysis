# ==============================================================================
# PHASE 5: tabulate — finalized JSON records -> flat analysis CSVs
# ==============================================================================
# Reads finalized_dir/*.json and writes tidy (long-format) CSVs into a `tables/`
# folder for downstream analysis/visualization. Three tables, each at a different
# grain, because the records are nested and one-to-many (a flat one-row-per-doc
# dump would either lose the evidence or explode into hundreds of columns):
#
#   scores_long.csv     one row per (document x scored element)
#                       -> doc_id, juris, doc_type, year, theme, element,
#                          evaluable, score, absence_note, n_evidence
#                       The quantitative workhorse. pivot_wider() gives the
#                       document x element score matrix when you want it.
#
#   checklists_long.csv one row per (document x checklist/component x category)
#                       -> doc_id, ..., theme, checklist, category, present,
#                          n_evidence
#                       The multi-select / presence items (management_scale and
#                       the *_components lists) — structurally distinct from
#                       scores (present/absent, not 0-N), so their own table.
#
#   evidence.csv        one row per (document x element x quote)
#                       -> doc_id, ..., theme, element, category, score/present,
#                          quote, location, sub_component
#                       The qualitative/audit table: every evidence quote with
#                       where it came from and what it supports.
#
# Grouping columns (juris, doc_type, year) are parsed from the doc_id
# (<JURIS>_<TYPE>_<YEAR>[_draft]) — canonical codes, consistent across the corpus
# — and the human-readable document_meta fields (jurisdiction, document_type) are
# carried alongside. score and evaluable are KEPT SEPARATE so the analyst decides
# how to treat non-evaluable cases (don't bake "not evaluable == 0" into the data).

library(jsonlite)
library(fs)
library(readr)

# Which top-level element keys are PRESENCE-nested (dict of {present, evidence})
# rather than scored ({score, evaluable, evidence}). Detected structurally at
# runtime, but listed here for reference: adaptive_capacity_components,
# biological_unit_components, management_scale.
.THEMES <- c("concepts", "tools", "context", "actions")

# Parse doc_id "<JURIS>_<TYPE>_<YEAR>[_draft]" -> list(juris, doc_type, year, draft).
# Robust to the _draft suffix and to ids that don't match (returns NAs).
.parse_doc_id <- function(doc_id) {
      draft <- grepl("_draft$", doc_id, ignore.case = TRUE)
      base  <- sub("_draft$", "", doc_id, ignore.case = TRUE)
      m <- regmatches(base, regexec("^([A-Za-z]+)_([A-Za-z]+)_([0-9]{4})$", base))[[1]]
      if (length(m) == 4) {
            list(juris = m[2], doc_type = m[3], year = as.integer(m[4]), draft = draft)
      } else {
            # Fall back: first token as juris, leave the rest NA.
            list(juris = sub("_.*$", "", base), doc_type = NA_character_,
                 year = NA_integer_, draft = draft)
      }
}

# Common per-document grouping columns (parsed id + human-readable meta).
.doc_cols <- function(rec, doc_id) {
      p  <- .parse_doc_id(doc_id)
      dm <- rec$document_meta %||% list()
      data.frame(
            doc_id       = doc_id,
            juris        = p$juris,
            doc_type     = p$doc_type,
            year         = p$year,
            draft        = p$draft,
            jurisdiction = dm$jurisdiction  %||% NA_character_,  # human-readable, from meta
            document_type = dm$document_type %||% NA_character_,
            page_count   = dm$page_count    %||% NA_integer_,
            stringsAsFactors = FALSE
      )
}

# Number of REAL evidence quotes (non-empty text) attached to an element/category.
.n_evidence <- function(ev) {
      if (is.null(ev) || length(ev) == 0) return(0L)
      sum(vapply(ev, function(e) {
            tx <- e$text %||% ""
            is.character(tx) && nzchar(trimws(tx))
      }, logical(1)))
}

# Flatten one record into rows for the three tables. Returns a list of three
# data.frames (scores, checklists, evidence). Uses an environment accumulator so
# the nested evidence-emitter and the main loop append to the SAME lists without
# scoping ambiguity (an earlier version used <<- from the function body, which
# searched enclosing scopes instead of the local vars -> "object not found").
.tabulate_record <- function(rec, doc_id) {
      dc  <- .doc_cols(rec, doc_id)
      acc <- new.env(parent = emptyenv())
      acc$scores <- list(); acc$checks <- list(); acc$evid <- list()
      
      emit_evidence <- function(theme, element, category, score_or_present, ev) {
            if (is.null(ev) || length(ev) == 0) return(invisible())
            for (e in ev) {
                  tx <- e$text %||% ""
                  if (!is.character(tx) || !nzchar(trimws(tx))) next  # skip empty slots
                  acc$evid[[length(acc$evid) + 1]] <- cbind(dc, data.frame(
                        theme = theme, element = element,
                        category = category %||% NA_character_,
                        value = as.character(score_or_present),
                        quote = tx,
                        location = e$location %||% NA_character_,
                        sub_component = e$sub_component %||% NA_character_,
                        stringsAsFactors = FALSE))
            }
      }
      
      for (theme in .THEMES) {
            block <- rec[[theme]]
            if (is.null(block)) next
            for (element in names(block)) {
                  val <- block[[element]]
                  if (!is.list(val)) next
                  
                  if (!is.null(val$score) || !is.null(val$evaluable)) {
                        # ---- SCORED element ----
                        acc$scores[[length(acc$scores) + 1]] <- cbind(dc, data.frame(
                              theme = theme, element = element,
                              evaluable = isTRUE(val$evaluable),
                              score = if (is.null(val$score)) NA_integer_ else as.integer(val$score),
                              absence_note = val$absence_note %||% NA_character_,
                              n_evidence = .n_evidence(val$evidence),
                              stringsAsFactors = FALSE))
                        emit_evidence(theme, element, NA_character_,
                                      if (is.null(val$score)) NA else val$score, val$evidence)
                        
                  } else if (any(vapply(val, function(x) is.list(x) && !is.null(x$present),
                                        logical(1)))) {
                        # ---- PRESENCE-nested (checklist / components): dict of {present, evidence}
                        # A checklist may ALSO carry a free-text companion field (e.g.
                        # named_entities, a plain array) alongside the present/absent categories.
                        # Tabulate only the sub-items that actually have `present`; skip the rest
                        # (they're not categories). This is why we test `any` present-shaped, not
                        # `all` — one free-text field must not disqualify the whole checklist.
                        for (category in names(val)) {
                              cat_val <- val[[category]]
                              if (!is.list(cat_val) || is.null(cat_val$present)) next  # skip free-text
                              acc$checks[[length(acc$checks) + 1]] <- cbind(dc, data.frame(
                                    theme = theme, checklist = element, category = category,
                                    present = isTRUE(cat_val$present),
                                    n_evidence = .n_evidence(cat_val$evidence),
                                    stringsAsFactors = FALSE))
                              emit_evidence(theme, element, category,
                                            isTRUE(cat_val$present), cat_val$evidence)
                        }
                  }
                  # (anything else — unexpected shape — is skipped, not force-fit)
            }
      }
      
      list(
            scores     = if (length(acc$scores)) do.call(rbind, acc$scores) else NULL,
            checklists = if (length(acc$checks)) do.call(rbind, acc$checks) else NULL,
            evidence   = if (length(acc$evid))   do.call(rbind, acc$evid)   else NULL
      )
}

# ---- PHASE: tabulate(config) --------------------------------------------------
# finalized_dir/*.json -> tables/{scores_long,checklists_long,evidence}.csv
# No API cost; pure transformation. Overwrites the tables each run (they're a
# derived view of the current finalized set). Writes a tabulate_report.csv row
# per document (rows contributed to each table), so extraction gaps are visible.
tabulate <- function(config) {
      tables_dir <- config$tables_dir %||% path(config$out_dir %||%
                                                      path_dir(config$finalized_dir), "tables")
      dir_create(tables_dir)
      jsons <- dir_ls(config$finalized_dir, glob = "*.json")
      # Exclude the report CSVs / truncated sidecars — only real records.
      jsons <- jsons[!grepl("\\.truncated\\.json$", jsons)]
      if (length(jsons) == 0) {
            message("[tabulate] no finalized records in ", config$finalized_dir); return(invisible())
      }
      message("[tabulate] ", length(jsons), " records -> ", tables_dir)
      
      all_scores <- list(); all_checks <- list(); all_evid <- list(); rep_rows <- list()
      for (jf in jsons) {
            doc_id <- path_ext_remove(path_file(jf))
            out <- tryCatch({
                  rec <- jsonlite::read_json(jf, simplifyVector = FALSE)
                  .tabulate_record(rec, doc_id)
            }, error = function(e) {
                  message("  [tabulate ERROR] ", doc_id, ": ", conditionMessage(e)); NULL
            })
            if (is.null(out)) {
                  rep_rows[[length(rep_rows) + 1]] <- data.frame(doc_id = doc_id,
                                                                 n_scores = NA_integer_, n_checklist = NA_integer_, n_evidence = NA_integer_,
                                                                 status = "error", stringsAsFactors = FALSE)
                  next
            }
            if (!is.null(out$scores))     all_scores[[length(all_scores) + 1]] <- out$scores
            if (!is.null(out$checklists)) all_checks[[length(all_checks) + 1]] <- out$checklists
            if (!is.null(out$evidence))   all_evid[[length(all_evid) + 1]]     <- out$evidence
            rep_rows[[length(rep_rows) + 1]] <- data.frame(doc_id = doc_id,
                                                           n_scores    = if (is.null(out$scores)) 0L else nrow(out$scores),
                                                           n_checklist = if (is.null(out$checklists)) 0L else nrow(out$checklists),
                                                           n_evidence  = if (is.null(out$evidence)) 0L else nrow(out$evidence),
                                                           status = "ok", stringsAsFactors = FALSE)
      }
      
      bind <- function(x) if (length(x)) do.call(rbind, x) else NULL
      scores_df <- bind(all_scores); checks_df <- bind(all_checks); evid_df <- bind(all_evid)
      
      if (!is.null(scores_df)) write_csv(scores_df, path(tables_dir, "scores_long.csv"))
      if (!is.null(checks_df)) write_csv(checks_df, path(tables_dir, "checklists_long.csv"))
      if (!is.null(evid_df))   write_csv(evid_df,   path(tables_dir, "evidence.csv"))
      
      # tabulate report at out_dir root, consistent with the other phase reports.
      trp <- config$tabulate_report %||% path(config$out_dir %||% tables_dir,
                                              "tabulate_report.csv")
      write_csv(do.call(rbind, rep_rows), trp)
      
      message("[tabulate] done: ",
              if (!is.null(scores_df)) nrow(scores_df) else 0, " score rows, ",
              if (!is.null(checks_df)) nrow(checks_df) else 0, " checklist rows, ",
              if (!is.null(evid_df))   nrow(evid_df)   else 0, " evidence rows.")
      invisible(list(scores = scores_df, checklists = checks_df, evidence = evid_df))
}