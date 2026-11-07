# persona-osbm-sponsor, one-shot review, Sat Nov 7 2026

Simulated persona. These are hypotheses, not user evidence. Material read: field notes draft (stale, Friday), discovery findings, Saturday decisions, sat_checks.csv school bus row, backtest_result.csv, fact_sheet.md, matchmaker.html, and the DPI and DEQ Top 10 from payload.json (as of 2026-11-07T11:00).

## 1. First reaction

I asked about school buses and you came back with a diesel program, and I respect that you checked rather than faking it. But the Top 10 I clicked is mostly tribal colleges, NSF research and "Revere" educators, with "Ask" on nearly every row. Your own backtest says a plain deadline sort beats you. The document you would submit says nothing is built. I cannot tell what I would fund.

## 2. Findings

| # | Where in the material | What was unclear, wrong or missing | Type | Severity | Suggested fix |
|---|---|---|---|---|---|
| 1 | backtest_result.csv: baseline_deadline_pct 1.0 vs pct 0.5 (DPI, 2 wk) | The tool catches 2 of 4 DPI wins; sorting by soonest deadline catches 4 of 4. DEQ 33% vs 89%, DHHS 36% vs 82%. The tool loses to the dumbest baseline in 8 of 9 rows and nobody says so. Your own bar (50%, 2 of 3 agencies) is passed only by DPI, on 3 to 4 programs, CI 7% to 93%. The bar fails. | trust | high | State plainly the bar failed and the baseline wins; explain what the tool adds that a deadline sort does not (fit, eligibility), or change the claim. Do not pitch it as "catches missed funds". |
| 2 | Field notes: "Nothing in the live app has changed" | The draft you would submit (written Friday) says no scoring, no ranking, no evaluation, empty manual folder. The product now has all of these. Submitted as is, it contradicts the demo and fails the field-notes deliverable. Many [TO FILL] and a "DRAFT. Not for submission" banner remain. | next step | high | Rewrite sections 1 to 7 from Saturday decisions and fact_sheet before 9:00 Sunday. Assign a named owner. |
| 3 | DPI Top 10: "Tribal Colleges and Universities Program (TCUP)" rank 1 | The DPI list is mostly higher-ed and research (TCUP, S-STEM, REAP for health schools, Military Academy BAA, Expeditions in Computing). A school-district grant writer would reject most. Keyword fit is matching "education". The "Revere Public School Educators" goal snippet is a Massachusetts district's wording used as a DPI goal. I cannot tell if this is a plan-parsing error or a different plan. | confusing output | high | Spot-check the 10 for DPI with a person who knows the agency; fix the snippet source; add an applicant-fit check so tribal-college-only programs are not rank 1. |
| 4 | Every DPI row: "Eligible: Ask check the notice" | 10 of 10 DPI rows and 7 of 9 DEQ rows say Ask. The sponsors said the tool, not the person, must sort eligibility. 16,540 pairs are "check eligibility" against 3,030 hidden. The tool mostly hands the question back. | missing requirement | high | Report the Ask share per agency; read applicant types for the Top 10 and resolve them, or admit it is a flag, not a sort. |
| 5 | DERA in Top 10 via program_map ("66.039 lifted") | You replaced my bus example with DERA and the check honestly says the window is nearly four months, not one month, and that Clean School Bus is a different program with 0 rows. Good. But DERA ranks 1 for DEQ and 3 for DPI only because someone hand-lifted it for both; the fact sheet itself marks that link [uncertain]. A hand-tuned showcase case is the toy I warned about. Also DERA closes Jan 22, 77 days left, so it was never the "missed deadline" story. | framing | high | Say on a slide that the school bus miss cannot be reproduced from this data. Show DERA as a hand-mapped example, not a natural catch. Report where DERA ranks without the lift. |
| 6 | Fact sheet: "Open opportunities with no usable close date: 488" | 488 of 1,576 (31%) have no usable date, and 887 have no award size. Rows show a text note instead of days left. The "payoff versus effort" requirement from discovery rests on a field that is missing for 56% of items. DPI rank 10 and DEQ ranks 2 and 5 show no days. | missing requirement | medium | Show award coverage next to any payoff claim; do not rank on award where blank. |
| 7 | Backtest: "won_programs 4" for DPI | 3 to 11 programs per agency, a held-out check only, "won" defined by past NC awards. No baseline for how many are "missed" today, as I said. Intervals are 7% to 93%. These numbers cannot support any claim of catching. | trust | medium | Call it a feasibility signal on tiny counts; keep intervals on the slide. |
| 8 | Window default 14 days vs rows with 341 or 427 days left | The Top 10 ranks by fit only, so "act early" is lost: a 427-day item sits above a 12-day item. The pilot pain was short deadlines. The page offers no closing-soon view or sort. | missing requirement | medium | Add a sort by days left, or a closing-soon panel (the product plan said so). |
| 9 | Coverage: field notes "SAM.gov and the USDOT page are not loaded" | I asked about SAM.gov, DOT, foundations, earmarks. SAM catalog is still missing, DOT 403. Coverage is Grants.gov plus Federal Register notices. 104 notices are not ranked. The Top 10 shows nothing about what is absent. | missing requirement | medium | Put a visible "sources not covered" line in the tool and the Q&A sheet. |
| 10 | Title text "Atlanta FY 2021 &#8211; FY 2023 EDA Planning" | Raw HTML entities show on screen, and an Atlanta (Georgia) EDA planning grant is rank 5 for DEQ with no days and "yes" eligibility. Old FY21 to FY23 postings are listed as open. Looks unfinished and wrong; the geo penalty only catches some. | confusing output | medium | Decode entities; check stale open items; widen the other-region filter. |
| 11 | Pursue / Maybe / Pass, saved in this browser only | The buttons store decisions nowhere I can see. Nothing is shared across the cross-agency partnership, nothing feeds back, and the field notes list the feedback loop as cut-first. I cannot tell what the buttons are for. | next step | low | Remove or export (CSV); do not present as a feedback loop. |
| 12 | Hand-off: "Keep team API keys in api_keys.env, committed" and decision 10 clean repo | A state developer must pick this up. Decision 10 fixes the leak for judges, but the draft still says keys are committed. Who owns this after Sunday, and cost per month, is nowhere. | cost | medium | State owner, run cost, and key handling in the README for OSBM. |

## 3. Questions I would put to the team

1. Your deadline-sort baseline beats your tool in almost every row. Why should I fund the tool and not a calendar that lists closing dates by agency?
2. Your DPI list leads with a tribal-college program and Massachusetts-style goal text. Did any person who works at the department read that list? Who, and what did they say?
3. What would DERA's rank be with no hand-lifted program map, and how many other programs did you lift by hand?
4. What happens to the 488 items with no date and the 887 with no award size when I use this to decide what is worth the work?
5. Who at the state maintains this after Sunday, and what does it cost to run for a year?
6. What is in SAM.gov, DOT or foundation postings that this misses, and can you estimate its size rather than just name it?

## 4. What I needed that is not shown

- Any real agency staff reading the Top 10 (all persona-based so far; the field notes admit none).
- Whether the cached model labels (reader_label) were held-out checked, and the result.
- The pool-based recall test from decision 12 (earlier plan); only the award-history backtest is shown, and I cannot tell how they relate.
- Cost to date and monthly run cost.
- A real baseline for today's manual process (nobody has one; the draft should say so).
- The latest field notes; I only saw the Friday draft.

## 5. Could I state the next step?

No. The product has a plausible pilot shape (a few agencies, a named contact labelling the results), but the draft that would go in says nothing is built, the evidence shows the tool lost to a deadline sort, and no owner or cost is named. The best I can read: run a pilot with DPI and DEQ staff reading their own Top 10 for a month. The materials do not say that.
