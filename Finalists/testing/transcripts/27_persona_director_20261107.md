# persona-director one-shot review (simulated persona, not user evidence)
Material read: field_notes_draft.md (skimmed), src/docs/fact_sheet.md, data/processed/backtest_result.csv, "Pilot ask" in planning/09_tool_plan_update.md, cost lines of src/docs/azure_setup.md, src/docs/qa_cheatsheet.md. Context: testing/context.md (Nov 6 night; files win).

## 1. First reaction
I opened the fact sheet and found 14 rows of counts: 1,576 opportunities, 50,432 pairs. None of them says whether the tool finds money we would miss. The one results file I found, the backtest, shows the tool catching 27% to 67% of past awards. A plain sort by deadline does as well or better in most rows. The pilot section has no dollar figure and no owner. The Q&A sheet is blank. I cannot say yes to this yet.

## 2. Findings
| # | Where | Unclear, wrong or missing | Type | Severity | Fix |
|---|---|---|---|---|---|
| 1 | backtest_result.csv: dhhs 2 weeks, pct 0.36, baseline_deadline_pct 0.82 | The tool catches fewer past awards than the "sort by deadline" baseline in all 9 rows. DEQ and DHHS are the weakest. Nothing says why I should pay for this instead. | trust | high | State the comparison on one slide in plain words. Say what the tool adds beyond deadline sorting, or admit it does not yet. |
| 2 | backtest_result.csv: ci_low 0.067, ci_high 0.93 (dpi) | Won programs per agency is 3 to 11. The intervals span most of 0 to 1, so any "caught" number is noise. | trust | high | Say "too few cases to judge". Do not quote a percentage as a result. |
| 3 | fact_sheet.md rows 1-14 | Every fact is a count of what was loaded or hidden. No row gives an outcome (recall, hours saved, misses avoided). The backtest numbers are not in the fact sheet, so they cannot go on a slide. Several rows say "Kent to confirm". | framing | high | Add the backtest and test-pool results as facts, with the script that reproduces each. |
| 4 | Pilot ask: "Monthly cost computed from Azure list prices before it goes on a slide." | No dollar amount for a 60-day pilot or for keeping it running. It is a to-do, not an answer. | cost | high | Put a number and a range in. Azure cost lines say the $500 is an alert, not a limit. |
| 5 | Pilot ask: "Ask OSBM to name one owner. Do not invent one." | I said I will not stand up a team. The proposal asks me to name an owner with Azure and rerun-the-labels skills. It does not say what that costs in staff time or what they stop doing. | next step | high | State hours per week and which existing role could absorb it. |
| 6 | Pilot ask: "Agree the success measure before it starts." | The measure is not written. I cannot approve a pilot whose pass test is undefined. | next step | high | Write one measure, a target and a date to decide continue or stop. |
| 7 | Pilot ask: "named coordinator in each who keeps checking manually" | This adds work for three agencies and asks them to duplicate effort. It does not show the benefit to them. | missing requirement | medium | Say what a coordinator gets back in time. |
| 8 | Pilot ask: "Replaces ad hoc scanning and the survey that did not work." | No evidence on how long scanning takes today or how many opportunities were missed. | framing | medium | Cite the measured baseline from the pilot, or say it is unknown. |
| 9 | azure_setup.md: "Check Azure's data-handling documentation before anyone claims" | Whether prompts or agency data stay in state control is marked uncertain. I was told not to send sensitive data to arbitrary LLMs. | privacy or security | high | Give a yes/no answer with the source, or say what data is sent. |
| 10 | qa_cheatsheet.md: "What should the director do Monday?" | The answer is blank. So are all other rows, including "What is the biggest weakness?" | next step | medium | Fill before the pitch. |
| 11 | fact_sheet.md row 14: "program-to-agency link is [uncertain]" | A federal diesel program ranks first for DEQ and third for DPI on an unconfirmed link. If wrong, I look at a wrong top result in the demo. | trust | medium | Confirm the link or label the row as "to check". |
| 12 | field_notes_draft.md: "Those decisions came from a grilling interview with Kent, not from sponsors." | The draft says no real user has seen the tool and nothing is built. As of this file the draft predates results; I cannot tell if it was updated. | trust | medium | Update field notes to current state before submission. |

## 3. Questions for the team, hardest first
1. Why is the tool below a plain deadline sort in your own backtest, and why should I fund it?
2. What is the exact monthly cost of the pilot and of keeping it live afterward?
3. Who runs it after the weekend, and which job do they drop?
4. Do prompts or agency data leave state control on Azure OpenAI? Where is that written down?
5. How would you know in 60 days that the pilot worked? What number stops it?
6. How many real misses, like the school bus program, would it have caught in time?

## 4. Not shown
- Any dollar figure. Any named pilot owner.
- A pass/fail result on the recall target, and a statement of what the 3-11 case sample means.
- Hours saved or a current-scanning baseline.
- Any feedback from a real agency user.
- Whether Azure OpenAI data handling was checked.
- A slide deck or the demo itself.

## 5. Could I state the next step?
No. I could say "approve a 60-day pilot in three agencies plus a small one", but not the cost, the owner, the success measure or the date.
