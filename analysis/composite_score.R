# ============================================================================
# composite_score.R
# Single composite "depth of engagement with range-shift science" score per doc.
#
# Method: normalize each element to [0,1], collapse the AC checklist into one
# normalized element, take element-mean within each theme, then average the
# four theme means (equal theme weight). Composite in [0, 1].
# ============================================================================

library(dplyr)
library(tidyr)

# ---- Column-name constants (edit here if your CSVs differ) -----------------
.SCORE_COLS <- list(doc = "doc_id", theme = "theme", element = "element", value = "score")
.CHK_COLS   <- list(doc = "doc_id", theme = "theme", chk = "checklist",
                    cat = "category", present = "present")

# ---- Element max scale lookup ----------------------------------------------
# Per codebook v0.4. Used to normalize each element to [0,1].
# Anything not listed defaults to being inferred from observed data (see below).
.ELEMENT_MAX <- c(
      # concepts / tools / context / actions — fill/verify against codebook
      partnerships_and_funding            = 2,
      climate_threat_habitat_degradation  = 1,
      climate_threat_species_mortality    = 1,
      climate_threat_invasion_succession  = 1,
      priority_habitat_restoration        = 2,
      range_shift_facilitation            = 1,
      time_bound_and_monitoring           = 2
)

# The AC checklist, folded in as ONE element within its theme.
.AC_CHECKLIST_NAME <- "adaptive_capacity_components"
.AC_THEME          <- "context"   # theme the AC checklist belongs to

# ============================================================================
# compute_composite()
#   scores_long     : data.frame (doc_id, theme, element, score)
#   checklists_long : data.frame (doc_id, theme, checklist, category, present)
#   null_as         : how to treat null/insufficient-info scores:
#                     "drop"  -> excluded from that doc's element mean (default)
#                     "zero"  -> treated as 0
#   Returns: data.frame with per-theme means + composite, one row per doc_id.
# ============================================================================
compute_composite <- function(scores_long,
                              checklists_long = NULL,
                              null_as = c("drop", "zero")) {
      
      null_as <- match.arg(null_as)
      S <- .SCORE_COLS
      
      # ---- 1. Normalize each scored element to [0,1] ----
      sc <- scores_long %>%
            rename(doc_id  = !!S$doc,
                   theme   = !!S$theme,
                   element = !!S$element,
                   score   = !!S$value)
      
      # null handling
      if (null_as == "zero") {
            sc$score[is.na(sc$score)] <- 0
      } else {
            sc <- sc %>% filter(!is.na(score))
      }
      
      # resolve each element's max: codebook lookup first, else observed max (>=1)
      observed_max <- sc %>%
            group_by(element) %>%
            summarise(obs_max = max(score, na.rm = TRUE), .groups = "drop")
      
      elem_max <- observed_max %>%
            mutate(cb_max = .ELEMENT_MAX[element],
                   max_scale = ifelse(!is.na(cb_max), cb_max, pmax(obs_max, 1)))
      
      sc <- sc %>%
            left_join(elem_max %>% select(element, max_scale), by = "element") %>%
            mutate(norm = score / max_scale)
      
      # ---- 2. Collapse AC checklist into one normalized element ----
      if (!is.null(checklists_long)) {
            C <- .CHK_COLS
            chk <- checklists_long %>%
                  rename(doc_id    = !!C$doc,
                         checklist = !!C$chk,
                         present   = !!C$present) %>%
                  filter(checklist == .AC_CHECKLIST_NAME)
            
            if (nrow(chk) > 0) {
                  ac <- chk %>%
                        group_by(doc_id) %>%
                        summarise(norm = mean(as.logical(present), na.rm = TRUE),
                                  .groups = "drop") %>%
                        mutate(theme = .AC_THEME, element = .AC_CHECKLIST_NAME)
                  sc <- bind_rows(sc %>% select(doc_id, theme, element, norm), ac)
            }
      } else {
            sc <- sc %>% select(doc_id, theme, element, norm)
      }
      
      # ---- 3. Element-mean within theme, then equal-weight theme mean ----
      theme_means <- sc %>%
            group_by(doc_id, theme) %>%
            summarise(theme_score = mean(norm, na.rm = TRUE), .groups = "drop")
      
      composite <- theme_means %>%
            group_by(doc_id) %>%
            summarise(composite = mean(theme_score, na.rm = TRUE),
                      n_themes  = n(), .groups = "drop")
      
      # ---- 4. Wide output: one row per doc, theme cols + composite ----
      wide <- theme_means %>%
            pivot_wider(names_from = theme, values_from = theme_score,
                        names_prefix = "theme_") %>%
            left_join(composite, by = "doc_id") %>%
            arrange(desc(composite))
      
      wide
}

