# summarize range shift science concepts in SWAPs and SFAPs 

library(tidyverse)
library(patchwork)

# Load data ####

# define regions
regions <- bind_rows(data.frame(region = 'Alaska', juris = c("AK")),
                     data.frame(region = 'Midwest', juris = c("MN", "IA", "MI", "MO", "WI", "IN", "IL", "OH")),
                     data.frame(region = 'North Central', juris = c("CO", "KS", "MT", "ND", "NE", "SD", "WY")),
                     data.frame(region = 'Northeast', juris = c("CT","DC","DE", "KY", "MA", "MD", "ME", "NH", "NJ", "NY", "PA", "RI", "VA", "VT", "WV")),
                     data.frame(region = 'Northwest', juris = c("WA", "OR", "ID")),
                     data.frame(region = 'Pacific Islands', juris = c("AmericanSamoa", "ASM", "CNMI", "FSM", "GU", "HI", "PW", "RMI")),
                     data.frame(region = 'South Central', juris = c("OK", "TX", "NM", "LA")),
                     data.frame(region = 'Southeast', juris = c("NC", "SC", "USVI", "PR", "GA", "AL", "MS", "FL", "TN", "AR", "VI")),
                     data.frame(region = 'Southwest', juris = c("AZ", "NV", "UT","CA")))

# Load scores, evidence, and checklist tables and filter for 'concepts' theme

concept_scores <- c("output/swap_run01/tables/scores_long.csv","output/sfap_run01/tables/scores_long.csv") %>%
  purrr::map(read_csv) %>%
  bind_rows() %>% 
  left_join(regions) %>% 
  filter(theme %in% "concepts")

concept_evidence <- c('output/swap_run01/tables/evidence.csv', 'output/sfap_run01/tables/evidence.csv') %>% 
  purrr::map(read_csv) %>% 
  bind_rows() %>%
  left_join(regions) %>% 
  filter(theme %in% "concepts")

concept_checklist <- c('output/swap_run01/tables/checklists_long.csv', 'output/sfap_run01/tables/checklists_long.csv') %>% 
  purrr::map(read_csv) %>% 
  bind_rows() %>%
  left_join(regions) %>% 
  filter(theme %in% "concepts")

# Element 1.1: Climate Vulnerability ####

# How did the plans engage with the concept of climate vulnerability?

vulnerability_scores <- concept_scores %>% 
  filter(element %in% "climate_vulnerability")
table(concept_scores$score, concept_scores$doc_type)

vulnerability_scores %>%
  filter(doc_type %in% c("FAP", "SWAP")) %>% 
  mutate(doc_type = case_when(doc_type == "FAP" ~ "Forest Plan",
                              doc_type == "SWAP" ~ "Wildlife Plan")) %>% 
  mutate(score = case_when(
    score == "0" ~ "No Mention",
    score == "1" ~ "Non-Specific\nMention",
    score == "2" ~ "Climate Exposure\nor AC",
    score == "3" ~ "Climate Exposure\n& AC"),
    score = fct_relevel(score, "Climate Exposure\n& AC", "Climate Exposure\nor AC", "Non-Specific\nMention", "No Mention")) %>% 
  group_by(doc_type) %>% 
  count(score) %>%
  arrange(score) %>% 
  ungroup() %>%
  ggplot(aes(x = "", y = n, fill = as.factor(score))) +
  geom_bar(stat = "identity", width = 1, color = "white") +
  geom_text(aes(label = score), position = position_stack(vjust = 0.5), color = "gray22", size = 7)+
  theme_minimal() +
  labs(x = "", y = "")+
  scale_fill_brewer(palette = "Set2", name = "Action")+
  theme(
      axis.text.x = element_blank(),
      axis.text.y = element_text(size = 15),
      axis.ticks.y = element_line(),
      strip.text = element_text(size = 24),
      panel.grid = element_blank(),
      legend.box = "horizontal",
      legend.position = "none",
      legend.text = element_text(size = 14),
      legend.title = element_text(size = 24),
  ) + 
  facet_wrap(~doc_type, ncol = 2)

ggsave("analysis/figures/concepts_by_doc_type_vulnerability.png", height = 7, width = 6, units = "in")


# Element 1.2: Adaptive Capacity Specificity ####

# Did the plans reference adaptive capacity? If so, did they do so in a specific or non-specific way?

adaptive_capacity_scores <- concept_scores %>% 
  filter(element %in% 'adaptive_capacity_specificity')
table(adaptive_capacity_scores$score, adaptive_capacity_scores$doc_type)

adaptive_capacity_scores %>%
  filter(doc_type %in% c("FAP", "SWAP")) %>% 
  mutate(doc_type = case_when(doc_type == "FAP" ~ "Forest Plan",
                              doc_type == "SWAP" ~ "Wildlife Plan")) %>% 
  mutate(score = case_when(
    score == "0" ~ "No Reference",
    score == "1" ~ "General Reference",
    score == "2" ~ "Specific Components\n Referenced"),
    score = fct_relevel(score, "Specific Components\n Referenced", "General Reference", "No Reference")) %>% 
  group_by(doc_type) %>% 
  count(score) %>%
  arrange(score) %>% 
  ungroup() %>%
  ggplot(aes(x = "", y = n, fill = as.factor(score))) +
  geom_bar(stat = "identity", width = 1, color = "white") +
  geom_text(aes(label = score), position = position_stack(vjust = 0.5), color = "gray22", size = 6)+
  theme_minimal() +
  labs(x = "", y = "")+
  scale_fill_brewer(palette = "Set2", name = "")+
  theme(
    axis.text.y = element_text(size = 15),
    axis.ticks.y = element_line(),
    strip.text = element_text(size = 20),
    panel.grid = element_blank(),
    legend.position = "none") + 
  facet_wrap(~doc_type, ncol = 2)

# Adaptive capacity scores by state and region

juris_means <- adaptive_capacity_scores %>%
  mutate(juris = case_when(juris == "USVI" ~ "VI",
                           juris == "AmericanSamoa" ~ "ASM",
                           juris == "CNMI" ~ "MP",
                           .default = juris)) %>% 
  group_by(region, juris) %>% 
  summarize(AC_mean_score = mean(score))

region_means <- adaptive_capacity_scores %>%
  mutate(juris = case_when(juris == "USVI" ~ "VI",
                           juris == "AmericanSamoa" ~ "ASM",
                           .default = juris)) %>% 
  group_by(region) %>% 
  summarize(mean_score = mean(score))

# write.csv(juris_means, "analysis/analyze_concepts/adaptive_capacity_mean_scores.csv", row.names = FALSE)
# save as CSV to plot in ArcGIS.... but will also try mapping here below

## Mapping attempt ####

library(sf)
library(tigris)
library(tidyverse)
library(patchwork)

options(tigris_use_cache = TRUE)

# CONUS, AK, PR, & HI
us_map <- states(cb = TRUE, resolution = "20m") %>% shift_geometry()
map_data <- us_map %>%
  left_join(juris_means, by = c("STUSPS" = "juris"))

p1 <- ggplot(data = map_data) +
  geom_sf(aes(fill = AC_mean_score), color = "white", size = 0.2) +
  scale_fill_gradient(low = "gray89", high = "darkblue", name = "Adaptive Capacity\n Score")+
  theme_void() + 
  theme(
    legend.position = "bottom",
    legend.title = element_text(size = 24, hjust = 0.5),
    legend.text = element_text(size = 14),
    plot.title = element_text(face = "bold", hjust = 0.5, size = 16))

# ASM, GU, MP, FSM, MI

p2 <- juris_means %>% 
  filter(juris %in% c("ASM", "GU", "MP", 'FSM', "MI")) %>% 
  ggplot()+
  geom_tile(aes(x = 1, y = juris, fill = AC_mean_score), color = "white", size = 0.2, linewidth = 3)+
  scale_fill_gradient(low = "gray89", high = "darkblue", name = "Score")+
  theme_void()+
  coord_fixed(ratio = 1)+
  theme(
    axis.title = element_blank(),
    axis.text.x = element_blank(),
    axis.text.y = element_text(size = 12),
    legend.position = "none"
  )

p1 +
  inset_element(p2, left = 0.85, bottom = 0.25, right = 1, top = 0.5, align_to = "full")

# ggsave("analysis/figures/adaptive_capacity_mean_scores_map.png", height = 5, width = 10)

# Element 1.3: Adaptive Capacity Components ####


# extract no reference and general reference scores to add to checklist (specific references)

add <- adaptive_capacity_scores %>% 
  filter(score %in% c(0,1)) %>% 
  mutate(category = case_when(score == 0 ~ "Not Addressed",
                              score == 1 ~ "General Reference"),
         present = TRUE) %>% 
  select(doc_id, juris, doc_type, year, category, present)

concept_checklist %>% 
  filter(checklist %in% 'adaptive_capacity_components') %>%  # note not necessary bc this is the only checklist in this theme
  bind_rows(add) %>% 
  filter(doc_type %in% c("FAP", "SWAP"),
         present == TRUE) %>% 
  mutate(doc_type = case_when(doc_type == "FAP" ~ "Forest Plan",
                              doc_type == "SWAP" ~ "Wildlife Plan")) %>% 
  mutate(category = case_when(
    category == "abiotic_niche" ~ "Abiotic Niche",
    category == "demography" ~ "Demography",
    category == "distribution" ~ "Distribution",
    category == "ecological_dependencies" ~ "Ecological Dependencies",
    category == "evolutionary_potential" ~ "Evolutionary Potential",
    category == "life_history" ~ "Demography",
    category == "movement" ~ "Movement",
    .default = category),
    category = fct_relevel(category, c("Demography", "Movement", "Distribution", "Abiotic Niche", "Ecological Dependencies", "Evolutionary Potential", "General Reference", "Not Addressed"))) %>%
  group_by(doc_type) %>% 
  count(category) %>% 
  arrange(category) %>% 
  ungroup() %>% 
  ggplot(aes(x = "", y = n, fill = category)) +
  geom_bar(stat = "identity", width = 1, color = "white") +
  geom_text(aes(label = category), position = position_stack(vjust = 0.5), color = "gray22", size = 6)+
  theme_minimal() +
  labs(x = "", y = "")+
  scale_fill_brewer(palette = "Set2", name = "")+
  theme(
    axis.text.y = element_text(size = 15),
    axis.ticks.y = element_line(),
    strip.text = element_text(size = 20),
    panel.grid = element_blank(),
    legend.position = "none"
  ) + 
  facet_wrap(~doc_type, ncol = 2)

ggsave("analysis/figures/ac_components_by_doc_type.png", height = 12, width = 10, units = 'in')


