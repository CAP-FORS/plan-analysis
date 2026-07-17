# summarize range shift science concepts in SWAPs and SFAPs 

library(tidyverse)
# library(vegan)
# library(ggforce)
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
vulnerability_scores <- c("output/swap_run01/tables/scores_long.csv","output/sfap_run01/tables/scores_long.csv") %>%
  purrr::map(read_csv) %>%
  bind_rows() %>% 
  left_join(regions) %>% 
  filter(theme %in% "concepts") %>% 
  filter(element %in% "climate_vulnerability")
table(concept_scores$score, concept_scores$doc_type)

vulnerability_scores %>%
  filter(doc_type %in% c("FAP", "SWAP")) %>% 
  mutate(doc_type = case_when(doc_type == "FAP" ~ "Forest Plan",
                              doc_type == "SWAP" ~ "Wildlife Plan")) %>% 
  group_by(doc_type) %>% 
  count(score) %>%
  mutate(percent = n/sum(n), label = paste0(score, "\n(", scales::percent(percent, accuracy = 1), ")")) %>%
  arrange(score) %>% 
  mutate(label_y = cumsum(percent) - (percent / 2)) %>%
  ungroup() %>%
  ggplot(aes(x = "", y = n, fill = as.factor(score))) +
  geom_bar(stat = "identity", width = 1, color = "white") +
  geom_text(aes(label = label), position = position_stack(vjust = 0.5), color = "gray22", size = 6)+
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

vulnerability_scores %>% 
  filter(doc_type %in% c("FAP", "SWAP")) %>% 
  count(score, doc_type) %>% 
  ggplot(., aes(x = as.factor(score), y = n, fill = doc_type))+
  geom_bar(stat = 'identity', position = 'stack', color = "white")+
  scale_fill_brewer(palette = "Set2", name = "Document Type")+
  theme_minimal(base_size = 18)+
  scale_x_discrete(labels = c("0" = "No Mention", "1" = "Non-Specific\nMention", "2" = "Exposure or\nAdaptive Capacity\nReferenced", "3" = "Exposure &\nAdaptive Capacity\nReferenced"))+
  labs(x = 'Climate Vulnerability', y = 'Number of Documents')+
  theme(legend.position = "inside",
        legend.position.inside = c(0.1,0.9),
        legend.background = element_rect(color = NA, fill = "white"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        # axis.ticks = element_line(),
        axis.text.x = element_text(size = 18, color = 'black', vjust = 1.2),
        axis.text.y = element_text(size = 18, color = 'black'),
        axis.title = element_text(size = 24)) 

concept_evidence <- c('output/swap_run01/tables/evidence.csv', 'output/sfap_run01/tables/evidence.csv') %>% 
  purrr::map(read_csv) %>% 
  bind_rows() %>%
  left_join(regions) %>% 
  filter(theme %in% "concepts") %>% 
  select(doc_type, year, region, juris, quote)

concept_checklist <- c('output/swap_run01/tables/checklists_long.csv', 'output/sfap_run01/tables/checklists_long.csv') %>% 
  purrr::map(read_csv) %>% 
  bind_rows() %>%
  left_join(regions) %>% 
  filter(theme %in% "concepts")