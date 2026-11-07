# Stage judge: Understand (Sat Nov 7, 2026)

Reviewer: stage-judge-understand. Read-only review. Simulated judge, not user evidence.

Stale statements noticed: `testing/context.md` says criteria.csv and payload.json do not exist and the tool is "planned"; both now exist. `handoff.md` status table (Fri 9 pm) still says "Problem framing and user: not started" and "goal [assumed]". `drafts/claude/docs/field_notes_draft.md:3-17` describes Friday night ("none are built"). Known from other reviewers and used, not re-derived: keyword fit is the only active weight; the UI shows only posted rows in the Top 10; Azure OpenAI and the notice reader are not wired in.

## 1. Score: 2 of 5

The sponsor evidence is real and was captured well: one discovery session, ten requirements, a plan-changes section. But the field notes show no single "before, after, quote" change that is actually built, and the shipped screen implements the fewest-questions and time-to-act points while dropping payoff-versus-effort, the sponsors' "key tradeoff". The target user is still labelled "[assumed]" in the README and handoff, and nobody outside the team has seen the tool.

Quote budget: "Payoff vs work required is the key tradeoff (E)" (`notes/vault/Solveathon_DiscoverySession.md:94`).

## 2. Evidence chain table

Discovery notes are the team's own notes, not verbatim quotes (`planning/07_discovery_findings.md:3`). Quotes below are from those notes.

| # | What sponsors/attendees said (file) | Decision it drove | Where it shows in the build | Chain status |
|---|---|---|---|---|
| 1 | "Do not ask more questions of busy users" (vault DiscoverySession:115) | Agency picker is the only required step (`saturday/02_decisions.md:15,16`); feedback button optional (`08_product_decisions.md:22`, amend. I) | `src/tool/matchmaker.html:60-61`: one dropdown, nothing else required. Feedback/Rocchio not in UI | Complete for the picker; feedback part broken at build |
| 2 | "you cannot wait 4 minutes for a prompt answer" (DiscoverySession:112) | Precomputed payload, warm replica plan (`planning/09:...` and `field_notes_draft.md:63`) | Payload is a static JSON (960 rows, `data_as_of` 2026-11-07). Cold start 38 s at min replicas 0 still open (`saturday/04_mentor_questions.md:22`) | Broken at build (min 1 replica not confirmed done) |
| 3 | "The tool, not the person, must sort for eligibility (E)" (DiscoverySession:91) | Eligibility first-class, four steps (`planning/09:...`); `criteria.csv:2` | `matchmaker.html:113-115,133`: codes only. Payload top-level: 163 no, 139 yes, 120 "ask" of 422 posted. Notice reader not wired. 28% of open items push "check the notice" to the person | Complete at decision; partial at build |
| 4 | "Payoff vs work required is the key tradeoff (E)"; "No agency will chase something with no payoff" (DiscoverySession:94-95) | `07_discovery_findings.md:22,29`; field notes row 49; but `08_product_decisions.md:12` and amend. A rank by keyword fit; `criteria.csv:4-6` set award_size, no_cost_share, runway weights to 0 | Not visible. `award_ceiling` is in the payload but not rendered. No effort signal on a row | Broken at decision (weights 0) and at build |
| 5 | Short deadlines caused the bus miss; time is the key constraint (DiscoverySession:86,108) | Days-to-act on every match (`07:32`); closing-soon panel (amend. H, L) | `matchmaker.html:78-83`: "days left" is the row headline. Closing-soon / new-since-last-visit panel not in the file; no sort by soonest | Complete for days left; broken at build for alerts |
| 6 | "A user may not know the answer to a criterion; the system should guide them" (DiscoverySession:92) | Four-step eligibility and "next step per item" (`planning/09:...`) | `matchmaker.html:115`: "check the notice" only. Signature tier is in the payload (`signature_tier`) but not shown; no next-step line | Broken at build |
| 7 | "Unclear which agency each opportunity is relevant to" (DiscoverySession:77) | Match board, "All NC" option (`saturday/02_decisions.md:15`) | Single-agency picker only; no opportunity-to-agencies view | Complete at decision (stretch); broken at build |
| 8 | "Cannot send sensitive information to a random LLM" (DiscoverySession:127) | Inputs are public only; "local model" vs Azure conflict (`07:37`) | Nothing user-typed goes to a model. Open: Azure data handling "[uncertain]" (`field_notes_draft.md:64`); Azure OpenAI not wired | Honoured by omission; the stated answer is still open |
| 9 | "Not comprehensive" Grants.gov; SAM.gov, DOT, foundations (DiscoverySession:54-60) | Also pulled Simpler, Federal Register, USAspending (`field_notes_draft.md:55`) | 61 notices in the payload, but `matchmaker.html:138` only counts them; SAM.gov and DOT not pulled | Partial; stated as limit. Whether the sponsor note caused the pull is [assumed] in the field notes |
| 10 | "Look at grants the agency has won before (E)" (DiscoverySession:99) | Award-history backtest as main evidence (`saturday/02_decisions.md:6,8`) | `nc_won_before` in payload; backtest result not shown in the UI | Complete at decision; evidence not user-visible |
| 11 | Cross-agency, no dedicated OSBM team (DiscoverySession:120) | All agencies served; pilot with OSBM-named owner (`planning/09:...`) | 32/34 agencies in the picker | Complete |
| 12 | "Ease of use came up most at the sponsors' Q&A (Marco)" (`planning/09:13`) | Proposal 1 (collapsed setup) | Not in discovery notes at all | Unsourced; cannot trace to any sponsor note |

## 3. Findings

| # | Where | Problem | Severity | Suggested fix |
|---|---|---|---|---|
| 1 | `data/manual/criteria.csv:4-6` ("award_size ... weight 0"; "off by default") | The sponsors' "key tradeoff" (payoff vs work) is the one requirement the build does not honour. Ranking is fit alone; award size and cost share exist but are zeroed and not displayed. `07_discovery_findings.md:22` says "not fit alone" | High | Show award ceiling and cost share as text on each row (no weight change needed), and say on the limits slide that payoff-vs-effort is displayed, not ranked |
| 2 | `drafts/claude/docs/field_notes_draft.md:3-17,49-63` | Understand section is built from "Not built / Decided" rows dated Friday night. No row shows an original plan, the quote, the change and a built result together. A judge reads a plan, not a lesson | High | Rewrite the table from `saturday/02_decisions.md`; keep three rows: (a) fit-only to eligibility-first, (b) 10-grant onboarding to optional, (c) grants-first to cross-agency picker. Mark each row built or not |
| 3 | `saturday/mentor_log.md` (empty rows) and `field_notes_draft.md:203-204` | No outside person has used the tool. Mentor log has no entries; the timed task (`04_mentor_questions.md:33`) is not done. Zero user observation exists for the build | High | Run the I3/I4 slot; log every pause; make one change and name it in the notes. Call them mentors, not users |
| 4 | `README.md:8`; `handoff.md` "Goal" line; `planning/02_framing_worksheet.md:90` | User is still "[assumed]" in README and handoff while the field notes say "[from notes]". The worksheet gate was ticked by Claude, with "Mentors have seen this page ... cannot verify". Judges will see three versions of the user | Medium | Pick one sentence naming the role and what is sourced vs assumed; paste it in README, slide brief, field notes |
| 5 | `planning/09_tool_plan_update.md:13` "(Marco)" | A claim that "ease of use came up most at the sponsors' Q&A" appears nowhere in the discovery notes and is used to justify proposal 1. Reviewer 06 is cited the same way. Persona output is behind a design change but not shown as user evidence anywhere I could find | Medium | Add Marco's Q&A note to the vault or remove the claim before it reaches the notes |
| 6 | `matchmaker.html:113-115` | 120 of 422 open items read "Ask: check the notice" with no guidance, contradicting "the tool, not the person, sorts eligibility" | Medium | Show the best available reason (applicant type text) and a plain next step; state the 28% as a limit |
| 7 | `07_discovery_findings.md:3` | Discovery quotes are notes by three people, not verbatim. Field notes use none as a direct quote | Low | Use "per our notes" consistently; do not add quote marks that imply verbatim |
| 8 | `07_discovery_findings.md:45-47` | Template lines still read "[cut or shrank]" and "[decision]" | Low | Fill in or delete |

Persona check (item 4): no persona statement appears as "what users said" in fact_sheet.md, qa_cheatsheet.md, deliverables or the field notes draft (`field_notes_draft.md:43` correctly disclaims). `testing/transcripts/` is cited only in planning/triage. Clean.

Constraint check (item 5), least honoured: payoff-versus-effort (finding 1). Of the five listed constraints, eligibility sorting is next (finding 6). Time and no extra questions are honoured; waiting minutes depends on an unconfirmed warm replica.

Mentor feedback (item 6): `saturday/mentor_log.md` has no rows. Nothing has been acted on.

## 4. Single change for Understand before Sunday 9:00 am

Get one real observation from outside the team (the 2:00 pm timed task, I4) on the live URL, log every pause in `saturday/mentor_log.md`, ship one change from it, and write it as a before/after row with the quote in the field notes. Pair it with showing award size and cost share on each row, so the "payoff versus work" point has something on screen.

## 5. [cannot assess]

- Whether Marco's "Q&A ease of use" remark was real; no notes.
- Whether mentors saw the framing worksheet.
- Whether a warm replica is configured (Azure state).
- Whether the deployed app differs from `src/tool/matchmaker.html`.
- `src/tool/index.html` is the old criteria tool template, not the user-facing page.
- Whether the Saturday afternoon slots have happened since the files were last saved (mentor_log last modified 10:25).
