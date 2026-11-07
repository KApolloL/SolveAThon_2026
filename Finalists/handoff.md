# Handoff: Finalists

_Update this at each checkpoint (about every 6 hours) and before ending any long AI session. A fresh session reads this after CLAUDE.md._

**Last updated:** Fri Nov 6, 2026, ~11:00 am (before discovery workshop)
**Hours remaining to submission deadline (Sun Nov 8, 9:00 am):** about 46

## Goal in one sentence
[assumed, confirm at workshop] Help an agency grant coordinator find and prioritize federal funding opportunities that match their agency's strategic plan early enough to apply, with a human making the final call, deployed on Azure for OSBM. Organizer text: `docs/QUEST_BRIEF.md`.

## Status
| Piece | State (not started / in progress / done / blocked) | Owner | Notes |
|---|---|---|---|
| Quest brief saved (`docs/QUEST_BRIEF.md`) | done | Kent / Claude | Docs updated from it Fri am |
| Azure access and environment | not started | Kent | Blocker: no access confirmed yet. Read the Azure Access Guide first |
| Problem framing and user | not started | Kent | Waits for 6:30 pm workshop and 7:30 pm sprint; user is [assumed] |
| Data ingestion (opportunities feed) | not started | Kent | Grants.gov or SAM.gov live API; the qualifier already cached Grants.gov (`QualifierChallenge/data/cache/api/grantsgov/`); gate must be ticked first |
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
- Azure: subscription is `unc-sdis-solveathon-teamXX`, login `ONYEN@ad.unc.edu` plus Duo. Is Azure OpenAI pre-provisioned? Not stated in the guide.
- Who is the real user and what does the Discovery Session say changed our plan? (Field notes need this in the sponsors' words.)

## Blockers
- Azure access not confirmed.

## Discovery session
Findings and plan changes: [planning/07_discovery_findings.md](planning/07_discovery_findings.md). Organized notes: [notes/vault/Solveathon_DiscoverySession.md](notes/vault/Solveathon_DiscoverySession.md).

## Next three steps
Friday night owners and teammate AI prompts: [planning/06_tonight_plan.md](planning/06_tonight_plan.md). Marco owns Azure; Noah and Matthew check plan text; Kent owns planning.

1. Azure (Kent): log in, find the team subscription, confirm whether Azure OpenAI is available, then run the Starter Kit's setup steps. Email the three support contacts (CC all) if the subscription does not appear. Starter Kit, Azure guide, template and zip are already read: `src/docs/organizer_materials_notes.md`.
2. 6:30 pm workshop using `planning/01_discovery_questions.md`; add the brief-specific questions listed there. Then 7:30 pm sprint: fill `planning/02_framing_worksheet.md` and tick the gate.
3. Only after the gate: profile the opportunity feed and agency plans, and start the field notes file (record each sponsor-driven plan change as it happens).

## How to rebuild
(Commands to rebuild from scratch, once they exist. Model after the "Rebuild from scratch" block in `../QualifierChallenge/README.md`.)

## Checkpoint schedule
Official schedule is in the vault hub `Projects/Competitions/Solveathon/Solveathon.md`; the hour-by-hour plan is in `Solveathon_DeloitteTraining` ("Weekend plan").
- Fri 6:30 pm client discovery workshop; 7:30 to 8:45 solution design sprint (user and criteria on paper before any data); 8:45 mentor check-ins.
- Sat 9:00 check-in; 1:00 mid-day check-in (gate: working ranking); 2:00 to 4:00 mentor drop-ins; 7:00 to 8:00 wrap up = code freeze.
- Sun 9:00 am submission (slides, field notes, repo, product link, via the form); 10:00 to 12:30 presentations (6 min with demo plus 2 min Q&A per the brief; confirm).
