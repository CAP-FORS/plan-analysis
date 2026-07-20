
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

# load data -----------------------------

ds <- c("output/swap_run01/tables/scores_long.csv",
        "output/sfap_run01/tables/scores_long.csv") %>%
      map(read_csv) %>%
      bind_rows() %>%
      filter(doc_type %in% c("FAP", "SWAP"))

dc <- c("output/swap_run01/tables/checklists_long.csv",
        "output/sfap_run01/tables/checklists_long.csv") %>%
      map(read_csv) %>%
      bind_rows() %>%
      filter(doc_type %in% c("FAP", "SWAP"))


# plotting helpers ------------------------

stacked_bar <- function(x, outfile, vjust = 3){
      p <- x %>%
            ggplot(aes(doc_type, score, fill = element)) +
            geom_col(position = "stack") +
            geom_text(aes(label = element), position = "stack", vjust = vjust) +
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
            facet_wrap(~ doc_type, scales = "free_x")
      ggsave(outfile, p, height = 6, width = 6, units = "in")
}

choropleth <- function(x, outfile){
      
      library(rnaturalearth)
      library(sf)
      library(patchwork)
      
      north_america <- rnaturalearth::ne_countries(continent = "north america", scale = 50)
      
      states <- ne_states(country = "united states of america", returnclass = "sv") %>%
            st_as_sf() %>%
            mutate(juris = str_remove(iso_3166_2, "US-"))
      
      d <- x %>%
            left_join(states, .) %>%
            mutate(max_score = max(score),
                   min_score = min(score))
      
      make_map <- function(x, crs = 5070, xlim = NULL, ylim = NULL){
            # if(x$juris[1] == "HI") browser()
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
                  scale_fill_viridis_c(limits = c(x$min_score[1], x$max_score[1])) +
                  theme_minimal() +
                  theme(axis.text = element_blank(),
                        axis.ticks = element_blank(),
                        panel.border = element_rect(color = "black"))
      }
      
      conus <- d %>% filter(! juris %in% c("AK", "HI")) %>% make_map()
      
      ak <- d %>% filter(juris == "AK") %>% make_map(3338)
      
      hi <- d %>% filter(juris == "HI") %>% 
            make_map("ESRI:102007", xlim = c(-162, -154), ylim = c(18, 23))
      
      p <- conus + ak + hi +
            plot_layout(guides = "collect",
                        design = "AA
                        BC", 
                        heights = c(2, 1),
                        widths = c(1, .8))
      ggsave(outfile, p, height = 10.75, width = 12, units = "in")
}


# tools ----------------------------------

ds %>% 
      filter(theme == "tools") %>%
      group_by(doc_type, element) %>%
      summarize(score = mean(score)) %>%
      stacked_bar("analysis/figures/tools_by_doc_type.png")

ds %>% 
      filter(theme == "tools") %>%
      group_by(juris) %>%
      summarize(score = mean(score)) %>%
      choropleth("analysis/figures/tools_map.png")


# threats ------------------------

ds %>%
      filter(str_detect(element, "climate_threat")) %>%
      mutate(element = str_replace_all(str_remove(element, "climate_threat_"), "_", " ")) %>%
      group_by(doc_type, element) %>%
      summarize(score = mean(score)) %>%
      stacked_bar("analysis/figures/threats_by_doc_type.png")

ds %>%
      filter(str_detect(element, "climate_threat")) %>%
      mutate(element = str_replace_all(str_remove(element, "climate_threat_"), "_", " ")) %>%
      group_by(juris) %>%
      summarize(score = mean(score)) %>%
      choropleth("analysis/figures/threats_map.png")


# biological units ------------------------

dc %>%
      filter(checklist == "biological_unit_components") %>%
      mutate(element = category) %>%
      group_by(doc_type, element) %>%
      summarize(score = mean(present)) %>%
      stacked_bar("analysis/figures/bio_units_by_doc_type.png",
                  vjust = 1)

