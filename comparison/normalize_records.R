# ==== Record Normalization ======================================================
# Flattens coded JSON records (from any run) into a LONG table: one row per
# (document, element, run). This is the single intermediate every comparison
# operates on — agreement, IRR (kappa/alpha), verification, and cost all consume
# it. The "run" is identified by a tag-set read from each record's coding_meta
# (model, codebook_version, ingest, design), so the comparison engine can group
# by whatever axis is being tested and detect confounds (runs differing on an
# axis you didn't intend to vary).
#
# Element taxonomy (17 scored elements across 4 themes) + three component
# checklists (adaptive_capacity_components, biological_unit_components,
# management_scale). Scored elements contribute a score (per-element range 0-1,
# 0-2, or 0-3) + evaluable flag. Component checklists contribute per-component
# present/absent booleans, which we also emit as rows (score = 1/0) so they flow
# through the same agreement math. Theme 5 (citations) is deferred, not scored.

library(jsonlite)
library(fs)

# Scored elements by theme (each has score + evaluable + evidence).
# Updated for codebook v0.4: 3.1 management_scale moved to .COMPONENTS (retyped to
# checklist); context/action keys renamed where definitions changed; 4.4/4.5 added.
# Theme 5 (citations) deferred — not scored here.
.SCORED <- list(
      concepts = c("climate_vulnerability", "adaptive_capacity_specificity", "connectivity"),
      tools    = c("vulnerability_models", "niche_models", "climate_models",
                   "connectivity_models"),
      context  = c("biological_unit_score", "partnerships_and_funding",
                   "climate_threat_habitat_degradation",
                   "climate_threat_species_vital_rates",     # was climate_threat_species_mortality
                   "climate_threat_biotic_stressors"),        # was climate_threat_invasion_succession
      actions  = c("priority_habitat_identification",         # was priority_habitat_restoration
                   "targeted_range_shift_actions",            # was range_shift_facilitation
                   "time_bound_and_monitoring",
                   "evidence_of_efficacy",                    # NEW 4.4 (0-3)
                   "adaptation_planning_frameworks")          # NEW 4.5 (0-2)
)
# Component checklists: theme -> (container key, component names).
.COMPONENTS <- list(
      list(theme = "concepts", key = "adaptive_capacity_components",
           comps = c("demography", "distribution", "movement", "evolutionary_potential",
                     "ecological_dependencies", "abiotic_niche", "life_history")),
      list(theme = "context", key = "biological_unit_components",
           comps = c("species", "population", "habitat", "ecosystem", "community",
                     "genotype_phenotype")),
      # 3.1 management_scale retyped from scored to multi-select checklist (v0.4).
      list(theme = "context", key = "management_scale",
           comps = c("local","site","watershed","city","county","within_state_region",
                     "state","multistate","national","transnational","ecosystem",
                     "ecoregion","province","section","subsection","lake","river","district"))
)

# Pull the run's tag-set from coding_meta, with safe fallbacks. These tags are
# the run's IDENTITY; the directory is just where it lives. Prefers the
# first-class structured fields (model, provider, ingest, design); falls back to
# sniffing legacy records that predate structured stamping.
.run_tags <- function(rec, dir_label = NA_character_) {
      cm <- rec$coding_meta %||% list()
      list(
            model     = cm$model %||% cm$coder %||% NA_character_,
            provider  = cm$provider %||% NA_character_,
            codebook  = cm$codebook_version %||% NA_character_,
            ingest    = cm$ingest %||% NA_character_,
            design    = cm$design %||%                                # structured (new)
                  (if (grepl("single-call", cm$notes %||% "", ignore.case = TRUE))
                        "single" else NA_character_),             # sniff (legacy)
            dir_label = dir_label
      )
}

# Normalize ONE record into a data.frame of element rows.
normalize_one <- function(rec, run_label, dir_label = NA_character_) {
      doc_id <- rec$document_meta$document_id %||% rec$document_id %||% NA_character_
      tags   <- .run_tags(rec, dir_label)
      rows <- list()
      
      add <- function(theme, element, kind, score, evaluable) {
            rows[[length(rows) + 1]] <<- data.frame(
                  run = run_label, doc_id = doc_id, theme = theme, element = element,
                  kind = kind, score = score, evaluable = evaluable,
                  model = tags$model, provider = tags$provider, codebook = tags$codebook,
                  ingest = tags$ingest, design = tags$design,
                  stringsAsFactors = FALSE
            )
      }
      
      # scored elements
      for (theme in names(.SCORED)) {
            for (el in .SCORED[[theme]]) {
                  o <- rec[[theme]][[el]]
                  if (is.null(o)) { add(theme, el, "score", NA_integer_, NA); next }
                  sc <- suppressWarnings(as.integer(o$score %||% NA))
                  ev <- o$evaluable %||% NA
                  add(theme, el, "score", sc, isTRUE(ev))
            }
      }
      # component checklists -> one row per component (score = 1 present / 0 absent)
      for (cc in .COMPONENTS) {
            cont <- rec[[cc$theme]][[cc$key]]
            for (comp in cc$comps) {
                  present <- tryCatch(isTRUE(cont[[comp]]$present), error = function(e) NA)
                  add(cc$theme, paste0(cc$key, ".", comp), "component",
                      if (is.na(present)) NA_integer_ else as.integer(present),
                      !is.na(present))
            }
      }
      do.call(rbind, rows)
}

# Normalize a whole run: a directory of *.json (excluding sidecars). run_label is
# the identity you assign this run (e.g. "pdf", "text", "sonnet5", "rep_01").
normalize_run <- function(dir, run_label) {
      files <- dir_ls(dir, glob = "*.json")
      files <- files[!grepl("\\.truncated\\.json$|verification|report", files)]
      if (length(files) == 0) stop("No JSON records in ", dir)
      parts <- lapply(files, function(f) {
            rec <- tryCatch(fromJSON(f, simplifyVector = FALSE),
                            error = function(e) { warning("bad JSON: ", f); NULL })
            if (is.null(rec)) return(NULL)
            normalize_one(rec, run_label, dir_label = path_file(dir))
      })
      do.call(rbind, parts[!vapply(parts, is.null, logical(1))])
}

# Normalize several runs into one long table (rbind of normalize_run calls).
# runs: named list like list(pdf = "path/to/pdf", text = "path/to/text").
normalize_runs <- function(runs) {
      do.call(rbind, Map(function(dir, lab) normalize_run(dir, lab),
                         runs, names(runs)))
}

`%||%` <- function(a, b) if (is.null(a) || length(a) == 0 ||
                             (length(a) == 1 && is.na(a))) b else a