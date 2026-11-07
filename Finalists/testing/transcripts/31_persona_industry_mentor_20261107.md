# Persona: industry GenAI mentor, Saturday 2:00 pm drop-in (simulated)

Simulated persona. Everything below is a hypothesis, not user evidence. Read: `testing/context.md` (Fri night; files win), `data/processed/backtest_result.csv`, `src/R/20_backtest_awards.R`, `src/R/helpers_rank.R`, `drafts/claude/eval/` (README, HANDOFF, model_labels/gate.txt and agreement_report.md), `saturday/02_decisions.md`, `saturday/04_mentor_questions.md`, `saturday/mentor_log.md`, `src/docs/azure_setup.md`, `drafts/claude/docs/field_notes_draft.md` (sections 6 to 7 and the unfilled list), `AI_USAGE_LOG.md`, `data/manual/program_map.csv`, `data/manual/agency_award_map.csv`.

## 1. First reaction

You asked for 20 minutes, so here is the short version. I see a TF-IDF keyword score, a local Ollama model whose check failed, and an Azure OpenAI resource that has made zero calls. Where is the AI? Your own backtest says a plain sort by deadline beats your ranker in all three agencies, and nobody has said so out loud. You are asking me about pilots. First tell me what you would cut, and what number you will stand behind tomorrow.

## 2. Findings

| # | Where in the material | What was unclear, wrong or missing | Type | Severity | Suggested fix |
|---|---|---|---|---|---|
| 1 | `backtest_result.csv`: DEQ 4wk `0.4286` vs `baseline_deadline_pct 0.714` | At 4 weeks the model gets 67% (DPI), 43% (DEQ), 36% (DHHS). Your bar (decision 7) is 50% in 2 of 3 agencies, so it fails with 1 of 3. The "sort by soonest deadline" baseline gets 100%, 71%, 73%, and beats the model everywhere. Random-10 beats it at DEQ and DHHS too. The sheet and the field notes show no pass/fail verdict. | trust | high | Lead with it: "Bar 50%, 2 of 3. We got 1 of 3. A deadline sort beats us." Put pass/fail in the CSV and in `fact_sheet.md`. Do not move the bar. |
| 2 | `20_backtest_awards.R`: "appear anywhere rank 1-50" | The denominator is won programs that appear in the tool's own top 50 for that window (`rankings_backtest.csv` is top 50 per window). Won programs the tool never ranked are not counted as misses. So recall is overstated, and the true number is lower than the failing figures above. The baselines also pick from that same top 50, so they only test ordering inside your candidate pool. | trust | high | Define the denominator as all won programs with a notice open in the window, independent of the ranker. Re-run, or label the figure "recall within our own top 50". |
| 3 | `20_backtest_awards.R`: "program level match favors repeat funding" | Won sets are 3, 7 and 11 programs (DPI/DEQ/DHHS at 4 weeks). One program moves DPI by 33 points. The Clopper-Pearson intervals run from 9% to 99% for DPI and 10% to 82% for DEQ. "Won before" is not "should have pursued", and one State agency's award history is not demand. | trust | high | Present counts ("2 of 3") not percentages. Say plainly it cannot distinguish the ranker from a deadline sort at this size. Name it as the weakness. |
| 4 | `backtest_result.csv` timestamps | `backtest_result.csv` is dated 10:25:07. `rankings_backtest.csv` and `program_map.csv` are dated 10:26:41. The log says the DERA map was added and the backtest rebuilt. I cannot tell whether the result CSV reflects the map. | trust | medium | Re-run `20_backtest_awards.R` after the last ranking change. Record the commit or md5 in the fact. |
| 5 | `program_map.csv`: "[uncertain, Kent to confirm]" | DERA appears for DEQ and DPI because a hand-written map lifts fit to 0.8. The log admits the map exists because the keyword fit missed DERA. Your named success case is a rule you wrote, not something the method found. | framing | high | Do not present DERA as the method working. Say "keyword fit missed it; a human-curated program map fixed it", and that this is the main failure. |
| 6 | `gate.txt`: "FAIL"; kappa 0.44, 60 items | The model-label check failed. It has 3 hand-"relevant" items in total (0 for DEQ), one labeler instead of the planned two, and a "recall 3 of 3" that counts model "maybe" as relevant. Kappa 0.44 on 60 items with 3 positives tells you almost nothing. The held-out check (decision 3) has not run. | trust | high | State it as: "validated on 3 positives; kappa 0.44; not shippable." Do not call the model labels labels. If you present them at all, call them "unvalidated draft" and show the 3x3 confusion. |
| 7 | `azure_setup.md`: "Model calls: none made today" | Azure OpenAI exists with two deployments and two 200 test calls. No scoring, summary or reader calls it. The labels came from a local Ollama qwen model, not Azure. The "notice reader" (decision 9) has no code I can find. The pitch claims AI-assisted workflow; the product has none. I5 on your question list asks about something that does not exist. | framing | high | Either build the smallest real use before 6 pm (below), or say on the slide: "AI is a stretch. The product today is deterministic." Judges score Azure use under Solve. |
| 8 | `helpers_rank.R`: "TF-IDF cosine ... centered per opportunity" | The fit score is a keyword match to the whole plan text, centered per opportunity. Plan text is partly OCR, and several plans are stale. The tool cannot tell a grant for the agency from a grant that shares the agency's vocabulary. A rules engine already does this. | framing | medium | Show three top-10 rows and three misses, side by side, for one agency. Say what the keyword score cannot do. |
| 9 | `HANDOFF_model_labeling_split.md`: "about 24 hours per machine" | The model-labeling job cannot finish before Sunday 9:00. The "full" run is 7 of 34 agencies on one machine, and the second machine never reported. That GPU time is spent on labels you have already said stay out of the payload. | cost | medium | Stop it. Spend the GPU and the hour on the held-out check or on the denominator fix in #2. |
| 10 | `azure_setup.md` "Not yet done": daily job is a "print-and-exit stub" | Nothing runs unattended. Who is paged when the daily refresh fails? There is no stale-data banner and no owner. Min replicas 0 means a 38-second cold start (T3). "Runs daily" is not true. | next step | medium | Say "manual refresh today", name the owner in the pilot ask, and show a last-updated date on the screen. |
| 11 | `mentor_log.md`: empty; `04_mentor_questions.md`: 6 industry/faculty questions for one slot | My slot is I4 and I5 (timed task, trust in an LLM reader), but the tool does not read notices and the timed task will find a failing ranker. The questions presume a success you have not got. | next step | medium | Replace with: "Which of these four things would you cut?" and run I4 anyway; it is real data. |
| 12 | `field_notes_draft.md` section 7, item 8 | The gate was originally written to require Clean School Bus (66.045) and the data has 0 rows. Decision 2 swapped in DERA. That is a good catch. But the gate only passes now through the hand map (#5), so the catch becomes a workaround. | trust | medium | Keep the item, then add the follow-on: "the swap was made to a program that needed a manual lift." |
| 13 | `AI_USAGE_LOG.md`: "Human check pending", "Not human-checked" | Several recent rows (program map, geography penalty, backtest rebuild) say the checking was by script only, with a human review "pending". For a state buyer this reads as AI wrote it and AI checked it. | trust | low | Fill who read what before Sunday 9:00. |

## 3. Questions I would put to the team, hardest first

1. Your own bar was 50% in 2 of 3 agencies at 4 weeks. You got 1 of 3, and sorting by deadline beats you in all three. What is the sentence on the slide, and what is the pilot for?
2. The denominator only counts won programs that were already in your top 50. What is recall against every won program with an open notice?
3. What does the AI do that a rules engine could not? Name one decision it makes in the shipped product.
4. DERA surfaces because you hard-coded it after the keyword score missed it. How many other agency-program pairs would need that, and who maintains the map?
5. Your model check failed at kappa 0.44 on 3 positives from one labeler. What do you do with a model you cannot validate, other than leave it out?
6. When a daily refresh fails, who finds out, and what does the screen show in the meantime?

## 4. Not shown to me

- Any pass/fail verdict or the in-time (21-day) results; the CSV drops those columns.
- The held-out model-label result (decision 3) and the spot-check of 30 notices (decision 9).
- Any code that calls Azure OpenAI for reading, labeling or summarizing.
- Who the labelers were for the team-labelled pool, and whether second-labeler sheets were completed.
- The agency's own time cost for chasing a false lead; I1 is unanswered.
- A recall figure against the full set of won programs, independent of the ranker.
- Whether the 10:25 backtest used the 10:26 program map.

## 5. Could I state the next step after reading it?

No. I can state what a funder would be buying only after you decide three things: (a) the backtest reported honestly as a miss, with the denominator fixed; (b) one real, small use of Azure OpenAI, or an explicit "none yet"; (c) a named pilot owner, the refresh owner, and which agency labels results. The next step the material points to is "run a pilot and measure," but it does not say with whom or against what baseline, and your baseline currently beats the product.

## What I would tell them to cut

- Cut the 24-hour model-labeling run and the "full pool labels" altogether; the gate failed and they stay out of the payload anyway.
- Cut the match board and the Refine panel and the other stretch items (decisions 11 and 12) from the story. The claim does not survive on the evidence you have.
- Cut any slide that claims AI-assisted without a live Azure call; or ship one narrow call (below).
- Cut "recall" language until the denominator is fixed. Keep "would have flagged" and counts.
- Keep: the failed bar, the deadline-sort baseline, the DERA story told as "keyword missed it, a map fixed it", and the pilot ask with named owners.

Smallest real Azure use, if there is one hour: have `gpt-4o-mini` write a one-line reason for the top 10 only, quoted from the notice, checked by the existing quote script, advisory. That is the least AI that is honestly AI.
