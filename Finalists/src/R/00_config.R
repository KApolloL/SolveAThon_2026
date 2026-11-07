# 00_config.R: every path, threshold and default lives here. Sourced first by every
# script and by the notebook. Tool defaults are exported into payload.json, so the
# JavaScript never holds its own copy of a number.
#
# Run every script from Finalists/src (here() finds the project through Finalists.Rproj).

suppressPackageStartupMessages(library(here))

# UTF-8 everywhere: text is hashed for the LLM cache, so a locale that mangles
# characters would silently change cache keys between machines.
invisible(Sys.setlocale("LC_CTYPE", "en_US.UTF-8"))

# =============================================================================
# FILL IN AT RELEASE
# =============================================================================
PROJECT_TITLE <- "Finals project (rename at release)"
PROJECT_SUB   <- "Solve-A-Thon 2026 Final Quest"

ID_COL     <- "id"                                   # unique key of one item
NAME_COL   <- "name"                                 # what the user sees as the item's name
SHOW_FIELDS <- c("agency", "close_date", "award_usd") # extra columns shown next to each result

REF_DATE   <- as.Date("2026-11-06")  # "today" for deadline rules, so reruns are reproducible
TOP_N      <- 20L                    # how many ranked results the outputs keep

# =============================================================================
# Paths
# =============================================================================
DIR_RAW       <- here("data", "raw")        # never modified
DIR_MANUAL    <- here("data", "manual")     # hand-authored tables (criteria, test cases, facts)
DIR_PROCESSED <- here("data", "processed")
DIR_EXAMPLE   <- here("data", "example")    # toy data so the pipeline runs before the real data exists
DIR_CACHE_API <- here("data", "cache", "api")
DIR_CACHE_LLM <- here("data", "cache", "llm")
DIR_OUTS      <- here("outs")
DIR_FIGS      <- here("outs", "figures")

# Real files win; the toy example is used only when the real one does not exist yet.
USING_EXAMPLE <- FALSE
pick_file <- function(real, example) {
  if (file.exists(real)) return(real)
  USING_EXAMPLE <<- TRUE
  message("NOTE: using TOY EXAMPLE data (", basename(example), "). Real file expected at ",
          sub(paste0(here(), "/"), "", real, fixed = TRUE))
  example
}
ITEMS_FILE      <- pick_file(file.path(DIR_PROCESSED, "items.csv"),      file.path(DIR_EXAMPLE, "items_example.csv"))
CRITERIA_FILE   <- pick_file(file.path(DIR_MANUAL, "criteria.csv"),      file.path(DIR_EXAMPLE, "criteria_example.csv"))
TEST_CASES_FILE <- pick_file(file.path(DIR_MANUAL, "test_cases.csv"),    file.path(DIR_EXAMPLE, "test_cases_example.csv"))
FACTS_FILE      <- pick_file(file.path(DIR_MANUAL, "facts.csv"),         file.path(DIR_EXAMPLE, "facts_example.csv"))

PAYLOAD_JSON <- file.path(DIR_PROCESSED, "payload.json")
RANKING_CSV  <- file.path(DIR_PROCESSED, "ranking.csv")
TOOL_HTML_OUT <- file.path(DIR_OUTS, "criteria_tool.html")
TOOL_MAX_BYTES <- 25 * 1024^2

# =============================================================================
# Opportunity sources (data setup). Keys are read from .Renviron only, never written here.
# =============================================================================
DIR_CACHE_GRANTS   <- here("data", "cache", "api", "grantsgov")
DIR_CACHE_EXTRACT  <- here("data", "cache", "api", "grantsgov_extract")
CLOSED_SINCE       <- as.Date("2024-11-06")   # keep closed/archived items closing on or after this
USA_FY             <- 2022:2026               # USAspending fiscal years for the "won before" signal
API_SLEEP_SEC      <- 0.4                     # politeness delay before each uncached call
GRANTSGOV_API_BASE <- "https://api.grants.gov/v1/api"
GRANTSGOV_EXTRACT_PAGE <- "https://www.grants.gov/xml-extract"   # confirm the live file URL here
USASPENDING_BASE   <- "https://api.usaspending.gov/api/v2"
FR_API_BASE        <- "https://www.federalregister.gov/api/v1"
SIMPLER_BASE       <- "https://api.simpler.grants.gov"      # key: SIMPLER_GRANTS_KEY
SAM_AL_BASE        <- "https://api.sam.gov/assistance-listings/v1"  # key: SAM_API_KEY
USDOT_GRANTS_URL   <- "https://www.transportation.gov/grants"        # [uncertain] verify page before scraping

# =============================================================================
# Tool controls
# =============================================================================
WEIGHT_RANGE <- c(0, 3)
WEIGHT_STEP  <- 0.5

# =============================================================================
# Local LLM (Ollama). Only used for text labeling; it never ranks or decides.
# =============================================================================
OLLAMA_URL         <- "http://localhost:11434"
LLM_MODEL          <- "qwen2.5:14b"   # same model as the qualifier; check `ollama list` on each laptop
LLM_PROMPT_VERSION <- "v1"            # bump to invalidate cached labels after changing a prompt
LLM_SEED           <- 42L
LLM_TIMEOUT_SEC    <- 180
