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
PROJECT_TITLE <- "Federal Funds Matchmaker"
PROJECT_SUB   <- "Solve-A-Thon 2026 Final Quest"

ID_COL     <- "id"                                   # unique key of one item
NAME_COL   <- "title"                                # what the user sees as the item's name
SHOW_FIELDS <- c("agency_id", "close_date", "award_ceiling") # extra columns shown next to each result

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

# Pipeline scripts call this first with the input files they read: a real run must never
# rank toy data by accident. Tests and the notebook may still run on the toy files.
stop_if_toy <- function(...) {
  files <- c(...)
  toy <- if (length(files)) any(startsWith(normalizePath(files, mustWork = FALSE), normalizePath(DIR_EXAMPLE, mustWork = FALSE))) else USING_EXAMPLE
  if (toy) stop("Real input missing, refusing to run on TOY example data. See the NOTE lines above.", call. = FALSE)
}

OPPS_FILE       <- file.path(DIR_PROCESSED, "opportunities.csv")
AGENCY_MAP_FILE <- file.path(DIR_MANUAL, "agency_map.csv")
GOALS_FILE      <- here("src", "docs", "agency_goal_summaries.csv")
BACKTEST_CSV    <- file.path(DIR_PROCESSED, "rankings_backtest.csv")
OPEN_STATUSES   <- c("posted", "forecasted", "notice")   # rows in payload.json; closed go to the backtest
FAR_FUTURE_DATE <- as.Date("2030-01-01")   # close dates on or after this read "rolling or no date listed" (decision 8)

# Eligibility (steps 1 and 2). Applicant-type codes checked against single-code rows in
# opportunities.csv: 00 state governments, 06 public higher ed, 25 other (see text), 99 unrestricted.
# Codes 01, 02, 04, 11 and 22 never appear alone in the data [uncertain]; they count as not state-eligible.
ELIG_YES_CODES  <- c("00", "99")              # a state agency can apply
ELIG_ASK_CODES  <- "25"                       # "other": read the text rules, else ask; never hidden
ELIG_HIGHER_ED_CODE   <- "06"                 # public higher ed: eligible only for the agencies below
ELIG_HIGHER_ED_AGENCIES <- c("unc", "ncccs")  # [assumed] the only agencies that are public higher ed
ELIG_TEXT_NO  <- c("state governments are not eligible", "state agencies are not eligible",
                   "applications from federal, state, or tribal governments will not be considered",
                   "tribal governments only", "federally recognized tribes only", "individuals only")
ELIG_TEXT_YES <- c("state governments", "state government agencies", "state agencies", "agencies of state")
ELIG_TEXT_NEGATION <- "(not|ineligible|exclud|except)[^.]{0,80}state (government|agenc)"

# Geography: fit is multiplied by GEO_PENALTY when the opportunity TITLE names another US state or
# region and does not name North Carolina. Titles only: summaries list many states in passing.
# 0.5 confirmed by Kent in person (Nov 7); a team judgment, not derived. The item is demoted, never hidden.
GEO_PENALTY <- 0.5
GEO_OTHER_PLACES <- c("Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida",
  "Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts",
  "Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico",
  "New York","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota",
  "Tennessee","Texas","Utah","Vermont","Virginia","Wisconsin","Wyoming","Great Lakes","Pacific Northwest","Northern Forest",
  "Californian","Seattle","Denver","Austin","Chicago","Philadelphia","Gulf of Mexico","Gulf of America","Puerto Rico","Guam","Chesapeake")

# Program map: a hand table (data/manual/program_map.csv) naming Assistance Listing numbers that belong to an
# agency regardless of keywords. A mapped pair gets fit of at least MAP_FIT_FLOOR (0.8, confirmed by Kent in person Nov 7; a team judgment) and a note saying why.
# It never overrides the eligibility filter.
PROGRAM_MAP_FILE <- file.path(DIR_MANUAL, "program_map.csv")
MAP_FIT_FLOOR    <- 0.8

PAYLOAD_AS_OF   <- "2026-11-07T11:00:00-05:00"   # stamped into payload.json; fixed so reruns are identical
TOP10_N         <- 10L    # open items flagged per agency (Top 10 list)
COMING_UP_N     <- 10L    # forecasted items kept per agency ("Coming up")
HIDDEN_N        <- 10L    # best-fitting clearly-ineligible items kept per agency so the tool can show the toggle
BACKTEST_TOP_N  <- 50L    # ranked items written per agency and window in rankings_backtest.csv
SNIPPET_CHARS   <- 240L   # opp_snippet length
CLOSING_SOON_DAYS <- 14L  # [assumed] a Top 10 row with this many days left or fewer counts as closing soon

PAYLOAD_JSON <- file.path(DIR_PROCESSED, "payload.json")
COUNTY_NEED_FILE   <- file.path(DIR_PROCESSED, "county_need.csv")      # from 05a (qualifier caches)
COUNTY_SHAPES_FILE <- file.path(DIR_PROCESSED, "county_shapes.csv")    # from 05c (qualifier tigris cache)
CAPABILITIES_FILE  <- here("..", "QualifierChallenge", "data", "manual", "agency_capabilities.csv")  # hand-built in the qualifier; DHHS and DMVA only
CAPABILITY_AGENCY_IDS <- c(DHHS = "dhhs", DMVA = "dmva")
RANKING_CSV  <- file.path(DIR_PROCESSED, "ranking.csv")
TOOL_HTML_OUT <- file.path(DIR_OUTS, "criteria_tool.html")
TOOL_MAX_BYTES <- 25 * 1024^2

# =============================================================================
# Opportunity sources (data setup). Keys are read from .Renviron only, never written here.
# =============================================================================
# Team keys live in api_keys.env at the project root (private repo, Kent's decision). Loaded here
# so every script sees SIMPLER_GRANTS_KEY and SAM_API_KEY through Sys.getenv().
if (file.exists(here("api_keys.env"))) readRenviron(here("api_keys.env"))
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
# Evaluation, refresh and feedback (plan review amendments, planning/08_product_decisions.md)
# =============================================================================
FLAG_TOP_N          <- 10L               # flagged items per agency per window (amendment D)
WINDOW_WEEKS        <- c(2L, 4L, 6L)     # backtest windows for the recall curve (amendment E)
WINDOW_DEFAULT_WEEKS <- 2L               # UI default and headline window
IN_TIME_DAYS        <- 21L               # catch counts as in time if this many days remain (team assumption, amendment F)
POOL_PER_AGENCY     <- 20L               # hand-labelled pool size per agency
POOL_SEED           <- 20261106L         # fixed seed for the pool draw (amendment C)
POOL_CATEGORY_SHARE <- 0.5               # share drawn from the agency's matching Grants.gov category
MODEL_LABEL_MIN_CATCH <- 0.80            # model must catch this share of hand "relevant" items (amendment B)
MODEL_LABEL_MIN_KAPPA <- 0.60            # and reach this kappa on relevant vs not relevant
ROCCHIO_GOOD_WEIGHT <- 0.25              # feedback: weight of "good" items added to the profile (amendment I)
ROCCHIO_BAD_WEIGHT  <- 0.10              # feedback: weight of "bad" items subtracted [assumed, untested]

# Held-out label check (Noah, 40_label_check.R). Draw rule and word list are judgment calls.
HOLDOUT_AGENCIES <- c("Department of Justice", "Department of Agriculture and Consumer Services",
                      "Department of Labor")   # model-labelled, not in the validate set
N_TOP <- 5
N_RANDOM <- 5
HOLDOUT_SEED <- 2026
POOL_STATUSES <- c("posted", "forecasted", "notice")
SUMMARY_CHARS <- 500
# Words too common in plans and notices to count as a match (short list; a judgment call)
GENERIC_WORDS <- c("north","carolina","state","states","department","program","programs","public",
  "service","services","improve","ensure","support","strengthen","across","throughout","advance",
  "expand","enhance","leading","excellence","operations","efficiency","collaboration","customer",
  "community","communities","local","provide","work","using","goals","every","people","system",
  "systems","national","federal","future","serve","working","fully","change","grant","grants",
  "funding","award","awards","project","projects","applicants","application","information",
  "development","management","include","includes","including","based","their","which","through")

# County need (Noah, 05a_county_need.R; copied from QualifierChallenge/src/R/00_config.R)
OVERDOSE_YEARS <- 2019:2021   # NCHS model-based drug poisoning death rates, averaged
HPSA_AREA_TYPES <- c("Hpsa Geo", "Hpsa Geo HN", "Hpsa Pop")   # area designations only, not facilities

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
