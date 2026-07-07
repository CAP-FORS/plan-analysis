# ==== GROBID Docker launcher ====================================================
# Programmatically start (and optionally stop) the local GROBID service from R,
# so a pipeline run is self-contained. Mirrors the manual invocation:
#
#     docker run -t --rm -p 8070:8070 --memory=8g lfoppiano/grobid:0.8.1
#
# adapted for programmatic use: DETACHED (-d) so R gets control back, and NAMED
# so we can check "already running?" and reuse it. Same image, port, and memory
# limit, so the container is identical to the manual one (extraction output won't
# differ). The image tag is PINNED (0.8.1) — a GROBID version change would alter
# extraction, which for a reproducible dataset you want to avoid; record this tag
# in your methods alongside the model string.
#
# This module is OPTIONAL and standalone: pipeline.R does NOT source it, so the
# pipeline has no hard Docker dependency (you can still start GROBID manually and
# skip this). Source it explicitly when you want R to manage the container:
#
#     source("pipeline/grobid_docker.R")
#     ensure_grobid()        # start-if-not-running, wait until actually ready
#     log <- run_pipeline(config)
#     # (leave it running between runs; models take ~30-60s to load, so you do
#     #  NOT want to stop/start per run.)  stop_grobid() when you're fully done.

library(httr2)

.GROBID_IMAGE <- "lfoppiano/grobid:0.8.1"   # PINNED — matches manual invocation
.GROBID_NAME  <- "grobid"
.GROBID_PORT  <- 8070
.GROBID_MEM   <- "12g"   # raised from 8g: the SWAP corpus OOM'd some chunks at 8g
# (NC_SWAP code 139). Tune to your machine's available RAM;
# the per-chunk retry handles residual OOMs by splitting.

# Is the GROBID HTTP service actually answering? (Container "started" != "ready";
# GROBID loads models for ~30-60s before /api/isalive returns.)
grobid_is_alive <- function(port = .GROBID_PORT) {
      url <- sprintf("http://localhost:%d/api/isalive", port)
      tryCatch({
            resp <- request(url) |>
                  req_timeout(5) |>
                  req_error(is_error = function(r) FALSE) |>
                  req_perform()
            # /api/isalive returns the literal string "true" when ready.
            grepl("true", resp_body_string(resp), ignore.case = TRUE)
      }, error = function(e) FALSE)
}

# Does a container with our name exist (running OR stopped)?
.grobid_container_state <- function(name = .GROBID_NAME) {
      # Returns "running", "exited"/"created"/..., or "" if no such container.
      out <- tryCatch(
            system2("docker",
                    c("ps", "-a", "--filter", paste0("name=^", name, "$"),
                      "--format", "{{.State}}"),
                    stdout = TRUE, stderr = TRUE),
            error = function(e) character(0))
      if (length(out) == 0) "" else trimws(out[[1]])
}

# Start GROBID if it isn't already answering, then WAIT until it's ready.
# Idempotent: safe to call at the top of every run. Reuses an already-running
# container; starts a stopped one; runs a fresh one if none exists.
#
# NOTE on --rm: your manual command uses --rm (auto-remove on exit). We keep --rm
# here too, so there is never a stopped leftover to "start" — if the container is
# gone, we always `docker run` fresh. That means a cold start reloads models
# (~30-60s), which the readiness poll handles. If you'd rather persist the
# container across stops for faster restarts, set rm = FALSE (drops --rm and uses
# docker start on the stopped container).
ensure_grobid <- function(image = .GROBID_IMAGE, name = .GROBID_NAME,
                          port = .GROBID_PORT, memory = .GROBID_MEM,
                          wait_sec = 180, rm = TRUE) {
      if (grobid_is_alive(port)) {
            message("GROBID already up at :", port, ".")
            return(invisible(TRUE))
      }
      
      # Check for Docker itself, so the error is clear rather than a cryptic system2.
      if (nzchar(Sys.which("docker")) == FALSE) {
            stop("`docker` not found on PATH. Start GROBID manually, or install Docker.")
      }
      
      state <- .grobid_container_state(name)
      if (identical(state, "running")) {
            # Container running but not yet answering — just wait below.
            message("GROBID container running; waiting for the service to come up...")
      } else if (!rm && nzchar(state)) {
            # Persisted (non--rm) stopped container — start it.
            message("Starting existing GROBID container...")
            system2("docker", c("start", name), stdout = TRUE, stderr = TRUE)
      } else {
            # No usable container (or --rm mode) — run a fresh one, DETACHED.
            if (nzchar(state)) {
                  # An old container with this name is lingering (e.g. created but dead);
                  # remove it so `run --name` doesn't collide.
                  system2("docker", c("rm", "-f", name), stdout = TRUE, stderr = TRUE)
            }
            message("Launching GROBID (", image, ", ", memory, " RAM) on :", port, " ...")
            args <- c("run", "-d",                       # -d: detached (was -t manual)
                      if (rm) "--rm" else NULL,
                      "--name", name,
                      "-p", paste0(port, ":", port),
                      paste0("--memory=", memory),
                      image)
            run_out <- system2("docker", args, stdout = TRUE, stderr = TRUE)
            if (!is.null(attr(run_out, "status")) && attr(run_out, "status") != 0) {
                  stop("docker run failed: ", paste(run_out, collapse = " "))
            }
      }
      
      # Poll until the service actually answers (models load slowly on cold start).
      message("Waiting for GROBID to load models (up to ", wait_sec, "s)...")
      t0 <- Sys.time()
      repeat {
            if (grobid_is_alive(port)) {
                  el <- round(as.numeric(difftime(Sys.time(), t0, units = "secs")))
                  message("GROBID ready after ~", el, "s.")
                  return(invisible(TRUE))
            }
            if (as.numeric(difftime(Sys.time(), t0, units = "secs")) > wait_sec) {
                  stop("GROBID did not become ready within ", wait_sec,
                       "s. Check `docker logs ", name, "`.")
            }
            Sys.sleep(3)
      }
}

# Stop GROBID (only when you're fully done — NOT between runs, or you pay the
# model-load cost every time). With --rm the container is removed on stop.
stop_grobid <- function(name = .GROBID_NAME) {
      if (nzchar(Sys.which("docker")) == FALSE) return(invisible(FALSE))
      message("Stopping GROBID container '", name, "'...")
      system2("docker", c("stop", name), stdout = TRUE, stderr = TRUE)
      invisible(TRUE)
}