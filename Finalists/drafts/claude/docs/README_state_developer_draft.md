# Federal Funds Matchmaker: guide for a state developer (DRAFT)

> **DRAFT, refreshed Sat Nov 7, 12:2x (Noah's Claude).** Sections 1, 4, 5 and 11 were rewritten against the repo on main at that time. Commands in sections 4 and 11 were run on a fresh worktree (offline, from cache) and the results are stated there. Sections 2, 3 and 6 to 10 are still the Friday-night text and may be out of date; they are marked where I know. It is meant to replace `Finalists/README.md` after Kent edits it. Anything not built is tagged **[PLANNED, not built]**; anything not run is tagged **[not run]**.

Team: Kent Lee, Everett Foo, Marco Gullotto, Matthew Martin, Noah Goldblatt. Built for the Solve-A-Thon 2026 Final Quest, sponsor NC OSBM. Organizer text: `docs/QUEST_BRIEF.md`.

## 1. What it does and does not do today

**Does today** (each line checked in the repo or by running it, Sat Nov 7)
- **Loads open federal opportunities** from public sources into one table (`data/processed/opportunities.csv`): Grants.gov, Simpler.Grants.gov, Federal Register notices and USAspending past awards. 1,576 of them are open (posted, forecasted or notice) and get ranked (fact sheet row 3).
- **Builds a profile for each agency** from its strategic plan text and goal table (`src/docs/agency_goal_summaries.csv`). The tool ranks for 32 agencies (fact sheet row 2).
- **Scores and ranks** every agency by opportunity pair (50,432 pairs; 4,758 hidden by the filters; fact sheet rows 4 and 7). Reproduced by `Rscript R/10_run_ranking.R` on Nov 7: 32 agencies, 50,432 pairs, 3,030 dropped (4,758 after the overseas-embassy filter added later that evening). Ranking is keyword fit between the opportunity and the agency's plan goals, with eligibility rules (`src/R/helpers_rank.R`, criteria in `data/manual/criteria.csv`). No AI model decides a rank.
- **Shows a per-agency list** in a single static page, `src/tool/matchmaker.html`, reading `data/processed/payload.json` (960 rows: a Top 10, a Coming up list and hidden examples per agency). Each row shows days left, eligibility (Yes, No or Ask), the plan goal it matched with a snippet, a Pursue, Maybe or Pass mark saved in the browser, and a CSV export. Also a closing-soon view, a match board, a county map tab and a capability table (from the qualifier data). Run in a browser on Nov 7: picker, Top 10, Pursue and CSV export work.
- **Serves it on Azure.** `app/app.R` (R Shiny in a container) serves `matchmaker.html` at `/`, the qualifier grant-triage tool at `/tool.html`, and `payload.json` from Blob Storage at `/payload.json`. A daily job script exists (`app/job.R`, `src/R/13_daily_refresh.R`); see `src/docs/daily_job.md`.
- **Backtests itself** against past awards (`src/R/20_backtest_awards.R`): see section 9 for the result.

**Does not do today**
- **It does not pass its own backtest.** On 4-week windows only 1 of 3 agencies reached the 50% bar the team set beforehand, and a soonest-deadline baseline beat the ranking in all 3 (fact sheet rows 15 and 16).
- **No AI model is in the ranking path.** Model labels exist for a few agencies (Noah's local run) but failed their agreement check and are not used in the tool.
- **The daily job re-scores cached data only.** It does not fetch new postings (`src/R/13_daily_refresh.R` header). `JOB_DRY_RUN` defaults to 1, which checks and stamps but writes nothing to Blob (`app/job.R`).
- **SAM.gov postings and the USDOT page are not loaded.** The SAM Assistance Listings catalog (2,875 listings, 2,672 with a statutory authority) is built from GSA's public bulk file by `src/R/05b_sam_listings.R` into `data/processed/sam_listings.csv`; nothing in the ranking reads it yet.
- **No user accounts, no shared decisions.** Pursue, Maybe and Pass marks live in each browser only.
- **No evaluation with real agency staff.** Our user feedback so far is from the organizers' discovery session and simulated reviewers, which are not user evidence.

A person makes every decision. The system is meant to support a grants lead, not replace them (`docs/QUEST_BRIEF.md`).

## 2. Architecture

**Live today.** Data scripts in R pull public sources into CSV files under `data/processed/`. One container image holds an R Shiny app and a small entrypoint script. The entrypoint reads the `MODE` environment variable. `MODE=app` starts the web page on port 3838. `MODE=job` is meant to run a daily refresh but is a stub. The image is built in Azure Container Registry with `az acr build` and runs as one Azure Container App (0.5 vCPU, 1 Gi, 0 to 1 replicas) with a system-assigned identity that pulls from the registry. A Blob container `ffm-data` exists but the app does not use it. Source: `src/docs/azure_setup.md`. The design follows the organizers' Starter Kit (`src/docs/organizer_materials_notes.md`, section 1).

**[Update Sat Nov 7: the scoring pipeline and the static page below are now built; see section 1. The text in this section is the Friday plan and is kept for the design reasoning.] Planned (decision 6, Kent, `planning/08_product_decisions.md`).** An R pipeline scores every opportunity against every agency and writes `payload.json`. Azure OpenAI makes embeddings (one score per opportunity and agency pair, cached) and short reasons with quotes for flagged or shown pairs only. A script checks each quote appears in its source. Blob Storage holds the payload and the cache. The qualifier's JavaScript tool (`../QualifierChallenge/src/tool/`) reads the payload in the browser and shows an agency picker, sliders and a per-item breakdown. Container Apps hosts it. Rules decide the flag and the score only orders. The model never decides. None of this exists yet: there is no Azure OpenAI resource, no payload, no `data/manual/criteria.csv`.

**Fallback.** If the planned flow is not ready at the code freeze, the R Shiny page above stays as the deployed product (decision 6). Fields-only signature tiers ship if the labeling pass is untested (decision 13).

## 3. Repo map

All paths are under `Finalists/`. The git root is one level up.

| Path | What it is |
|---|---|
| `app/` | The deployed Shiny app: `app.R`, `Dockerfile`, `entrypoint.sh`, `stage_proof_assets.sh`, `.dockerignore`, `.gitignore`. `app/data/` and `app/www/` are copies made by the stage script and are not tracked by git (`app/.gitignore` ignores `data/`) |
| `src/R/` | Numbered R pipeline. `00_config.R` holds paths, reference date and key loading. `02a` to `02e` pull sources. `03_merge_opportunities.R` builds `opportunities.csv`. `04_plan_text_extract.R` extracts plan text. `10_run_ranking.R`, `score.R` and `01_profile.R` are the older scoring skeleton, not yet fed real criteria |
| `src/tests/` | `run_tests.R` (runner), `test_ingest.R`, `test_plan_tables.R`, `agreement.R` |
| `src/tool/`, `src/report.qmd` | Criteria weights tool source and report template from the qualifier skeleton |
| `src/docs/` | `azure_setup.md` (Azure state and commands), `organizer_materials_notes.md`, `fact_sheet.md`, plan tables, `qa_cheatsheet.md` |
| `data/raw/` | Untouched inputs: organizer files and 34 plan PDFs. Do not modify |
| `data/cache/` | Saved API responses and OCR text, so reruns do not re-query |
| `data/processed/` | Pipeline outputs, including `opportunities.csv` and `agency_plan_text/` |
| `data/manual/` | Hand-authored tables. **Empty today** |
| `planning/` | Framing worksheet, discovery findings, plans |
| `docs/` | Team docs and the organizer brief |
| `handoff.md`, `AI_USAGE_LOG.md` | Current status and the log of AI use |
| `../QualifierChallenge/` | The earlier qualifier project. `app/stage_proof_assets.sh` copies its `outs/grant-triage-tool.html` |

## 4. Run locally

**Requirements.** R 4.4 or newer (the container uses `rocker/shiny:4.4.2`; the qualifier used 4.5). From a scan of `library()` calls on Nov 7, these R packages are needed, and **none of this was listed in the old README**: dplyr, stringr, purrr, tibble, jsonlite, httr2, digest, stringi, pdftools, here, data.table, Matrix, **readr, tidyr, janitor** (every script and test load readr and janitor). Extra, only for specific steps: ggplot2 (`helpers_report.R`, charts), sf (`05c_county_shapes.R`, county map outlines), shiny and DT (`app/app.R`, the web page). On a clean machine, `Rscript tests/run_tests.R` stops at the first missing package, so install first:

```r
install.packages(c("dplyr","stringr","purrr","tibble","jsonlite","httr2","digest","stringi",
                   "pdftools","here","data.table","Matrix","readr","tidyr","janitor"))
# optional: ggplot2, sf, shiny, DT
```

Run all R commands from `Finalists/src`. The ranking and tests need no key, no network and no model: they read the committed files in `data/processed/` and `data/manual/`.

```bash
cd Finalists/src
Rscript R/10_run_ranking.R      # writes data/processed/items.csv and ranking.csv (both gitignored) and outs/top_results.csv
Rscript tests/run_tests.R       # needs items.csv from the line above
Rscript R/check_facts.R         # reproduces the fact-sheet numbers
```

**Order matters.** `items.csv` and `ranking.csv` are not in git. Without running `10_run_ranking.R` first, `tests/run_tests.R` falls back to the toy example file and fails with "criteria point at columns that are not in the items" (seen Nov 7). The toy data in `data/example/` is fake and is used only when the real file is missing.

To open the tool by itself, serve the folder and pass the payload path **[run Nov 7]**:

```bash
cd Finalists
python3 -m http.server 8765
# open http://127.0.0.1:8765/src/tool/matchmaker.html?payload=/data/processed/payload.json
```

To run the full web app on your machine **[not run]**: stage the files, then start Shiny from `app/`:

```bash
sh Finalists/app/stage_proof_assets.sh        # from the git root; copies matchmaker.html to app/www/index.html and the qualifier tool to www/tool.html
cd Finalists/app
Rscript -e 'shiny::runApp(".", port = 3838)'
```

The stage script is the only step that makes `app/data/opportunities.csv` and `app/www/*`. The app fails to start without them. The container runs `shiny::runApp("/srv/app", host = "0.0.0.0", port = 3838)` (`app/entrypoint.sh`).

## 5. Rebuild the data pipeline

Order matters. Run from `Finalists/src`. Scripts cache what they fetch under `data/cache/`.

```bash
cd Finalists/src
Rscript R/02a_grantsgov_extract.R    # Grants.gov XML extract (public, no key, about 75 MB zip)
Rscript R/02b_grantsgov_api.R        # official status from Grants.gov search2 (cached)
Rscript R/02c_usaspending.R          # NC past awards, FY2022 to FY2026
Rscript R/02d_federal_register.R     # Federal Register funding notices, last 12 months
Rscript R/02e_simpler_grants.R       # Simpler.Grants.gov; needs SIMPLER_GRANTS_KEY, or a full cache
Rscript R/03_merge_opportunities.R   # -> data/processed/opportunities.csv and .json
Rscript R/04_plan_text_extract.R     # -> data/processed/agency_plan_text/all/*.txt
```

All seven script names exist in `src/R/` (checked). Notes:
- `02a` downloads a large file. Its cache folder `data/cache/api/grantsgov_extract/` is ignored by git, so a fresh clone must download it again. Network access is needed.
- `02e` reads `SIMPLER_GRANTS_KEY` from the environment. Its cache (`data/cache/api/simpler/`, 15 pages dated 2026-11-06) is in the repo, so a rerun should work without a key. **[not verified: not re-run]**
- `04_plan_text_extract.R` uses macOS Vision OCR for image-only pages. The compile command is in `.gitignore`: `swiftc -O -o data/cache/ocr_vision src/tools/ocr_vision.swift`. This step needs a Mac. Cached OCR text is in `data/cache/ocr/`.
- Do not rerun outside-service scripts casually. They call live services for anything not cached.
- Tests for these outputs: `src/tests/test_ingest.R` and `src/tests/test_plan_tables.R`, run through `tests/run_tests.R`.

**After the data steps, the ranking and payload steps** (all offline, from `data/processed/` and `data/manual/`):

```bash
Rscript R/05a_county_need.R          # -> data/processed/county_need.csv (qualifier caches only)
Rscript R/05b_sam_listings.R         # -> data/processed/sam_listings.csv (local bulk file, no key)
Rscript R/05c_county_shapes.R        # -> data/processed/county_shapes.csv (needs the sf package)
Rscript R/10_run_ranking.R           # -> items.csv, ranking.csv, outs/top_results.csv
Rscript R/11_build_payload.R         # -> data/processed/payload.json
Rscript R/12_backtest.R              # -> data/processed/rankings_backtest.csv (closed items, 2, 4 and 6 week windows)
Rscript R/20_backtest_awards.R       # -> data/processed/backtest_result.csv (award-history check)
Rscript R/13_daily_refresh.R         # 10 then 11 in one step; stops at the first failure
```

`10_run_ranking.R` was re-run on Nov 7 and reproduced the fact-sheet counts. `git status` showed no tracked file changed afterward. The other scripts in this block were **[not re-run for this draft]**.

A single script that runs all steps and checks them **[PLANNED, not built]**. `handoff.md` has an empty "How to rebuild" section for this.

## 6. Deploy to Azure

Commands come from `src/docs/azure_setup.md` (proof run result, Fri Nov 6). Names are the ones already created in subscription `unc-sdis-solveathon-team15`. Replace `<...>` placeholders. Do not paste keys into any command that is saved.

Live URL at the time of writing: `https://ffm-app.bluepebble-2cbaa7af.eastus.azurecontainerapps.io/` (tool at `/tool.html`). Scale to zero means the first load after idle took 38.2 s in the proof run.

**Existing resources** (from `azure_setup.md`): resource group `rg-primary-unc-sdis-solveathon-team15`; region `eastus`; storage account `ffmdatateam15` with container `ffm-data`; Log Analytics `ffm-logs`; Container Registry `ffmacrteam15` (Basic); Container Apps environment `ffm-env`; Container App `ffm-app`; budget `ffm-guard`.

```bash
az login                                     # ONYEN@ad.unc.edu plus Duo, done by a person
az account show                              # expect unc-sdis-solveathon-team15
az extension add --name containerapp         # already installed on Marco's machine; preview

# 1. Stage the data and the tool page. Also scans app/ for key values. Prints "staged OK" or FAIL.
sh Finalists/app/stage_proof_assets.sh       # run from the git root

# 2. Build the image in the cloud (no local Docker). Run from Finalists/. The proof used tag v1.
cd Finalists
az acr build -r ffmacrteam15 -t ffm-app:<tag> ./app --no-logs

# 3. First deploy (already done once; shown for a new environment)
az containerapp create -n ffm-app -g rg-primary-unc-sdis-solveathon-team15 --environment ffm-env \
  --image ffmacrteam15.azurecr.io/ffm-app:<tag> --ingress external --target-port 3838 --env-vars MODE=app \
  --cpu 0.5 --memory 1.0Gi --min-replicas 0 --max-replicas 1 --system-assigned \
  --registry-server ffmacrteam15.azurecr.io --registry-identity system

# 4. Update ffm-app to a new image. NOT IN azure_setup.md and not run by us; standard Azure CLI form. [not verified]
az containerapp update -n ffm-app -g rg-primary-unc-sdis-solveathon-team15 \
  --image ffmacrteam15.azurecr.io/ffm-app:<new-tag>

# 5. Keep one replica warm for a demo, then turn it back off. [not verified; planned in planning/08_saturday_plan.md]
az containerapp update -n ffm-app -g rg-primary-unc-sdis-solveathon-team15 --min-replicas 1
az containerapp update -n ffm-app -g rg-primary-unc-sdis-solveathon-team15 --min-replicas 0

# 6. Check
curl -I https://<fqdn>                       # expect 200; page shows "MODE = app"
```

The budget `ffm-guard` was created with `az rest --method PUT` against `Microsoft.Consumption/budgets/ffm-guard` (api-version 2023-05-01) with a JSON body. The full command is abbreviated in `azure_setup.md`, so it cannot be copied from there.

Things that have not been tested: `MODE=job` in the cloud (it would need a Container Apps job, which is **[PLANNED, not built]**), V8 on the server, and use from venue Wi-Fi or a phone hotspot. Rollback: delete only the resources named above and nothing else in the resource group (`azure_setup.md`, "Rollback").

## 7. Configuration and secrets

**How keys are handled now**
- Team API keys (Simpler.Grants.gov and SAM.gov, named `SIMPLER_GRANTS_KEY` and `SAM_API_KEY` in `src/R/00_config.R`) are in `Finalists/api_keys.env`. The file is **committed to git** (confirmed with `git ls-files`). It was committed on purpose because the repo is private (Kent's decision, Nov 6; `handoff.md`).
- `src/R/00_config.R` loads it with `readRenviron(here("api_keys.env"))` when it exists.
- `02e_simpler_grants.R` has a header comment saying the key is "never in a file". That comment is out of date.
- The app image holds no key. `app/stage_proof_assets.sh` copies two files and fails if any `.env` file or any value from `api_keys.env` appears under `app/`. The Container App has no secrets set and registry admin is off (`azure_setup.md`).
- Azure access uses a person's login with Duo and a system-assigned identity on the Container App. No Azure key is stored in the repo.

**What must change before the repo is made public or handed to the State** (all **[PLANNED, not built]**)
1. Rotate the Simpler.Grants.gov and SAM.gov keys. They are in git history.
2. Remove `api_keys.env` from the history, not only from the latest commit, then add it to `.gitignore`. Today it is not ignored.
3. Keep keys in a store the State controls (Azure Key Vault or Container App secrets). The Starter Kit lists Key Vault as pitch-only (`organizer_materials_notes.md`), so it is not set up.
4. Replace the person-login deploy with a pipeline and role assignments the State owns.
5. Give the app a managed identity with Blob access (`Storage Blob Data Contributor` on `ffmdatateam15`) if it is to read state from Blob. This needs a role assignment and was not done.
6. If Azure OpenAI is added, store its key as `$AOAI_KEY` style secrets only. Whether Azure OpenAI keeps prompts out of training is **[uncertain]** and unread (`azure_setup.md`). Check Azure's documentation first.

The qualifier README says `.Renviron` holds the Census key. The Finalists project does not use it.

## 8. Costs

Only facts from `src/docs/azure_setup.md` unless marked.

| Item | Value | Status |
|---|---|---|
| Month to date at start of the proof run | $6.67 | Read from Azure |
| Budget alerts `ffm-guard` | $500 monthly, actual-cost alerts at $50, $100, $250, $400 | Created and read back |
| Organizers' budgets | $500 monthly (one alert at 100%) and $6,000 annual | Read from Azure. These are alerts, not hard limits. The note at the top of `azure_setup.md` still says "spending limit $500", which is inaccurate |
| Image build v1 | about $0.09 | **Estimate**, list price |
| Container App while active | about $0.054 per hour | **Estimate** |
| Idle at min replicas 0 | near zero | **Estimate** |
| One warm replica | about $0.05 per hour at most (`planning/08_saturday_plan.md`) | **Estimate** |
| Azure OpenAI, one pass over 34 agencies at top 20 each plus embeddings | about $0.50 (`planning/08_saturday_plan.md`) | **Estimate**, assumes 3,000 input and 300 output tokens per call. Nothing was run |
| Registry Basic | about $5 per month (`azure_setup.md`, in the list of things not verified) | **Estimate**, not read from Azure |
| Pilot-scale monthly cost | $30 to $80 | From the organizers' Starter Kit, **unverified** |

Azure's cost data lags by hours. Check Cost analysis by hand. Total added by the proof run: about $0.12, an estimate, not re-read from Azure.

## 9. Known limits

- **Match quality was measured and the result is weak.** Award-history backtest, 4-week windows: only 1 of 3 agencies reached the 50% bar (DPI 2 of 3 programs, DEQ 3 of 7, DHHS 4 of 11), and a soonest-deadline baseline beat the ranking in all 3 (fact sheet rows 15 and 16). The bar is a team judgment, fixed before the run. Counts are programs, not notices, program-level matching favors repeat funding, and the intervals are wide. The labelled-pool test with two labelers (decision 12) is not done; the model labels failed their agreement gate and are not used.
- The named weakness we plan to report is recall versus shortlist length (decision 11). Stale plans and the missing SAM.gov postings and USDOT sources are also limits.
- The table includes 4,947 closed items next to 884 posted and 588 forecasted (`azure_setup.md`). A reader could mistake a closed item for an open one.
- Missing values are common: 488 of the 1,576 open opportunities have no usable close date and 887 have no usable award ceiling (fact sheet rows 5 and 6). The page shows "rolling or no date listed" for missing dates and "not listed" for missing awards, never zero (seen in the browser on Nov 7). The "10 hidden" style counts were fixed on Nov 7 to use the agency-level total.
- 70 posted items have close dates after 2030, some in 2099, and one posted item has a past close date (`handoff.md`).
- Table search is word by word across all columns. "school bus" returns 690 of 6,523 rows. It is noisy.
- The planned known-good test case, Clean School Bus (CFDA 66.045), has 0 rows in `opportunities.csv` (`planning/08_saturday_plan.md`). A replacement is not chosen.
- The state-agency flag for past awards is a name rule with 348 recipients unclassified (`handoff.md`).
- Four plans are stale (Auditor, Elections, Wildlife Resources, Commerce) and plan quality is uneven across agencies (`handoff.md`). Thin or stale profiles are flagged in columns and not yet handled in ranking.
- Plan goal rows for manifest rows 18 to 34 were extracted by AI and checked by a script that every quote appears on its page. A person has not yet reviewed them (`AI_USAGE_LOG.md`, `handoff.md`).
- Cold start is 38.2 s after scale to zero (`azure_setup.md`).
- Data handling by Azure OpenAI is unchecked.
- Only public data is used. Do not add sensitive agency information without a review of where it is sent.

## 10. How to extend

**Add a new agency [PLANNED, not built as a procedure].** Today the 34 plans are already in `data/raw/agency_plans/` with a `MANIFEST.csv`. For a plan not on the list: add the PDF and a manifest row, run `04_plan_text_extract.R`, then add goal rows to `src/docs/agency_goal_summaries.csv` using the agency's own goal labels (a Kent decision, Nov 6), each with a quote that is checked by `tests/test_plan_tables.R`. A reusable profile template is **[PLANNED, not built]**; the organizers name this as a defense against uneven documentation (`docs/QUEST_BRIEF.md`).

**Add a new data source.** Copy the pattern of `02c_usaspending.R` or `02d_federal_register.R`: fetch with a cache, write one CSV to `data/processed/`, then add the source to `03_merge_opportunities.R`. Keep missing values as missing. Add checks to `src/tests/test_ingest.R`. SAM.gov is the likely next source but is rate limited for our key; USDOT blocked scripts with a 403 and was not worked around (`handoff.md`).

**Add scoring.** The planned method is decisions 3 to 5 and 7 in `planning/08_product_decisions.md`. The older sketch is as follows. The method is meant to live in `data/manual/criteria.csv`, one row per criterion, with columns `id, type, label, field, rule, value, weight, if_missing, why, source` (`planning/02_framing_worksheet.md`, section 5). The engine is `src/R/score.R` and `10_run_ranking.R`. Neither has been run on real criteria. **[PLANNED, not built]**

**Read from Blob instead of the image [PLANNED, not built].** Planned layout in `azure_setup.md`: `profiles/{agency}.json`, `raw/{yyyy-mm-dd}/grants.json`, `opportunities/latest.json`, `scored/{agency}/latest.json`, `decisions/{agency}.json`, `eval/labels.json`, `runs/{timestamp}.json`.

## 11. Testing

```bash
cd Finalists/src
Rscript R/10_run_ranking.R     # first: makes items.csv and ranking.csv (see section 4)
Rscript tests/run_tests.R
Rscript R/check_facts.R
```

**Results on a fresh worktree, Sat Nov 7, 12:2x (offline, after installing readr, tidyr and janitor):**
- `tests/run_tests.R`: **79 of 80 tests pass.** The one failing row is a placeholder in the "R and JS agree" section named "agreement test pending new ranker for contract-shape payload.json". It is a known gap, not a regression, but it is a visible failing test; Kent to decide whether to remove or implement it.
- `R/check_facts.R`: **29 of 29 rows pass.** (The 29 rows come from `data/manual/facts.csv`; the Friday text of this README said the fact sheet was empty and is out of date.)
- Both print "one or more parsing issues" warnings from `readr`. They did not change the results; I have not traced them.

What the tests cover: `tests/test_ingest.R` (ids unique, status values valid, API-posted ids are posted in the table), `tests/test_plan_tables.R` (every goal quote against its cited page; `handoff.md` reported 56 of 56 on Nov 6, **[not re-run here]**), and ranking, eligibility and payload-shape checks in `tests/run_tests.R`.

Not covered: the web page's behavior (click flows, CSV download, browser storage failure), which was checked by hand in a browser on Nov 7 (`drafts/claude/docs/tool_review_sat.md`); the Azure app (checked by hand per `azure_setup.md`); and the model labels. No automated test of the page exists **[PLANNED, not built]**.

## 12. Where the team's status lives

`handoff.md` (status and decisions), `AI_USAGE_LOG.md` (AI use and errors caught), `src/docs/azure_setup.md` (Azure state), `planning/` (framing and plans). `handoff.md` and the Finalists `README.md` were written before the Azure proof and are partly out of date. Check them against `src/docs/azure_setup.md` before trusting either.
