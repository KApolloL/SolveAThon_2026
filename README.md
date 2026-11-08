# Federal Funds Matchmaker (Solve-A-Thon 2026 Final Quest)

A tool that helps a North Carolina agency grant coordinator see which open federal grants fit the agency's own strategic plan, early enough to apply. A person makes every decision; the tool ranks, filters and explains. Built for the NC Office of State Budget and Management (OSBM).

Team: Kent Lee, Everett Foo, Marco Gullotto, Matthew Martin, Noah Goldblatt.

**Live tool (Azure):** https://ffm-app.bluepebble-2cbaa7af.eastus.azurecontainerapps.io/
Try the demo: open [the live tool with `?demo=1`](https://ffm-app.bluepebble-2cbaa7af.eastus.azurecontainerapps.io/?demo=1). It picks the Department of Public Schools and types "clean diesel school buses, I have 4 weeks" for you; press **Apply**. Or pick any agency yourself. The first load after a quiet spell can take up to about 40 seconds.

## Judges: start here

| You want | Open |
|---|---|
| What it is, how to run it, how to extend it (state developer guide) | [Finalists/README.md](Finalists/README.md) |
| Solution Design and GenAI Field Notes (user, what changed, AI tools, prompts, where AI was wrong) | [Finalists/FIELD_NOTES.md](Finalists/FIELD_NOTES.md) |
| Every number we quote, with the script that reproduces it | [Finalists/src/docs/fact_sheet.md](Finalists/src/docs/fact_sheet.md) |
| Evaluation: backtests, baselines, failures | [Finalists/FIELD_NOTES.md#part-3-evaluation-where-it-works-and-where-it-doesnt](Finalists/FIELD_NOTES.md), figures in [Finalists/outs/figures/](Finalists/outs/figures/) |
| Full AI-use log, one row per session | [Finalists/AI_USAGE_LOG.md](Finalists/AI_USAGE_LOG.md) |
| Azure setup and deploy steps | [Finalists/src/docs/azure_setup.md](Finalists/src/docs/azure_setup.md), [Finalists/app/](Finalists/app/) |
| Discovery notes and framing | [Finalists/planning/07_discovery_findings.md](Finalists/planning/07_discovery_findings.md), [Finalists/planning/02_framing_worksheet.md](Finalists/planning/02_framing_worksheet.md) |
| The organizers' brief and rubric | [Finalists/docs/QUEST_BRIEF.md](Finalists/docs/QUEST_BRIEF.md), [Finalists/docs/JUDGING_RUBRIC.md](Finalists/docs/JUDGING_RUBRIC.md) |

## How the challenge requirements are met

| Requirement | Where |
|---|---|
| Runs on Azure in the provided environment | Azure Container Apps (`ffm-app`) serves the tool; Blob Storage holds `payload.json`; Container Registry holds the images; Azure OpenAI (`gpt-4o-mini`) writes notice summaries; a Container Apps Job holds the daily refresh. See [azure_setup.md](Finalists/src/docs/azure_setup.md) |
| Load federal opportunity data | Grants.gov, Simpler.Grants.gov, Federal Register, USAspending, SAM.gov Assistance Listings: `Finalists/src/R/02*`, `03_merge_opportunities.R`, `05b_sam_listings.R`; 1,576 open opportunities |
| Agency profiles from real NC strategic plans | 34 OSBM plan PDFs in `Finalists/data/raw/agency_plans/`, text and quoted goals for 32 agencies (`04_plan_text_extract.R`, `src/docs/agency_goal_summaries.csv`) |
| Score and rank against those profiles | `10_run_ranking.R`, rules in [criteria.csv](Finalists/data/manual/criteria.csv), settings in [00_config.R](Finalists/src/R/00_config.R) |
| Summarize relevant information | Plain two-sentence summary per notice by Azure OpenAI, kept only when its quote is found in the notice (`31_swipe_summary.R`); matched plan goal and a one-line "why" on every row |
| Simple interface for a state employee | One page: pick an agency, see the Top 10, Coming up and Hidden lists; mark Pursue / Maybe / Skip; export CSV ([src/tool/matchmaker.html](Finalists/src/tool/matchmaker.html)) |
| Humans decide | The model never sets rank, eligibility or tier; unclear eligibility shows "Ask" with the quote |
| Bonus 1, reach | Reach test against a newest-posted stand-in for manual alerts (fact sheet row 31) |
| Bonus 2, deadline alerts | Days left and a closing-soon flag on every row; deadline alerts in the tool |
| Bonus 3, learn from users | Pursue / Maybe / Skip marks, adjustable weights, and a feedback form sent to the app's `/feedback` log (`app/read_feedback.sh`). Feedback does not yet retrain the ranking |
| Reproducible | From `Finalists/src`: `Rscript R/10_run_ranking.R`, then `Rscript tests/run_tests.R` (86 of 86 pass) and `Rscript R/check_facts.R` (49 of 49 rows pass). No keys or network needed: caches are committed |

## Repository layout

| Folder | What it is |
|---|---|
| [Finalists/](Finalists/) | **The Final Quest submission.** Code, data, Azure app, docs, evaluation |
| [QualifierChallenge/](QualifierChallenge/) | Round-one work (DHHS grant triage). The Final Quest reuses two of its files (agency capability table, county shapes), so it stays here. Its website: https://kapollol.github.io/SolveAThon_2026/ |
| `Finalists/_team/` | Team-internal process files (task briefs, runbook, archived drafts, vault copies). Not needed to judge or run the work |
| `comms/` | Team messaging between working sessions. Not needed to judge or run the work |

Teammates: see [CONTRIBUTING.md](CONTRIBUTING.md) for setup and workflow.
