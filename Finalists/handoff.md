# Handoff: Finalists

_Update this at each checkpoint (about every 6 hours) and before ending any long AI session. A fresh session reads this after CLAUDE.md._

**Last updated:** Fri Nov 6, 2026, ~9:00 pm (Marco's Azure update; the rest of this file is from ~11:00 am, before the discovery workshop)
**Hours remaining to submission deadline (Sun Nov 8, 9:00 am):** about 36

## Goal in one sentence
[assumed, confirm at workshop] Help an agency grant coordinator find and prioritize federal funding opportunities that match their agency's strategic plan early enough to apply, with a human making the final call, deployed on Azure for OSBM. Organizer text: `docs/QUEST_BRIEF.md`.

## Status
| Piece | State (not started / in progress / done / blocked) | Owner | Notes |
|---|---|---|---|
| Quest brief saved (`docs/QUEST_BRIEF.md`) | done | Kent / Claude | Docs updated from it Fri am |
| Azure access and environment | in progress | Marco | Logged in; team subscription `unc-sdis-solveathon-team15`; East US. Created: storage `ffmdatateam15` + container `ffm-data`, `ffm-logs`, registry `ffmacrteam15`, env `ffm-env`. NOT yet: Azure OpenAI, container app/URL, budget alerts. Hello app written in `app/`, not built. Spending limit is $500. Plan for Sat: [src/docs/azure_setup.md](src/docs/azure_setup.md) |
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
- Keys: Simpler and SAM keys were pasted in chat by Kent and used once through environment variables; they are in no file. Put them in `.Renviron` yourself if you need reruns; cached reruns need no key. Consider rotating both because they sit in the chat transcript.
- Blob upload (`ffm-data`) not done; waits for Marco.
