# Stage judge: Drive Impact, Sat Nov 7 2026
Reviewer: stage-judge-impact. Read-only except this file. Material: QUEST_BRIEF, drafts/claude/docs and diagrams, deliverables/, README, fact_sheet, qa_cheatsheet, azure_setup, planning 07 and 09, saturday/01_goals, backtest_result.csv.

Stale statements noticed or relied on: `testing/context.md` says fact sheet empty and criteria.csv missing (fact sheet now has 14 facts). `README.md:8` still says "Data sources and Azure setup are in progress". `drafts/claude/docs/field_notes_draft.md:87` pilot line still uses the retired 70%-recall pool bar; the live bar is `saturday/01_goals.md:32-36` (50%, 2 of 3 agencies, 4-week windows). `drafts/claude/docs/README_state_developer_draft.md:176` quotes "$30 to $80" from the Starter Kit, marked unverified. `planning/09_tool_plan_update.md:80-87` is a proposal, not accepted. Already established by others and not re-derived: no slide brief or outline, empty Q&A sheet, README is a hello page, backtest fails its bar and the deadline baseline beats the tool, daily job is a stub, Azure OpenAI not wired, no backtest row in the fact sheet.

## 1. Score: 2 of 5
The tool may be real, but no file holds a pilot ask a budget director could approve. The nearest text is "Ask OSBM to name one owner. Do not invent one." (a proposal, not a decision) and the cost line says "[Monthly cost] computed from Azure list prices before it goes on a slide", which has not been done.

## 2. Impact table
| Question | Answer from the files | File | Status |
|---|---|---|---|
| Who would use it | Agency grants lead or non-expert staffer; only [assumed], never confirmed. Discovery: one agency has one grant writer, another has nobody scanning. Picker covers 32 agencies | planning/07:6-9; fact_sheet #2 | weak |
| What it replaces | Ad hoc scanning and a crowdsourcing survey that failed. Not on any slide or Q&A row | planning/07:14; planning/09:83 | weak |
| Why trust it | Quote-checked reasons and "check eligibility" badge are designed. Backtest does not support trust: 4-week catches 2 of 3 (DPI), 3 of 7 (DEQ), 4 of 11 (DHHS); deadline baseline gets 100%, 71%, 73% | backtest_result.csv:3,6,9; saturday/01_goals.md:32-36 | weak (evidence cuts against) |
| What a pilot looks like | "60 days... measured in three... named coordinator in each... one small agency". Proposal only, no accepted decision, no success measure, no cost | planning/09:80-87 | weak |
| What it takes to scale | Sources named (SAM.gov, USDOT, foundations) and "minimum statewide reporting schema" is organizer text; no ordered path of 3 to 32 agencies, no owner, no feedback-loop plan | QUEST_BRIEF:90; planning/07:24 | missing |
| Running cost at pilot scale | Only proof-run numbers: about $0.12 added, about $0.054/hr active, all estimates. Pilot-scale monthly figure "$30 to $80" unverified and from the Starter Kit | azure_setup.md:138-139; README draft:176 | weak |
| Owner after Sunday | Open question; sponsors said no dedicated team. Not asked at discovery | planning/07:41; assumptions.md:39 | missing |
| Alert honesty | Honest in the internal files: "$500 is a monthly budget alert, not a hard limit" | azure_setup.md:6,30 | answered (not in any pitch material) |

## 3. Draft pilot ask (five lines)
1. OSBM funds a [needed: duration; 60 days is proposed in planning/09 but not in the fact sheet] pilot of the Federal Funds Matchmaker, open to all 32 agencies (fact #2) and ranking 1,576 open opportunities (fact #3).
2. Three agencies (Public Schools, DEQ, DHHS) each name a coordinator who keeps their manual scan running, so we measure misses against a real baseline; success measure [needed: Kent and OSBM to agree before start]; add [needed: one small agency].
3. Cost: [needed: monthly pilot cost; proof run added about $0.12, estimate, azure_setup.md:138]; spending is watched by alerts at $50, $100, $250, $400 and a $500 monthly budget, which warn but do not stop spending (azure_setup.md:6,30).
4. OSBM names one owner for the Azure app, the daily refresh and agency profiles: [needed: name or role; OSBM said no dedicated team]. Skills needed: Azure, the daily job.
5. Monday step for the budget director: [needed: who signs and by when]; the tool shows 4-week catches of 2 of 3, 3 of 7 and 4 of 11 programs and a simple deadline sort did better, so the pilot is a test of whether it adds value, not a launch. (Counts from backtest_result.csv, not yet in the fact sheet.)

## 4. Findings
| # | Where | Problem | Severity | Suggested fix |
|---|---|---|---|---|
| 1 | no `deliverables/slide_brief.md`; `planning/09_tool_plan_update.md:80-87` | No pilot ask exists in any deliverable; the closest text is a proposal with a duration but no cost, owner, or success measure | high | Kent decides the ask (use section 3), writes it as slide 1 and as Q&A row 11 |
| 2 | `data/processed/backtest_result.csv:3,6,9`; `saturday/01_goals.md:32-36` | Trust story collides with evidence: 1 of 3 agencies passes the pre-set 50% bar and the deadline baseline beats the tool in all 9 agency-window rows. A pitch saying "finds missed grants" would be overclaiming | high | Reframe as "pilot to measure", say "would have flagged", lead with honesty; add backtest row to fact sheet |
| 3 | `src/docs/fact_sheet.md:5-20`; `README draft:176` | No cost fact at all; only unverified "$30 to $80" and per-hour estimates. The pilot cost cannot go on a slide | high | Marco reads Azure Cost analysis, adds a fact row with a script or screenshot source |
| 4 | `planning/07_discovery_findings.md:41`; `drafts/claude/diagrams/assumptions.md:39` | Ownership after Sunday never asked and unanswered; the project as built needs Azure, a daily job and rerun labels | high | Ask a mentor (Matthew's I2 slot) and state "OSBM names one owner" as part of the ask |
| 5 | `src/docs/qa_cheatsheet.md:11`; `README.md:8,29` | Q&A "What should the director do Monday?" blank; README the state developer would read describes a hello page and does not mention pilot, cost or ownership | high | Fill row 11 with the ask sentence; replace README before 9:00 |
| 6 | `drafts/claude/docs/field_notes_draft.md:87` | Pilot line uses the retired 70% bar and "measured number is [TO FILL]" | medium | Update to the 50% / 2-of-3 bar and the actual result |
| 7 | `saturday/01_goals.md:38-41` | The daily refresh and closing-soon panel (the "no one notices in time" fix) are not built; a pilot's value claim rests on them | medium | Say "designed, not built" or cut the claim |
| 8 | `src/docs/azure_setup.md:193` | Demo cold start 38.2 s vs sponsors' "waiting minutes fails"; min replicas 1 not approved, cost impact not stated | medium | Marco approves min 1 and adds about $0.054/hr (azure_setup.md:139) to cost |
| 9 | `planning/09_tool_plan_update.md:78` | Privacy: Azure OpenAI data handling unread ([uncertain]); a deputy secretary will ask | medium | State "public data only; inputs not sent" or mark open |
| 10 | `QUEST_BRIEF.md:90` vs repo | Scale path / statewide reporting schema (organizer threat 4) not written anywhere; only 3 agencies have award evidence | medium | One slide line: 3 agencies, then all 32, then SAM.gov/USDOT; each step with its measure |

## 5. Next-step sentence the director would say
Currently: none. It breaks at "What do you want from me?" because there is no amount, no duration, no owner, no success measure. Sentence once fixed: "Approve [needed: amount] for [needed: duration] with three agencies measuring against their manual scan, and name one OSBM owner by [needed: date]."

## 6. [cannot assess]
- Any real user's reaction or willingness to pilot (no user evidence; only simulated personas and notes).
- Actual spend to date and the real monthly pilot cost (Azure not read).
- Whether the live URL serves the Saturday tool; slide content and talk (do not exist).
- Mentor answers on pilot shape (`saturday/mentor_log.md` unfilled; I2 not yet asked).
- What OSBM's budget director would accept as a success measure.
