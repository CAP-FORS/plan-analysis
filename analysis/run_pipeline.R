

source("pipeline/pipeline.R")

# config$model_claude <- "claude-sonnet-4-6"
# config$timeout_sec <- 1200



# SWAP -----------------------------------------

config <- make_config(source_dir = "documents/swap_latest", 
                      out_dir = "output/swap_run01")

extract(config)
code(config)
finalize(config)
verify(config)
tabulate(config)



# SFAP -----------------------------------------

config <- make_config(source_dir = "documents/sfap_latest", 
                      out_dir = "output/sfap_run01")

extract(config)
code(config)
finalize(config)
verify(config)
tabulate(config)


