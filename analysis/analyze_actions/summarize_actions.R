# summarize range shift management actions in SWAPs and SFAPs 

library(tidyverse)
library(vegan)
library(ggforce)
library(patchwork)

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

# read in data and filter to range shift actions
action_scores <- c("output/swap_run01/tables/scores_long.csv","output/sfap_run01/tables/scores_long.csv") %>%
  purrr::map(read_csv) %>%
  bind_rows() %>% 
  mutate(juris = ifelse(juris == "USVI", "VI", juris)) %>% 
  left_join(regions) %>% 
  filter(element %in% "targeted_range_shift_actions")

action_evidence <- c('output/swap_run01/tables/evidence.csv', 'output/sfap_run01/tables/evidence.csv') %>% 
  purrr::map(read_csv) %>% 
  bind_rows() %>%
  left_join(regions) %>% 
  filter(element %in% "targeted_range_shift_actions") %>% 
  select(doc_type, year, region, juris, quote)

# I am going to categorize these manually in a spreadsheet:
# write.csv(action_evidence, file = "analysis/analyze_actions/action_evidence.csv", row.names = FALSE)

library(readxl)
action_summary <- read_excel("analysis/analyze_actions/action_evidence_coded.xlsx") %>% 
  
  # merge coded evidence with scores and reshape the df to have one row per action
  full_join(action_scores, relationship = "many-to-many") %>%
  separate_longer_delim(cols = action_code, delim = ";") %>% 
  mutate(action_code = str_trim(action_code)) %>% 

  # also want to separate sub-codes (e.g. "policy" in "connectivity - policy") into a separate column
  separate_wider_delim(cols = action_code, delim = " - ", names = c("action_code", "sub-code"), too_few = "align_start") %>% 

  # rescore when evidence that was NA
  mutate(score = ifelse(action_code == "NA" | is.na(action_code), 0, score)) %>% 
  mutate(action_code = ifelse(action_code == "NA" | is.na(action_code), "no action", action_code)) %>% 
  
  # make actions title case
  mutate(action_code = stringr::str_to_title(action_code))


# Also want to summarize by plan: remove duplicate action codes by doc_id

doc_summary <- action_summary %>% 
  select(doc_id, doc_type, region, juris, action_code) %>% 
  distinct()


# 1. overall frequency of different actions

doc_summary %>% 
  mutate(action_code = ifelse(action_code %in% c("Facilitate Movement (Generic)", "Reduce Exposure", "Planning", "Adaptive Capacity"), "Other", action_code)) %>% 
  count(action_code) %>%
  mutate(percent = n/sum(n), label = paste0(action_code, "\n(n=", n, ")")) %>%
  ggplot(aes(y = reorder(label, percent), x = percent, fill = label)) +
  geom_bar(stat = "identity", width = 1, color = "gray75") +
  theme_minimal() +
  labs(x = "", y = "")+
  # geom_text(aes(x = 0.6, label = label), position = position_stack(vjust = 0.95), family = "Helvetica", color = "#333333") +
  scale_fill_brewer(palette = "Set2")+
  theme_minimal()+
  theme(legend.position = "none",
        panel.grid = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_text(size = 24)) 

# ggsave("analysis/figures/actions_summary.png", height = 10, width = 10, units = 'in')

# 2. variation across regions

doc_summary %>%
  mutate(action_code = ifelse(action_code %in% c("Facilitate Movement (Generic)", "Reduce Exposure", "Planning", "Adaptive Capacity"), "Other", action_code)) %>% 
  group_by(region) %>% 
  count(action_code) %>%
  mutate(percent = n/sum(n), label = paste0(action_code, "\n(", scales::percent(percent, accuracy = 1), ")")) %>%
  ggplot(aes(x = "", y = percent, fill = action_code)) +
  geom_bar(stat = "identity", width = 1, color = "gray75") +
  coord_polar("y", start = 0) +
  theme_void() +
  scale_fill_brewer(palette = "Set2", name = "Action")+
  theme(
    strip.text = element_text(size = 14),
    legend.box = "horizontal",
    legend.position = "bottom",
    legend.text = element_text(size = 14),
    legend.title = element_text(size = 24)
  ) + 
  facet_wrap(~region, ncol = 3)

# ggsave("analysis/figures/actions_by_region.png", height = 10, width = 10, units = 'in')

# 3. variation between swap and sfap

doc_summary %>%
  filter(doc_type %in% c("FAP", "SWAP")) %>% 
  mutate(doc_type = case_when(doc_type == "FAP" ~ "Forest Plan",
                              doc_type == "SWAP" ~ "Wildlife Plan")) %>% 
  mutate(action_code = fct_collapse(action_code, Other = c("Facilitate Movement (Generic)", "Reduce Exposure", "Planning", "Adaptive Capacity")),
         action_code = fct_relevel(action_code, "Connectivity", "Assisted Migration", "No Action", "Climate Refugia", "Species Selection", "Other")) %>% 
  group_by(doc_type) %>% 
  count(action_code) %>%
  mutate(percent = n/sum(n), label = paste0(action_code, "\n(", scales::percent(percent, accuracy = 1), ")")) %>%
  arrange(desc(action_code)) %>% 
  mutate(label_y = cumsum(percent) - (percent / 2)) %>%
  ungroup() %>%
  ggplot(aes(x = "", y = n, fill = action_code)) +
  geom_bar(stat = "identity", width = 1, color = "white") +
  # geom_text(aes(label = action_code), position = position_stack(vjust = 0.5), color = "gray22", size = 6)+
  theme_minimal() +
  labs(x = "", y = "")+
  scale_fill_brewer(palette = "Set2", name = "Action")+
  theme(
    axis.text.y = element_text(size = 15),
    axis.ticks.y = element_line(),
    strip.text = element_text(size = 24),
    panel.grid = element_blank(),
    legend.box = "horizontal",
    legend.position = "none",
    legend.text = element_text(size = 14),
    legend.title = element_text(size = 24),
  ) + 
  facet_wrap(~doc_type, ncol = 3)

ggsave("analysis/figures/actions_by_doc_type.png", height = 7, width = 6, units = 'in')


# PERMANOVA: action ~ region

# Reshape the data
community_wide <- doc_summary %>%
  mutate(action_code = ifelse(action_code %in% c("Facilitate Movement (Generic)", "Reduce Exposure", "Planning", "Adaptive Capacity"), "Other", action_code),
         region = case_when(
           region %in% 'Alaska' ~ "Northwest",
           region %in% 'South Central' ~ 'North & South Central',
           region %in% 'North Central' ~ 'North & South Central',
           .default = region
         )) %>% 
  count(doc_id, region, action_code) %>% 
  pivot_wider(names_from = action_code, values_from = n, values_fill = 0)

# Create model inputs: actions (dependent variables) and environmental data (independent variables)
action_matrix <- community_wide %>% 
  select(-doc_id, -region)
env_data <- community_wide %>% 
  select(region)

# Run the PERMANOVA
permanova_result <- adonis2(action_matrix ~ region, data = env_data, method = "jaccard")
print(permanova_result)

# Check multivariate dispersion (homogeneity of variance)
dist_matrix <- vegdist(action_matrix, method = "jaccard")
dispersion <- betadisper(dist_matrix, env_data$region)
anova(dispersion)

# Create a PCA ordination for coordinates
pcoa_res <- cmdscale(dist_matrix, k = 2, eig = TRUE)
pcoa_data <- as.data.frame(pcoa_res$points) %>%
  rename(PCo1 = V1, PCo2 = V2) %>%
  mutate(region = env_data$region)

# Extract p-val and variance explained
p_val <- permanova_result$`Pr(>F)`[1]
eig1 <- round(pcoa_res$eig[1] / sum(pcoa_res$eig) * 100, 1)
eig2 <- round(pcoa_res$eig[2] / sum(pcoa_res$eig) * 100, 1)

# Plotting
region_ord <- ggplot(pcoa_data, aes(x = PCo1, y = PCo2, color = region)) +
  stat_ellipse(aes(fill = region), geom = "polygon", alpha = 0.2, level = 0.95, color = NA) +
  geom_jitter(size = 1, alpha = 0.8,width = 0.2, height = 0.2) +
  theme_minimal() +
  labs(
    subtitle = paste("PERMANOVA: R² = ", round(permanova_result$R2[1], 3),", p-value = ", p_val),
    x = paste0("PCo1 (", eig1, "%)"),
    y = paste0("PCo2 (", eig2, "%)")) +
  scale_fill_brewer(palette = "Set2", name = "Region")+
  scale_color_brewer(palette = "Set2", name = "Region")

# Repeat for document type
# PERMANOVA: action ~ doc_type

# Make model inputs
community_wide <- doc_summary %>%
  mutate(action_code = ifelse(action_code %in% c("Facilitate Movement (Generic)", "Reduce Exposure", "Planning", "Adaptive Capacity"), "Other", action_code)) %>%
  filter(doc_type %in% c("SWAP", "FAP")) %>% 
  count(doc_id, doc_type, action_code) %>% 
  pivot_wider(names_from = action_code, values_from = n, values_fill = 0)

action_matrix <- community_wide %>% 
  select(-doc_id, -doc_type)

env_data <- community_wide %>% 
  select(doc_type)

# Run the model
permanova_result <- adonis2(action_matrix ~ doc_type, data = env_data, method = "jaccard")
print(permanova_result)

# Check multivariate dispersion (homogeneity of variance)
dist_matrix <- vegdist(action_matrix, method = "jaccard")
dispersion <- betadisper(dist_matrix, env_data$doc_type)
anova(dispersion)

# Create a PCA
pcoa_res <- cmdscale(dist_matrix, k = 2, eig = TRUE)
pcoa_data <- as.data.frame(pcoa_res$points) %>%
  rename(PCo1 = V1, PCo2 = V2) %>%
  mutate(doc_type = env_data$doc_type)

# Extract P-val and variance explained
eig1 <- round(pcoa_res$eig[1] / sum(pcoa_res$eig) * 100, 1)
eig2 <- round(pcoa_res$eig[2] / sum(pcoa_res$eig) * 100, 1)
p_val <- permanova_result$`Pr(>F)`[1]

# Build the plot
plan_ord <- ggplot(pcoa_data, aes(x = PCo1, y = PCo2, color = doc_type)) +
  stat_ellipse(aes(fill = doc_type), geom = "polygon", alpha = 0.2, level = 0.95, color = NA) +
  geom_jitter(size = 1, alpha = 0.8,width = 0.05, height = 0.05) +
  theme_minimal() +
  labs(subtitle = paste("PERMANOVA: R² = ", round(permanova_result$R2[1], 3),", p-value = ", p_val),
    x = paste0("PCo1 (", eig1, "%)"),
    y = paste0("PCo2 (", eig2, "%)")) +
  scale_fill_brewer(palette = "Set2", name = "Plan Type")+
  scale_color_brewer(palette = "Set2", name = "Plan Type")
  
region_ord + plan_ord
ggsave('analysis/figures/actions_ordination_plots.png', height = 6, width = 12)
