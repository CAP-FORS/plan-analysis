# ==== Agreement Metrics Engine ==================================================
# The core comparison computation. Consumes the long table from
# normalize_records.R and computes, for a set of runs over the same documents:
#   - exact-match agreement, adjacent (off-by-one) agreement
#   - evaluable-flag agreement, component-flag agreement
#   - Cohen's kappa (2 runs) and Krippendorff's ordinal alpha (>=2 runs)
# broken down PER ELEMENT, PER THEME, and OVERALL. Every comparison type
# (pdf/text, single/two-pass, model/model, human/model, codebook version,
# repeat-variance) reduces to this same call — the axis is just a grouping label.
#
# MIXED SCORE RANGES (codebook v0.4): elements span 0-1, 0-2, and 0-3 scales.
# Per-element and per-theme metrics are the primary, cleanest read. The POOLED
# "overall" α/agreement blends elements of different ranges — still meaningful as
# a summary, but interpret it alongside the per-element breakdown, since a 0-1
# element's "adjacent" agreement is trivially 100% (any disagreement is within 1)
# while a 0-3 element can disagree by up to 3. The ordinal α distance metric
# handles this correctly per element; the caveat is only about reading the single
# pooled number in isolation.
#
# EVALUABLE HANDLING is configurable (per project decision) because how you treat
# a cell where one coder said evaluable=FALSE and another gave a score materially
# affects IRR. Three modes, reported so you can see sensitivity:
#   "exclude"  : drop cells where ANY run has evaluable=FALSE (listwise).
#   "category" : treat FALSE as its own category (score = -1 sentinel) so a
#                 FALSE-vs-2 disagreement counts as maximal disagreement.
#   "disagree" : keep numeric scores; a FALSE-vs-score cell counts as a mismatch
#                 for simple agreement but the FALSE side is NA for kappa/alpha.
#
# IRR via the `irr` package (vetted implementations). Ordinal alpha is the
# headline for 0/1/2 scores (off-by-one < off-by-two); kappa reported for
# comparability. See validate_metrics() at the bottom for a known-answer check.

library(irr)
library(tidyr)
library(dplyr)

# Reshape the long table to a (unit x run) matrix of scores for one element (or
# all), applying the chosen evaluable handling. Units are (doc_id, element).
.score_matrix <- function(df, evaluable_mode = "category") {
      d <- df
      if (evaluable_mode == "exclude") {
            # drop any (doc,element) where any run is non-evaluable
            bad <- d %>% group_by(doc_id, element) %>%
                  summarise(drop = any(!evaluable %in% TRUE), .groups = "drop") %>%
                  filter(drop)
            d <- anti_join(d, bad, by = c("doc_id", "element"))
      } else if (evaluable_mode == "category") {
            d$score <- ifelse(d$evaluable %in% TRUE, d$score, -1L)  # FALSE -> sentinel
      } else if (evaluable_mode == "disagree") {
            d$score <- ifelse(d$evaluable %in% TRUE, d$score, NA_integer_)
      }
      wide <- d %>%
            select(doc_id, element, run, score) %>%
            pivot_wider(names_from = run, values_from = score)
      as.matrix(wide[, setdiff(names(wide), c("doc_id", "element")), drop = FALSE])
}

# Core metric set for a score matrix (units x runs). Returns a one-row data.frame.
.metrics_for_matrix <- function(m) {
      if (is.null(m) || nrow(m) == 0 || ncol(m) < 2) {
            return(data.frame(n = 0, exact = NA, adjacent = NA, kappa = NA, alpha = NA))
      }
      # exact & adjacent agreement across runs, per unit, then averaged.
      row_exact <- apply(m, 1, function(r) {
            r <- r[!is.na(r)]; if (length(r) < 2) NA else as.integer(length(unique(r)) == 1)
      })
      row_adj <- apply(m, 1, function(r) {
            r <- r[!is.na(r)]; if (length(r) < 2) NA else as.integer(diff(range(r)) <= 1)
      })
      # Cohen's kappa only defined for exactly 2 runs.
      kap <- NA_real_
      if (ncol(m) == 2) {
            cc <- m[stats::complete.cases(m), , drop = FALSE]
            if (nrow(cc) > 1 && length(unique(c(cc))) > 1)
                  # suppressWarnings: kappa2 computes a significance test (sqrt of a kappa
                  # variance) that produces harmless NaN warnings when agreement is high or a
                  # category is unused. We use only the kappa VALUE, not its p-value.
                  kap <- suppressWarnings(tryCatch(
                        kappa2(cc, weight = "unweighted")$value, error = function(e) NA))
      }
      # Krippendorff's ordinal alpha (irr wants runs x units).
      alp <- NA_real_
      tm <- t(m)
      if (nrow(tm) >= 2 && sum(stats::complete.cases(t(tm))) > 1)
            alp <- tryCatch(kripp.alpha(tm, method = "ordinal")$value, error = function(e) NA)
      
      data.frame(
            n = nrow(m),
            exact = mean(row_exact, na.rm = TRUE),
            adjacent = mean(row_adj, na.rm = TRUE),
            kappa = kap, alpha = alp
      )
}

# Public: full agreement report at overall / per-theme / per-element granularity.
# df = long table (>=2 runs). Returns a list of data.frames.
agreement_report <- function(df, evaluable_mode = "category") {
      scored <- df %>% filter(kind %in% c("score", "component"))
      
      # overall
      m_all <- .score_matrix(scored, evaluable_mode)
      overall <- cbind(scope = "OVERALL", .metrics_for_matrix(m_all))
      
      # per theme
      themes <- unique(scored$theme)
      per_theme <- do.call(rbind, lapply(themes, function(th) {
            m <- .score_matrix(filter(scored, theme == th), evaluable_mode)
            cbind(scope = paste0("theme:", th), .metrics_for_matrix(m))
      }))
      
      # per element
      els <- unique(scored$element)
      per_element <- do.call(rbind, lapply(els, function(el) {
            m <- .score_matrix(filter(scored, element == el), evaluable_mode)
            cbind(scope = paste0("element:", el), .metrics_for_matrix(m))
      }))
      
      # evaluable-flag agreement (separate: do runs agree on WHETHER to score?)
      ev_wide <- scored %>% select(doc_id, element, run, evaluable) %>%
            pivot_wider(names_from = run, values_from = evaluable)
      ev_m <- as.matrix(ev_wide[, setdiff(names(ev_wide), c("doc_id","element")), drop=FALSE])
      ev_agree <- mean(apply(ev_m, 1, function(r){r<-r[!is.na(r)]
      if(length(r)<2) NA else as.integer(length(unique(r))==1)}), na.rm=TRUE)
      
      list(
            overall = overall,
            per_theme = per_theme,
            per_element = per_element,
            evaluable_agreement = ev_agree,
            evaluable_mode = evaluable_mode
      )
}

# Run the report under ALL THREE evaluable modes so sensitivity is visible.
agreement_report_all_modes <- function(df) {
      modes <- c("exclude", "category", "disagree")
      setNames(lapply(modes, function(mm) agreement_report(df, mm)), modes)
}

`%||%` <- function(a, b) if (is.null(a) || length(a) == 0) b else a

# ==== Validation against a known-answer case ====================================
# Sanity-checks the metric implementations against hand-computable values, so we
# trust kappa/alpha before using them on real data. Run validate_metrics().
validate_metrics <- function() {
      # Perfect agreement -> exact=1, alpha=1, kappa=1.
      perfect <- data.frame(
            run = rep(c("a","b"), each = 4),
            doc_id = rep(c("d1","d2","d3","d4"), 2),
            theme = "concepts", element = "x", kind = "score",
            score = c(0,1,2,1, 0,1,2,1), evaluable = TRUE,
            model=NA, codebook=NA, ingest=NA, design=NA, stringsAsFactors = FALSE
      )
      rp <- agreement_report(perfect, "category")
      cat("perfect-agreement case: exact=", rp$overall$exact,
          " alpha=", round(rp$overall$alpha,3),
          " kappa=", round(rp$overall$kappa,3), " (all should be 1)\n", sep="")
      
      # One off-by-one disagreement out of 4: exact=0.75, adjacent=1.
      offone <- perfect; offone$score[8] <- 2   # b's d4: 1 -> 2
      rp2 <- agreement_report(offone, "category")
      cat("one-off-by-one case: exact=", round(rp2$overall$exact,3),
          " adjacent=", rp2$overall$adjacent, " (exact~0.75, adjacent=1)\n", sep="")
      
      # Ordinal vs nominal: alpha should PENALIZE off-by-two more than off-by-one.
      offtwo <- perfect; offtwo$score[8] <- 3   # off-by-two/three, tests ordinal distance metric (0-3 elements like 1.1/4.4 exist)
      invisible(list(perfect = rp, offone = rp2))
}