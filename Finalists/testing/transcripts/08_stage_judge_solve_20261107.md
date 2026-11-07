# Stage judge: Solve (Sat Nov 7, 2026, main at 95fed84)

Stale statements noticed in `testing/context.md`: "`criteria.csv` does not exist", "ranking file and payload.json not yet", "fact_sheet empty", and the status table in `handoff.md` ("Core analysis not started", "Interface on Azure not started"). All are superseded by the files: `data/manual/criteria.csv`, `data/processed/payload.json` and `data/processed/backtest_result.csv` exist. `src/docs/azure_setup.md` itself says the Blob file was "still Kent's stub" and the job is a stub; I could not tell whether Blob has since been updated.

## 1. Score: 3 / 5
The pipeline from Grants.gov data to a real 32-agency payload is built and deterministic, and the tool reads it. But the Azure side is a viewer plus a stub job, nothing uses Azure OpenAI, and the one measured result fails its own pre-set bar: "Pass if 2 of 3 agencies hit it".

## 2. Requirements
| Brief requirement | Built by | Real data? | Visible to user? | Evidence |
|---|---|---|---|---|
| Load federal data | `R/02a..02e`, `03_merge_opportunities.R` -> `opportunities.csv` | Yes (6,523 rows, per handoff; extract plus live Grants.gov API) | Indirectly | Closed items feed backtest only. SAM.gov and USDOT not pulled (handoff). |
| Agency profiles from real NC plans | `04_plan_text_extract.R`, `agency_goal_summaries.csv`, `plan_texts()` in `helpers_rank.R:~85` | Yes (34 plans, OCR partly) | Only as one goal heading per row | Profile = the agency's full plan text as one TF-IDF vector. It is a bag of words, not structured (no programs, populations, statutory authority). Goal headings are display only (`helpers_rank.R` comment at build_pairs). |
| Score and rank per agency | `helpers_rank.R` build_pairs/build_items, `score.R`, `10_run_ranking.R`, `11_build_payload.R`; `criteria.csv` | Yes. Ran: "32 agencies; 50432 pairs; 3030 dropped by filters; 47402 ranked" | Yes, top 10 per agency (320 in_top10 rows) | Only `fit` has weight 1; award_size, no_cost_share, runway all weight 0 in `criteria.csv`. So rank = keyword fit alone, centered per opportunity. Deadline, effort, payoff are not in the rank (sponsors asked "payoff vs effort"). |
| Summarize relevant info | `11_build_payload.R` | Yes | Yes | `opp_snippet` = first 240 chars of the notice summary (`str_sub`); `goal_snippet` = best-matching goal heading, not a summary. Not a generated summary. 90 of 960 rows have no goal snippet. No Azure OpenAI summary. |
| Simple interface for a state employee | `src/tool/matchmaker.html`, served by `app/app.R` at `/` | Reads `/payload.json` from Blob | [cannot assess] live; code reads the contract payload | Not browser-tested by me. `run_tests.R` agreement test is a placeholder. |

Payload check: real, not stub. `data_as_of` 2026-11-07T11:00:00-05:00 (hard-coded in `00_config.R:97`), 32 agencies, 960 rows (422 posted, 477 forecasted, 61 notice; 320 top-10, 320 eligibility "no" hidden). md5 identical before and after rebuild (manager).

Quality of what the user sees (queried from payload.json):
- DPI top 10: all 10 rows eligibility "ask". #1 is Tribal Colleges and Universities Program (47.076), #2 an NSF scholarship program, #4 and #5 matched to the goal "2. Revere Public School Educators", a heading that looks like another state's district plan text in the DPI goal table. Several top-10 rows (NSF research, REAP for health professions, West Point BAA) are not plausible DPI leads. Row 1 `elig_quote` is null for the tribal-college item.
- DEQ #1 is DERA (good, per gate); DERA is DPI #3 (the lift comes from the hand `program_map`, `MAP_FIT_FLOOR`; DEQ fit 0.8 and DPI 0.8 are the floor, not earned).
- DHHS top 3 are NIH PAR mental-health research announcements.
- `reader_label`, `reader_quote` null on all 960 rows; `signature_tier` "unknown" on all 960 rows; `plan_thin` NA.

## 3. Azure
| Service | Purpose | Load-bearing or decoration | Evidence |
|---|---|---|---|
| Container Apps `ffm-app` (min 0, max 1) | Hosts R Shiny wrapper, serves `matchmaker.html`, `/payload.json` proxy, `/tool.html` | Load-bearing for the demo URL | `app/app.R`, `azure_setup.md` v2 table. Cold start ~35-38 s measured (docs); min replicas 1 not yet set. |
| Blob `ffmdatateam15/ffm-data` | Holds `payload.json` | Load-bearing (app fetches it, 60 s cache) | `app/app.R:~14-30`. Read-only SAS expiring 3 days from Sat; managed identity unassigned (role refused). Doc says the Blob file was a stub; real upload not confirmed. Note app code returns 502 if the blob lacks `"agencies"`; no local fallback to bundled payload. |
| Container Apps Job (`MODE=job`) | Daily refresh | Decoration (planned). `entrypoint.sh` only echoes a line and exits 0 | `app/entrypoint.sh:3-6`; `azure_setup.md` "Not yet done". `11_build_payload.R` is not called by any job; scheduled refresh would also need R scripts and API keys in the image (Dockerfile copies only app files). |
| Azure OpenAI `ffm-aoai-team15` (gpt-4o-mini, text-embedding-3-small) | Embedding swap / reasons / notice reader | Decoration: created, test calls only, not wired. `helpers_llm.R` has no Azure call in the ranking path | `azure_setup.md` "Not done: wired into the app or pipeline". Ownership by the team unconfirmed. |
| ACR `ffmacrteam15`, Log Analytics, budget `ffm-guard` | Build, logs, cost alerts | Supporting | docs |
Live URL serves the real tool: [cannot assess].

## 4. 1:00 gate checklist (`saturday/01_goals.md`)
| Line | Status | Evidence |
|---|---|---|
| Azure URL loads; pick agency (32), see top 10 open | Cannot tell | Payload has 32 agencies x 10 top-10 rows, but 477 rows are forecasts and "open" top 10 is posted+notice only; live URL not fetched; Blob contents unverified. |
| Each row: days left or "rolling or no date listed", eligibility yes/no/ask, goal + snippet | Partly met | Payload fields exist (`days_left`, `date_note`, `eligibility`, `goal_snippet`). 90 rows lack a goal snippet; UI rendering not checked. |
| payload.json from real pipeline, rerun same file | Met | Not the stub (32 agencies, 960 rows); manager: md5 identical across rebuild. Caveat: needs ignored `items.csv`, built by `10_run_ranking.R`; `run_tests.R` and `check_facts.R` crash on a fresh checkout without it. |
| Backtest for DPI, DEQ, DHHS vs pass bar with both baselines | Met as computed, result is a fail | `backtest_result.csv`: 4-week catch DPI 67% (2/3), DEQ 43% (3/7), DHHS 36% (4/11). Bar 50% in 2 of 3: only DPI passes at 4 wk; fails. Deadline baseline: DPI 100/67/75% ... beats the tool at every row for DEQ and DHHS (e.g. DHHS 4wk 73% vs 36%). Random baseline also ≥ tool in most rows. CIs span roughly 7%-99%. |
| DERA in DEQ and DPI lists; tribal-only hidden; 2099 dates "rolling" | Mostly met | DERA DEQ #1, DPI #3. 2099 handled by `prep_opportunities` (>= 2030). Tribal-only: DPI #1 is the Tribal Colleges program (47.076, `ask`); 11 top-10 rows across agencies have "ribal" in the title, so tribal items are not reliably hidden. |

## 5. Findings
| # | Where | Problem | Severity | Fix |
|---|---|---|---|---|
| 1 | `data/processed/backtest_result.csv` | Fails the team's own pass bar and loses to the soonest-deadline baseline for DEQ and DHHS at every window. The tool's keyword ranking is not shown to beat "sort by deadline". | high | Report it honestly as the named weakness; do not claim recall. Consider blending runway/award into rank and re-measuring. |
| 2 | `app/entrypoint.sh:3-6`; `azure_setup.md` "Not yet done" | Daily job is an echo stub; "Never cut: the daily job" is unmet and no cloud refresh exists. | high | Build the Job: image with R pipeline or a Python refresh, writes Blob; or demo a manual trigger and say so. |
| 3 | `data/manual/criteria.csv` (weights), `helpers_rank.R` build_pairs | Rank is keyword fit only (other criteria weight 0); sponsors asked for payoff vs effort and deadline. DPI top 10 is all "ask" and includes NSF/NIH research and a tribal-college program. | high | Turn on runway weight; filter or flag higher-ed/tribal-only; spot-check each agency top 10 by hand. |
| 4 | `payload.json` DPI rows 4-5 `goal_snippet` | Goal heading "2. Revere Public School Educators" shown as a DPI plan goal: wrong source or misextracted goal. Credibility hit on the "matched to plan goal" claim. | medium | Check the DPI goal table rows; rerun `test_plan_tables.R`; blank the snippet when match is weak. |
| 5 | `helpers_rank.R` `apply_program_map`, `MAP_FIT_FLOOR` | DERA's presence in DEQ/DPI is from a hand-made lift to a floor of 0.8, then the gate item is claimed as ranked. Fine to disclose, risky to present as model output. | medium | State it in the fact sheet and Q&A. |
| 6 | `11_build_payload.R:~64-70` | `reader_label`, `reader_quote` all null; `signature_tier` all "unknown"; `plan_thin` NA. Summarize requirement is a 240-char truncation plus a goal heading. No GenAI in the product. | medium | At least wire gpt-4o-mini for 1-line reasons on top 10 with quote check, or label the column honestly "first 240 characters". |
| 7 | `app/app.R:~30-45` | If Blob has no `"agencies"` the page gets 502 with no bundled fallback; SAS expires in 3 days; min replicas 0 gives a ~35 s cold start the sponsors said fails. | medium | Bake `payload.json` into the image as fallback; set min replicas 1 before the demo; renew SAS. |
| 8 | `src/tests/run_tests.R:108` | R/JS agreement test is a hard-coded `FALSE` placeholder; the tool's ranker (`ranker.js`) is the old qualifier ranker, not the code that produced payload ranks. Tests/ facts crash on fresh checkout (no `items.csv`) and still print TOY EXAMPLE note. | medium | Remove stale ranker or write the agreement test; make `check_facts.R` run `10_run_ranking.R` or fail with a clear message. |
| 9 | `00_config.R:97` | `PAYLOAD_AS_OF` is a fixed string, not the data date; `REF_DATE` 2026-11-06. Days-left will be wrong after tonight. | low | Derive from the fetch date; show in UI. |

## 6. Command results
Not run by me (instructed). Manager's results, quoted: `Rscript R/10_run_ranking.R` -> "32 agencies; 50432 pairs; 3030 dropped by filters; 47402 ranked". `run_tests.R` -> "78 of 79 tests pass" (failing: "R and JS agree": "agreement test pending new ranker for contract-shape payload.json"). `check_facts.R` -> "17 of 17 rows pass". Before building `items.csv`, both crashed on "criteria point at columns that are not in the items". I queried payload.json read-only with `python3 -I`.

## 7. [cannot assess]
Live Azure URL and whether it serves the real tool; current Blob content (stub or real); rendering/usability of `matchmaker.html` in a browser; whether Azure OpenAI is ours to use; data-handling/privacy terms; the daily job in the cloud; phone/venue Wi-Fi behavior; the Merge 2 upload state.
