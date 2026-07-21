
library(tidyverse)


# scores ==========================

d <- c("output/swap_run01/tables/scores_long.csv",
       "output/sfap_run01/tables/scores_long.csv") %>%
  map(read_csv) %>%
  bind_rows()


## frequency ------------------

p <- d %>%
  group_by(theme, element) %>%
  summarize(sum = sum(score)) %>%
  ggplot(aes(element, sum, fill = theme)) +
  facet_grid(theme ~ ., scales = "free", space = "free") +
  geom_col() +
  coord_flip() +
  labs(y = "sum of scores across docs") +
  theme(legend.position = "none")

ggsave("analysis/figures/score_bars.png", p, width = 7, height = 10, units = "in")


## heatmap -------------------

p <- ggplot(d, aes(element, doc_id, fill = score)) +
  facet_grid(. ~ theme, scales = "free", space = "free") +
  geom_tile() +
  scale_fill_viridis_c() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("analysis/figures/score_heatmap.png", p, width = 7, height = 10, units = "in")


## ordination -------------------

d_ord <- d %>%
  select(doc_id, element, score) %>%
  pivot_wider(names_from = element, values_from = score)
ord <- d_ord %>% column_to_rownames("doc_id") %>% vegan::metaMDS(distance = "euclidean")

ord_docs <- ord$points %>% 
  as.data.frame() %>% 
  rownames_to_column("doc_id") %>%
  left_join(distinct(select(d, doc_id, doc_type)))

ord_elements <- ord$species %>% 
  as.data.frame() %>% 
  rownames_to_column("element") %>%
  left_join(distinct(select(d, element, theme)))

p <- ggplot(mapping = ) +
  geom_point(data = ord_docs,
             aes(MDS1, MDS2, shape = doc_type)) +
  geom_segment(data = ord_elements, 
               aes(MDS1/2, MDS2/2,
                   xend = 0, yend = 0, color = theme)) +
  geom_text(data = ord_elements, 
            aes(MDS1/2, MDS2/2,
                angle = atan2(MDS2, MDS1) * 180 / pi,
                color = theme, label = element),
            hjust = 0) +
  coord_fixed(clip = "off")

ggsave("analysis/figures/score_ordination.png", p, width = 10, height = 7, units = "in")



# checklists ==========================

d <- c("output/swap_run01/tables/checklists_long.csv",
       "output/sfap_run01/tables/checklists_long.csv") %>%
  map(read_csv) %>%
  bind_rows()


## frequency ------------------

p <- d %>%
  group_by(theme, checklist, category) %>%
  summarize(sum = sum(present)) %>%
  ggplot(aes(category, sum, fill = checklist)) +
  facet_grid(theme + checklist ~ ., scales = "free", space = "free") +
  geom_col() +
  coord_flip() +
  labs(y = "presence frequency across docs") +
  theme(legend.position = "none")

ggsave("analysis/figures/checklist_bars.png", p, width = 7, height = 10, units = "in")


## heatmap -------------------

p <- ggplot(d, aes(category, doc_id, fill = present)) +
  facet_grid(. ~ theme + checklist, 
             scales = "free", space = "free") +
  geom_tile() +
  scale_fill_viridis_c() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("analysis/figures/checklist_heatmap.png", p, width = 7, height = 10, units = "in")




# figures for ESA poster ========================

## load data -----------------------------

ds <- c("output/swap_run01/tables/scores_long.csv",
        "output/sfap_run01/tables/scores_long.csv") %>%
  map(read_csv) %>%
  bind_rows() %>%
  filter(doc_type %in% c("FAP", "SWAP")) %>%
  mutate(juris = ifelse(juris == "VI", "USVI", juris)) %>%
  group_by(juris) %>%
  mutate(jurisdiction = jurisdiction[1])

dc <- c("output/swap_run01/tables/checklists_long.csv",
        "output/sfap_run01/tables/checklists_long.csv") %>%
  map(read_csv) %>%
  bind_rows() %>%
  filter(doc_type %in% c("FAP", "SWAP")) %>%
  
  mutate(juris = ifelse(juris == "VI", "USVI", juris)) %>%
  group_by(juris) %>%
  mutate(jurisdiction = jurisdiction[1])


## plotting helpers ------------------------

stacked_bar <- function(x, outfile, vjust = 2, save = FALSE, checklist = FALSE, show_labels = TRUE){
  
  p <- x %>%
    ggplot(aes(doc_type, score, fill = if(!checklist) element else category)) +
    geom_col(position = "stack", color = "white", width = 1) +
    {if(show_labels) geom_text(aes(label = if(!checklist) element else category), position = "stack", vjust = vjust, size = 7)}+ 
    theme_minimal() +
    labs(x = "", y = ylab)+
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
    facet_wrap(~ doc_type, scales = "free_x")
  if(save) ggsave(outfile, p, height = 7, width = 6, units = "in") else p
}

grouped_bar <- function(x, outfile, vjust = 2, save = FALSE, checklist = FALSE, palette = c("lightblue", "darkblue"), y_axis_labs = c("Not Referenced", "Referenced", "Applied"), y_axis_breaks = c(0, 1, 2), ylab = "", ylim = c(0,2)){
  
  p <- x %>%
    ggplot(aes(y = score, x = if(!checklist) element else category,  fill = doc_type)) +
    geom_col(position = "dodge", stat = 'identity', color = "white", width = 0.75) +
    theme_minimal() +
    labs(x = "", y = ylab)+
    scale_fill_manual(values = palette, name = "")+
    scale_y_continuous(
      breaks = y_axis_breaks,
      labels = y_axis_labs,
      limits = ylim
    ) +
    theme(
      axis.text.x = element_text(size = 22, color = 'black'),
      axis.text.y = element_text(size = 20, color = 'black'),
      axis.ticks.y = element_line(),
      panel.grid.minor = element_blank(),
      legend.box = "horizontal",
      legend.position = "bottom",
      legend.text = element_text(size = 20),
      legend.title = element_text(size = 22),
    )   
  if(save) ggsave(outfile, p, height = 7, width = 8, units = "in") else p
}

choropleth <- function(x, outfile, title){
  
  library(rnaturalearth)
  library(sf)
  library(patchwork)
  
  north_america <- rnaturalearth::ne_countries(continent = "north america", scale = 50)
  
  states <- ne_states(country = "united states of america", returnclass = "sv") %>%
    st_as_sf() %>%
    mutate(juris = str_remove(iso_3166_2, "US-"))
  
  d <- left_join(states, x)
  minmax <- range(x$score)
  
  make_map <- function(x, crs = 5070, xlim = NULL, ylim = NULL){
    
    if(!is.null(xlim) & !is.null(ylim)){
      x <- st_crop(x, st_bbox(c(xmin = xlim[1], xmax = xlim[2], 
                                ymax = ylim[1], ymin = ylim[2]), crs = st_crs(4326)))
    }
    
    x <- st_transform(x, st_crs(crs))
    na <- st_transform(north_america, st_crs(crs))
    bbox <- st_bbox(x)
    
    ggplot() +
      geom_sf(data = na, fill = "gray") +
      geom_sf(data = x, aes(fill = score)) +
      coord_sf(crs = st_crs(crs), 
               xlim = st_bbox(x)[c(1, 3)], 
               ylim = st_bbox(x)[c(2, 4)]) +
      scale_fill_viridis_c(limits = minmax) +
      theme_minimal(base_size = 24) +
      theme(axis.text = element_blank(),
            axis.ticks = element_blank(),
            panel.border = element_rect(color = "black"))
  }
  
  conus <- d %>% filter(! juris %in% c("AK", "HI")) %>% make_map()
  
  ak <- d %>% filter(juris == "AK") %>% make_map(3338)
  
  hi <- d %>% filter(juris == "HI") %>% 
    make_map("ESRI:102007", xlim = c(-162, -154), ylim = c(18, 23))
  
  others <- x %>%
    anti_join(states) %>%
    mutate(jurisdiction = str_remove(jurisdiction, " \\(.*")) %>%
    ggplot(aes(1, jurisdiction, fill = score)) +
    geom_tile(color = "white", linewidth = 2, size = 2) +
    geom_text(aes(2, jurisdiction, label = jurisdiction), hjust = 0, size = 11, size.unit = 'pt') +
    coord_fixed() +
    xlim(NA, 25) +
    scale_fill_viridis_c(limits = minmax) +
    theme_void() +
    theme(legend.position = "none")
  
  p <- conus + ak + hi + others +
    plot_layout(guides = "collect",
                design = "AAA
                        BCD", 
                heights = c(2, .5),
                widths = c(1, .75, 1.25)) +
    plot_annotation(theme = theme(legend.position = "top")) &
    labs(fill = title) &
    guides(fill = guide_colorbar(barwidth = 15)) &
    theme(legend.direction = "horizontal",
          legend.title = element_text(size = 18))
  ggsave(outfile, p, height = 9, width = 10, units = "in")
}


## tools ----------------------------------

ds %>% 
  filter(theme == "tools") %>%
  group_by(doc_type, element) %>%
  summarize(score = mean(score)) %>%
  mutate(element = case_when(element == "climate_models" ~ "Climate",
                             element == "connectivity_models" ~ "Connectivity",
                             element == "niche_models" ~ "Niche",
                             element == "vulnerability_models" ~ "Vulnerability",
                             .default = element)) %>% 
  stacked_bar("analysis/figures/tools_by_doc_type.png", vjust = 2, save = TRUE)

ds %>% 
  filter(theme == "tools") %>%
  group_by(doc_type, element) %>%
  summarize(score = mean(score)) %>%
  mutate(element = case_when(element == "climate_models" ~ "Climate\nModels",
                             element == "connectivity_models" ~ "Connectivity\nModels",
                             element == "niche_models" ~ "Niche\nModels",
                             element == "vulnerability_models" ~ "Vulnerability\nAssessment",
                             .default = element)) %>% 
  grouped_bar("analysis/figures/tools_by_doc_type_grouped.png", palette = c("#BFDBFE", "#1D4ED8"), save = TRUE)


ds %>% 
  filter(theme == "tools") %>%
  group_by(juris, jurisdiction) %>%
  summarize(score = mean(score)) %>%
  choropleth("analysis/figures/tools_map.png",
             "Diversity of tools referenced  ")


## threats ------------------------

ds %>%
  filter(str_detect(element, "climate_threat")) %>%
  mutate(element = str_replace_all(str_remove(element, "climate_threat_"), "_", " ")) %>%
  group_by(doc_type, element) %>%
  summarize(score = mean(score)) %>%
  mutate(element = case_when(element == "biotic stressors" ~ "Biotic Stressor",
                             element == "habitat degradation" ~ "Habitat Threat",
                             element == "species vital rates" ~ "Direct Threat",
                             .default = element),
         element = fct_relevel(element, c("Direct Threat", "Habitat Threat", "Biotic Stressor"))) %>% 
  stacked_bar("analysis/figures/threats_by_doc_type.png", save = TRUE)

ds %>%
  filter(str_detect(element, "climate_threat")) %>%
  mutate(element = str_replace_all(str_remove(element, "climate_threat_"), "_", " ")) %>%
  group_by(juris, jurisdiction) %>%
  summarize(score = mean(score)) %>%
  choropleth("analysis/figures/threats_map.png",
             "Diversity of climate impacts described  ")


## biological units ------------------------

dc %>%
  filter(checklist == "biological_unit_components") %>%
  mutate(element = category) %>%
  group_by(doc_type, element) %>%
  summarize(score = mean(present)) %>%
  stacked_bar("analysis/figures/bio_units_by_doc_type.png",
              vjust = 1)

## composite score -------------------------

ds <- ds %>% 
  mutate(doc_type = case_when(doc_type == "Forest Plan" ~ "FAP",
                              doc_type == "Wildlife Plan" ~ "SWAP"))
dc <- dc %>% 
  mutate(doc_type = case_when(doc_type == "Forest Plan" ~ "FAP",
                              doc_type == "Wildlife Plan" ~ "SWAP"))

source("analysis/composite_score.R")

scores_long <- c("output/swap_run01/tables/scores_long.csv",
                 "output/sfap_run01/tables/scores_long.csv") %>%
  map(read_csv) %>%
  bind_rows() %>%
  filter(doc_type %in% c("FAP", "SWAP")) 

checklists_long <- c("output/swap_run01/tables/checklists_long.csv",
                     "output/sfap_run01/tables/checklists_long.csv") %>%
  map(read_csv) %>%
  bind_rows() %>%
  filter(doc_type %in% c("FAP", "SWAP"))


comp <- compute_composite(ds, dc, null_as = "drop") %>%
  left_join(distinct(select(ds, doc_id, juris, jurisdiction, doc_type)))

comp %>%
  filter(doc_type == "SWAP") %>%
  mutate(score = composite) %>%
  choropleth("analysis/figures/swap_composite_map.png",
             "SWAP Range Shift Science Engagement Score  ")

comp %>%
  filter(doc_type == "FAP") %>%
  mutate(score = composite) %>%
  choropleth("analysis/figures/sfap_composite_map.png",
             "SFAP Range Shift Science Engagement Score  ")


comp %>%
  select(juris, doc_type, score = composite) %>%
  pivot_wider(names_from = "doc_type", values_from = "score") %>%
  ggplot(aes(SWAP, FAP)) +
  geom_point()


## SWAP vs SFAP scatterplot
(p <- comp %>%
  select(theme_actions:composite, juris, doc_type) %>%
  pivot_longer(theme_actions:composite, names_to = "theme", values_to = "score") %>%
  pivot_wider(names_from = "doc_type", values_from = "score") %>%
  mutate(theme = ifelse(theme == "composite", "COMBINED", 
                        str_remove(theme, "theme_")),
         theme = stringr::str_to_sentence(theme),
         theme = factor(theme, levels = c("Actions", "Concepts", "Context", "Tools", "Combined"))) %>%
  ggplot(aes(`Wildlife Plan`, `Forest Plan`, color = theme, fill = theme)) +
  geom_point() +
  geom_smooth(method = lm, alpha = .1) +
  coord_fixed() +
  theme_bw(base_size = 24) +
  labs(x = "Wildlife Plan (SWAP)\nRange Shift Science Engagement",
       y = "Forest Plan (SFAP)\nRange Shift Science Engagement",
       color = NULL, fill = NULL))
ggsave("analysis/figures/swap_vs_sfap_composite.png", 
       p, width = 10, height = 8.5, units = "in")
