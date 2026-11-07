# Handoff: Finalists

> **Saturday Nov 7 update:** `saturday/` (start at `saturday/README.md`) overrides this file where they differ.

_Update this at each checkpoint (about every 6 hours) and before ending any long AI session. A fresh session reads this after CLAUDE.md._

**Last updated:** Fri Nov 6, 2026, ~9:00 pm (Marco's Azure update; the rest of this file is from ~11:00 am, before the discovery workshop)
**Hours remaining to submission deadline (Sun Nov 8, 9:00 am):** about 36

## Goal in one sentence
[assumed, confirm at workshop] Help an agency grant coordinator find and prioritize federal funding opportunities that match their agency's strategic plan early enough to apply, with a human making the final call, deployed on Azure for OSBM. Organizer text: `docs/QUEST_BRIEF.md`.

## Status
| Piece | State (not started / in progress / done / blocked) | Owner | Notes |
|---|---|---|---|
| Quest brief saved (`docs/QUEST_BRIEF.md`) | done | Kent / Claude | Docs updated from it Fri am |
| Azure access and environment | in progress | Marco | `ffm-app` live at https://ffm-app.bluepebble-2cbaa7af.eastus.azurecontainerapps.io/ (Shiny fallback at `/`, qualifier JS tool at `/tool.html`, image `ffm-app:v1`, 0.5 vCPU, 1 Gi, min 0, max 1, managed identity pull). Budget alerts `ffm-guard` at $50, $100, $250, $400; alerts do not stop spending. Azure OpenAI `ffm-aoai-team15` created Sat 12:50 am with `gpt-4o-mini` and `text-embedding-3-small`, both calls tested; not wired in; confirm at the 9:00 check that it is ours to use. Details: [src/docs/azure_setup.md](src/docs/azure_setup.md) |
| Problem framing and user | not started | Kent | Waits for 6:30 pm workshop and 7:30 pm sprint; user is [assumed] |
| Data ingestion (opportunities feed) | done for Grants.gov, Simpler, Federal Register, USAspending (Nov 6 night) | Kent / Claude | `Rscript R/02a..02e`, `03_merge_opportunities.R` -> `data/processed/opportunities.csv/.json` (6,523 rows: 882 posted + 2 API-only, 588 forecasted, 4,947 closed since 2024-11-06, 104 Federal Register notices). Tests: `tests/test_ingest.R`. Not pulled: SAM.gov catalog (10 requests per page of 10 listings, 2,873 listings, key allows too few calls), USDOT page (transportation.gov returns 403 to scripts; not worked around). Details in "Data setup notes" below |
| Agency profiles from strategic plans | not started | Kent / teammate | 34 OSBM plan PDFs downloaded to `data/raw/agency_plans/` (see `MANIFEST.csv`). Text extractability not yet checked. Starter Kit says serve ONE agency; sponsor picks tonight |
| Organizer materials read (Starter Kit, Azure guide, template, zip) | done | Claude | Notes: `src/docs/organizer_materials_notes.md`. Zip skills not installed |
| Core analysis / pipeline (score, rank, summarize) | not started | Kent | Likely Rank plus Classify; see decisions |
| Interface on Azure | not started | Kent | Must be usable by a state employee |
| Field notes (Solution Design and GenAI) | not started | Teammate (D) with Kent | Required deliverable; needs sponsor changes-of-plan, prompts, one AI error caught |
| README as state-developer guide | not started | Kent | Required deliverable |
| Evaluation and named weakness | not started | Kent | |
| Fact sheet (`src/docs/fact_sheet.md`) | not started | Kent | |
| Slide brief + figures (`deliverables/slide_brief.md`, `outs/figures/`) | not started | Kent / Claude | Handoff to teammate's AI agent |
| Presentation slides | not started | Teammate with AI agent, near the end | Built from the slide brief; numbers only from fact sheet |
| Q&A cheat sheet + hostile-judge pass | not started | Kent / Claude | |
| Presentation rehearsal | not started | Team | |
| AI-usage disclosure | not started | Teammate | Written from `AI_USAGE_LOG.md` |

**Update Sat Nov 7, 12:45 am (Marco):** tool proposals for Kent are in [planning/09_tool_plan_update.md](planning/09_tool_plan_update.md); Saturday plan in [planning/08_saturday_plan.md](planning/08_saturday_plan.md). Field notes, README and diagram drafts are in `drafts/claude/`. Rows above may be out of date; scoring and ranking are with other teammates.

## Decisions made (and why)
- Keep R and Quarto as the core, add a small deployable front end on Azure. Reason: reuse qualifier plumbing (Kent, Nov 6). Revisit if Azure hosting of R is painful.
- Working user assumption: agency grant coordinator, marked [assumed] until the workshop (Kent, Nov 6).
- Problem type is probably Rank (opportunities per agency) plus Classify (LLM labels with quotes). Skeleton parts to keep: `read_any`, cache helpers, `score.R`, tests, report, figure export, `helpers_llm.R` [assumed until framing is done]. Confirm after the sprint.

- Design idea to test at the workshop: users rank a sample of real grants blind at onboarding, and that ranking calibrates criteria weights (bonus quest 3, moved to the start). Priority among bonuses: deadline alerts, then feedback loop, then coverage metrics. Details and risks: `planning/05_user_criteria_and_feedback.md` (Kent, Nov 6).

## Open questions
- Talk length: released brief, Starter Kit and slide template all say 6 min (plus 2 min Q&A). The 10.22.26 email said 5 plus 2. Treat as 6; confirm only if an organizer says otherwise.
- R/Quarto versus Python/Streamlit: the Starter Kit assumes Python. Decide tonight (tradeoff in `src/docs/organizer_materials_notes.md`, section 6).
- Lanes: adopt the kit's four lanes (Cloud and Ops, Data, Matching and AI, App and Story) or keep RUNBOOK roles?
- Exactly what is submitted at 9:00 am: slides, field notes, repo, product link via the form. The brief names a Microsoft Forms link, not Devpost.
- Which Azure services are in the provided environment (LLM endpoint? app hosting? storage?) and is a model available there? Local Ollama cannot count as "on Azure".
- How many agencies and which? (Strategic plans are on the OSBM page.)
- Live Grants.gov vs SAM.gov: which feed, and are API keys needed?
- Azure: subscription is `unc-sdis-solveathon-team15` (found Fri night), login `ONYEN@ad.unc.edu` plus Duo. Azure OpenAI is not pre-provisioned in the subscription (none listed Fri night); whether we may create it is still to confirm.
- Who is the real user and what does the Discovery Session say changed our plan? (Field notes need this in the sponsors' words.)

## Blockers
- Azure access is confirmed (Fri night). Open: is Azure OpenAI ours to create, and does R Shiny on Container Apps build and run? Answers decide the stack (see `src/docs/azure_setup.md`).
- Spending limit of $500 on the team subscription (told to Marco). Keep to the cheapest tiers and cap model calls.

## Discovery session
Findings and plan changes: [planning/07_discovery_findings.md](planning/07_discovery_findings.md). Organized notes: [notes/vault/Solveathon_DiscoverySession.md](notes/vault/Solveathon_DiscoverySession.md).

## Product decisions (Nov 6 night)
15 decisions confirmed by Kent after a grilling interview: [planning/08_product_decisions.md](planning/08_product_decisions.md). It overrides older "not started" assumptions in the status table. Next: pool rules and labels, criteria.csv, profile, pipeline, Sat 1:00 PM gate.

## Plan review amendments (Nov 6 night)
Twelve amendments (A to L) from a grilling review are appended to [planning/08_product_decisions.md](planning/08_product_decisions.md) and override the 15 decisions where they differ. Short form: keyword fit first with embeddings as a swap; pool hand-labelled then model-labelled (model labels count only at 80% catch of hand "relevant" and kappa 0.6); category-stratified pool with fixed seed; flag = top 10 per agency per window, no tuning; backtest curve at 2, 4, 6 weeks with all vs in-time (21 days) catches; daily Container Apps Job; closing-soon panel; `POST /feedback` with Rocchio updates; mentor test at Sat 2:00 PM; new cut order. Repo stays private (Kent, Nov 6). Open: how judges get repo access; verify the school bus window; X = 21 days is an assumption.

## Next three steps
Friday night owners and teammate AI prompts: [planning/06_tonight_plan.md](planning/06_tonight_plan.md). Marco owns Azure; Noah and Matthew check plan text; Kent owns planning.

1. Azure (Marco; first half done Fri night, rest in `src/docs/azure_setup.md`): log in, find the team subscription, confirm whether Azure OpenAI is available, then run the Starter Kit's setup steps. Email the three support contacts (CC all) if the subscription does not appear. Starter Kit, Azure guide, template and zip are already read: `src/docs/organizer_materials_notes.md`.
2. 6:30 pm workshop using `planning/01_discovery_questions.md`; add the brief-specific questions listed there. Then 7:30 pm sprint: fill `planning/02_framing_worksheet.md` and tick the gate.
3. Only after the gate: profile the opportunity feed and agency plans, and start the field notes file (record each sponsor-driven plan change as it happens).

## How to rebuild
(Commands to rebuild from scratch, once they exist. Model after the "Rebuild from scratch" block in `../QualifierChallenge/README.md`.)

## Checkpoint schedule
Official schedule is in the vault hub `Projects/Competitions/Solveathon/Solveathon.md`; the hour-by-hour plan is in `Solveathon_DeloitteTraining` ("Weekend plan").
- Fri 6:30 pm client discovery workshop; 7:30 to 8:45 solution design sprint (user and criteria on paper before any data); 8:45 mentor check-ins.
- Sat 9:00 check-in; 1:00 mid-day check-in (gate: working ranking); 2:00 to 4:00 mentor drop-ins; 7:00 to 8:00 wrap up = code freeze.
- Sun 9:00 am submission (slides, field notes, repo, product link, via the form); 10:00 to 12:30 presentations (6 min with demo plus 2 min Q&A per the brief; confirm).

## Data setup notes (Nov 6 night)
- Gate: pulling and merging data is allowed before the framing gate; analysis and scoring are not.
- Scope kept: all posted and forecasted (any eligibility) plus closed with close date on or after 2024-11-06 (`is_recent_closed`). Nothing dropped at ingestion.
- Status: the extract has no status field, so 02a derives it; 02b checks it against live Grants.gov `search2` (1,469 of 1,472 agree) and 03 trusts the API for posted and forecasted.
- Simpler.Grants.gov returned 884 posted and 587 forecasted and added 0 rows: it mirrors Grants.gov. Its value is a cross-check and named applicant types (`applicant_types_named`).
- Federal Register: 109 notices in the last 12 months; 5 matched to a Grants.gov row by opportunity number, 104 kept as `status = notice` rows (open state not verified). Keyword recall is [uncertain].
- USAspending: `recipient_type_names = state_government` returns 0 rows for NC, so 02c pulls "government" and flags state agencies by name (heuristic). Review `data/processed/nc_awards_recipients.csv` (348 unclassified recipients).
- Known data-quality issues in Grants.gov: 70 posted items with close dates after 2030 (some 2099), 1 posted item with a past close date (HRSA-27-072).
- Keys: the Simpler and SAM keys are in `api_keys.env` (committed on purpose, private repo, Kent Nov 6) and loaded by `00_config.R`. Cached reruns need no key.
- Agency plan text (Nov 6 night, Claude on main): `R/04_plan_text_extract.R` re-extracted all 34 plans to `data/processed/agency_plan_text/all/<stem>.txt` (local macOS Vision OCR for image-only or ligature-garbled pages, marked `[OCR]`; log in `src/docs/plan_text_extract_log.csv`). Combined tables: `src/docs/plan_text_check.csv` (34 rows; `cross_cutting` flags State Board of Education Plan and Guiding Principles) and `src/docs/agency_goal_summaries.csv` (158 goal rows, all 34 plans, category = each agency's own goal label (Kent decision Nov 6, no shared taxonomy)). Noah and Matthew originals kept as `_noah`/`_matthew` files. Goals for rows 18-34 (87 rows) were extracted by Claude subagents in place of Matthew; a script checked every quote against its cited page. Known gaps: Commerce plan is FY21-23 (stale); DOT goals have no label (items 4-6); Agriculture goals are division names (the one-sentence statements for Agriculture and DHHS goals are in the `goal_statement` column); OAH has three division goal sets; DHHS has Goals 1-5 plus Priorities 1-4; Guiding Principles is the same State Board of Education plan packet (duplicate goals, `duplicate_of_row` = 2); its OCR char drop was garbled original text, not lost text. Goal rows carry `goal_kind` (goal, division_goal, priority, division_name, goal_unlabeled), `plan_stale` (plan ended before 2026: Auditor, Elections, Wildlife Resources, Commerce; 18 goal rows) and `cross_cutting`. `tests/test_plan_tables.R` checks every quote against its page (56 of 56 pass). Bug caught: Matthew's `department_of_justice.pdf.txt` was 1 byte while his CSV said 20,160 chars.
- Blob upload (`ffm-data`) not done; waits for Marco.

## Sat Nov 7 midday update (Kent's Claude)
- Full tool is in main (PR #46): `src/tool/matchmaker.html`. Payload has goals[] (153 across 32 agencies) and closing_soon_days.
- Azure NOT deployed. `app/deploy_azure.sh` is ready (dry run by default). `az` is not on Kent's Mac; Marco holds the login. Marco runs `DEPLOY=yes sh app/deploy_azure.sh` from `Finalists/`. Details in `comms/to-marco.md`.
- Not in the tool (no data): county reach, need map, capability gaps, impact sliders. `signature_tier` is all "unknown".
- Noah's Claude is running the 23-agency labels on his machine (N2). Marco's Claude: snapshot repo (T2), notice reader (T3, blocked).
- Checked Sat Nov 7 (Kent's Claude): rerun of `10_run_ranking.R` then `11_build_payload.R` gives an identical `payload.json` (md5 fa2e2a6c1c8fca628cf7bc30bea7f21e). DERA ranks 1 for DEQ and 3 for DPI, both eligibility "ask". `check_facts.R` 24 of 24. Azure is Marco's computer's job.
- Qualifier data now in the tool (PR from `kent/sat-data2`): County map tab (18 measures from the qualifier caches: CDC PLACES, ACS 2023, HRSA, NCHS, OpenFEMA; outlines from the tigris cache via `05c_county_shapes.R`) and the DHHS and DMVA capability table (28 hand-built rows). Not carried, with reasons: CDC WONDER all-cause death file (crude rate over 1999 to 2020, not age adjusted, unused even in the qualifier), ACS by congressional district (no grant field to join), USAspending awards and Grants.gov enrichment (Finals already has its own `nc_awards_by_cfda.csv` and `grantsgov_extract.csv`). Per-grant county reach does not exist in any source.

## Scoring pass (Sat Nov 7, Kent's Claude, branch kent/sat-scoring)
- Signature tier now comes from notice fields (`signature_tier()` in `src/R/helpers_rank.R`): cost share Yes and award at or above `TIER_APPROPRIATION_USD` ($1M) is leadership; Yes below that is supervisor; No is writer; missing is unknown. Top 10: 259 known, 61 unknown (notices state no cost share). It does not check agency capabilities, and the tool says so.
- `payload.json` rows gain `tier_reason` and `rank_note` (additive). The tool shows both under Details.
- The "R and JS agree" pending test is replaced by a check that payload rank order equals fit_score order in every agency, and matches the full ranking. `tool/ranker.js` serves the toy payload only. Tests 83 of 83, facts 31 of 31.
- Weights were NOT tuned. `20_backtest_awards.R` fixes its pass bar (50 percent on 4-week windows, 2 of 3 agencies) before the run and says not to retune after seeing results. Current 4-week recall: DPI 67 percent, DEQ 43, DHHS 36, so the bar is failed (1 of 3) and sits at or under the deadline baseline. That stays reported as evidence in the field notes. Tuning on the same 3 agencies would void the bar.

## Backtest v2 (step 1, measure fix)
- Original bar (50% on 4-week windows, 2 of 3 agencies) failed 1 of 3 and stays reported. Not retuned.
- `src/R/21_backtest_v2.R` fixes the denominator (full window pool, not stored top 50), adds Top 20 and 50 and 15 more agencies by exact-name map rows in `data/manual/agency_award_map.csv`. Facts f32 to f36, fact sheet rows 26 to 29. Exploratory.
- Result: Top 10 57 of 157 won programs (36%), deadline sort about 17%, random about 13%.
- Step 2 (improve the ranking with a leave-one-program-out holdout) not started; see to-noah and the board.

## Backtest step 2 (tuning with held-out agencies)
- `src/R/22_backtest_tune.R`: 9 text settings, two agency folds. No setting beat the current one on held-out agencies in both directions. Nothing adopted; pipeline and payload unchanged. Facts f37 to f39, fact sheet row 30. Centering across agencies matters (40 vs 57 of 157 without it). Next lever, untested: embeddings.
