# Deliverables audit, Sat Nov 7 2026, about 10:45 am
Reviewer: deliverables-auditor. Read-only. Checklist from `docs/QUEST_BRIEF.md` (Deliverables, Field notes must show).

Stale statements noticed: `testing/context.md` says the fact sheet is empty, criteria.csv does not exist, payload not built (all now built per `src/docs/fact_sheet.md` and the AI log). `drafts/claude/docs/field_notes_draft.md` and `README_state_developer_draft.md` describe Friday night ("no scoring", 70% bar, "No Azure OpenAI resource exists"; the 50% / 2-of-3 bar is decision 7). `README.md` still says hello page and toy data. `handoff.md` line 17 still says "not wired in; confirm at 9:00". `planning/08_product_decisions.md` gate (Clean School Bus 66.045) is superseded by `saturday/01_goals.md` (DERA 66.039).

## 1. Checklist
| Deliverable | Required element | Status | File | What is missing |
|---|---|---|---|---|
| Pitch | Slide brief covering user/problem/requirements, solution + demo, evidence incl. failures, pilot, scale roadmap | MISSING | `deliverables/slide_brief_TEMPLATE.md` only; no `deliverables/slide_brief.md` | Whole brief. Owner per `people/kent.md` step 7 (afternoon). No figures in `outs/figures/` except stub-era `backtest_recall.png` (stub numbers, not for slides) |
| Pitch | Talk outline with timings fitting 6 min, speaker split | MISSING | none | Not in repo. Slot is Sun 10:26 to 10:34 (`saturday/README.md`) |
| Pitch | Q&A sheet | MISSING (empty template) | `src/docs/qa_cheatsheet.md` | 5 rows, all answers blank, no fact numbers |
| Pitch | Evidence incl. where it fails | PARTIAL | `AI_USAGE_LOG.md`, `data/processed/backtest_result.csv`, fact sheet | Backtest result exists (Everett 11:00 rerun: baselines beat the model, denominators 3-11) but is not in `fact_sheet.md` (18 lines, 14 facts, none on backtest or label gate kappa 0.44) |
| Field notes | Target user | PARTIAL | `drafts/claude/docs/field_notes_draft.md` s1 | Still [assumed]; no real user confirmed |
| Field notes | How we understood the user; sponsor Discovery statements that changed the plan | PRESENT (draft) | s2 | Rows say "Not built" for scoring, onboarding, etc.; outdated since Saturday builds |
| Field notes | GenAI tools used | PARTIAL | s5 | Says log rows missing for overnight/Saturday plan (now partly present); "confirm no PromptLab" open; Azure OpenAI and Ollama qwen2.5:14b missing from s5 |
| Field notes | Key prompts, actual text | PARTIAL | s6 | Excerpts of teammate prompts only; ingestion and framing prompts `[TO FILL]`; Saturday per-person prompts in `saturday/prompts.md` not quoted |
| Field notes | At least one AI error with file/commit proof | PRESENT (draft), strong | s7 and AI log | 8 rows exist and the log has more (stub 2019 forecast, kappa 0.44 label gate, DERA rank 84/754, items.csv commit). Not updated; row 3 still `[TO FILL]`; no commit hashes for Saturday errors |
| Field notes | Saturday evidence (backtest, label check, mentor log) | MISSING | s9 | Section 9 is the whole open list; `saturday/mentor_log.md` still to be filled (Matthew); no user feedback from a real person recorded |
| Repo README | State developer can install, run, test, deploy on Azure, know limits, extend | MISSING in `README.md`; PARTIAL in draft | `README.md` (64 lines), `drafts/claude/docs/README_state_developer_draft.md` (222 lines) | README.md is not replaced. Draft is not merged and is Friday-accurate ("No scoring", "MODE=job is a stub", no payload, no key rule) |
| Repo README | Run/test commands current | PARTIAL | README.md "Pipeline skeleton ... runs on toy data" | Real run order (09/10/11/12, `tests/run_tests.R`, `check_facts.R`) not written for a newcomer |
| Repo README | Azure deploy | PARTIAL | draft s6, `src/docs/azure_setup.md` (195 lines) | Update/redeploy commands marked "[not verified]"; spend not filled (Marco 7:00 pm) |
| Repo README | Keys: "make your own", no committed keys | MISSING | none | `api_keys.env` and `tasks/everett_api_keys.md` are tracked (git ls-files) |
| Product link | Live URL in README | MISSING | README.md has no URL | URL only in `handoff.md:17` and the draft s6 |
| Product link | URL in slide brief | MISSING | no slide brief | Also: URL serves the Shiny fallback at `/`, tool at `/tool.html`, image `ffm-app:v1`; whether the Saturday tool is deployed is unverified; scale-to-zero cold start 38.2 s |
| Judges' repo | Script or checklist for clean snapshot (decision 10) | MISSING | `people/marco.md` step 7, `06_dependencies.md` row 17 | Owner is named (Marco, 7:00 pm; fallback Kent). No script, no checklist. grep for "snapshot" finds only plan text. Keys are in git history, so only the no-`.git` copy is safe. Also exclude `tasks/everett_api_keys.md`, `data/cache/api` size, and confirm form wants a link or a file (Matthew's 9:00 question, answer not in `mentor_log.md`; log notes no answer supplied) |
| AI disclosure | Every AI use logged incl. these review runs | PARTIAL | `AI_USAGE_LOG.md` | Nov 6 persona run is logged. Nov 7 reviewer runs (transcripts 08 stage_judge_solve, 11 fact_tracer, this run) have no row. Table is broken: a blank row at line 8, and all rows after the "Notes for the disclosure" block (starts with Matthew 11-06) render outside the table. Several rows say "human check pending". Rows 09, 10 transcript numbers missing |
| Form | Final Submission form filled by Kent, target 8:30 | NOT STARTED | `saturday/00_timeline.md` | Needs slides file, field notes file, repo link/zip, product link ready first |

## 2. Leftover markers (tracked text docs; data CSVs excluded except where relevant)
| File | Marker | Count (lines) | Example |
|---|---|---|---|
| `drafts/claude/docs/field_notes_draft.md` | `[TO FILL]` | 3 lines with several occurrences (ss3, 5, 6, 7, 9; about 9 in text) | "The measured number is `[TO FILL]`." |
| `drafts/claude/docs/field_notes_draft.md` | `[assumed]` | 6 | "Second user. OSBM staff ... [assumed]" |
| `drafts/claude/diagrams/report.html` | `[assumed]` | 7 | in a published-looking diagram report |
| `planning/02_framing_worksheet.md` | `[assumed]` | 6 | framing worksheet |
| `src/R/00_config.R` | `[assumed]` | 3 | thresholds (GEO_PENALTY 0.5, 21-day) |
| `handoff.md` | `[assumed]` | 2 | |
| `src/docs/fact_sheet.md` | `[assumed]` | 1 | row 13 geo penalty |
| `CLAUDE.md`, `testing/context.md` | `[assumed]` | 2 in context; CLAUDE.md several | primary user |
| `src/R/20_backtest_awards.R`, `21_audit_clearinghouse.R` | `TODO` | 1 each | |
| `saturday/README.md`, `testing/README.md` | `TODO` | 1 each | "TODO move to 00_config.R" (instruction, not a leftover) |
| `src/docs/agency_goal_summaries_noah.csv` / `_matthew.csv` | `NEEDS KENT` | 71 / 17 | review flags in data a judge might open |
| `drafts/codex/agency_plan_text_handoff.md`, `AGENTS.md`, `docs/AI_HANDOFF.md` | `NEEDS KENT` | 3 / 1 / 1 | |
| `deliverables/slide_brief_TEMPLATE.md` | `NEEDED` | 1 | the template instruction, fine |
| `data/example/` | toy data | 5 files tracked (README, 4 CSVs) | CLAUDE.md and README.md say delete before submitting; not deleted. README.md still describes them as the fallback |
| `TBD`/`XXX` | hits only in source data CSVs and plan text (opportunities, grantsgov_extract, backtest) | n/a | genuine source values, not leftovers |

## 3. Five things to finish first
1. **Write `deliverables/slide_brief.md` and a timed 6-minute talk outline** (ask, why, how, limits, next step; demo path; speaker split; pilot and scale slides; every number from `fact_sheet.md`; add backtest, label-gate and eligibility facts to the fact sheet first). Nothing exists beyond the template and the slides cannot be built without it. Owner: Kent (people/kent.md step 7); Matthew builds slides from it; Kent also fills `qa_cheatsheet.md` with Matthew/Marco.
2. **Replace `README.md` with the state-developer guide** from the draft, rewritten to Saturday state: real run order and tests, Azure deploy (verified commands only), live URL, how to make your own keys, the stated limits (baselines beat the model, small denominators, keyword fit, stale plans, daily job state), extend. Remove "hello page", "toy data", "[assumed]" from it. Owners: Marco (README, azure_setup.md; Noah writes the drafts); Kent approves and merges. Include the live URL; confirm what the URL serves after the last deploy.
3. **Judges' repo: write the snapshot script or checklist now, not at 7:00 pm.** Copy of main, no `.git`, no `api_keys.env`, no `tasks/everett_api_keys.md`, no `data/example/`, size check, plus a scan for key values; also decide link versus zip from Matthew's organizer answer (not logged). Owner: Marco (build), Kent (fallback and sign-off). Resolve the private-repo access question for judges at the same time.
4. **Finish the field notes against Saturday's reality.** Update ss1-4 (scoring, backtest, eligibility, geography and DERA map now exist), fill all `[TO FILL]`, quote the real prompts (ingestion, framing, Saturday `prompts.md`), add Azure OpenAI and Ollama to the tools list, add the Saturday AI errors with hashes, record the label gate failure (kappa 0.44 vs 0.6, gate 80% / 0.6) and mentor-log result, and state plainly that no real user feedback beyond the Discovery Session was collected if true. Owner: Noah (draft per `people/noah.md` step 5), Kent for decisions, Matthew for mentor log (due 4:00).
5. **Fix `AI_USAGE_LOG.md`**: repair the table (blank row 8 and the rows below the Notes block), add rows for the Nov 7 reviewer runs (stage judge, fact tracer, this audit, any others), turn every "human check pending" into done or not done, and add PromptLab/other-tool statement. Owner: each person for their rows; Kent merges. Also delete `data/example/` (move to `stale/`) and clear `NEEDS KENT` flags from files going to judges, after the 7:00 pm freeze if needed, owner Kent.

## 4. [cannot assess]
- Whether the Final Submission form wants a link or a file upload, and its field list (form not opened; organizer answer not logged).
- Whether the live Azure URL currently serves the Saturday tool or still the Friday Shiny proof, and whether it works on venue Wi-Fi.
- Whether the repo is private or shared with judges.
- Slide content: slides are built by another AI agent from a brief that does not exist yet.
- Whether `fact_sheet.md` rows after 14 are added later in the day (file read at 10:45).
- Quality of anything; this audit checks presence only.
