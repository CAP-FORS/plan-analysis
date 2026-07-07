
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

