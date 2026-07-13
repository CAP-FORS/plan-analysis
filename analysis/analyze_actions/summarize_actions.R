# summarize range shift management actions in SWAPs and SFAPs 

library(tidyverse)

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
  map(read_csv) %>%
  bind_rows() %>% 
  left_join(regions) %>% 
  filter(element %in% "targeted_range_shift_actions")

action_evidence <- c('output/swap_run01/tables/evidence.csv', 'output/sfap_run01/tables/evidence.csv') %>% 
  map(read_csv) %>% 
  bind_rows() %>% 
  left_join(regions) %>% 
  filter(element %in% "targeted_range_shift_actions") %>% 
  select(doc_type, year, region, juris, quote)

# I am going to categorize these manually in a spreadsheet:
# write.csv(action_evidence, file = "analysis/analyze_actions/action_evidence.csv", row.names = FALSE)

# will work on summarizing and visualizing patterns tomorrow
library(readxl)
action_summary <- read_excel("analysis/analyze_actions/action_evidence_coded.xlsx") %>% 
  full_join(action_scores, relationship = "many-to-many")

# 1. overall frequency of different actions

# 2. variation across regions

# 3. variation between swap and sfap