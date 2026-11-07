# Q&A cheat sheet (DRAFT by Noah's Claude, Sat Nov 7)

For Kent to review and move to `src/docs/qa_cheatsheet.md`. I did not edit that file (it is Kent's).

**Rules used.** Every number is a fact-sheet number (`src/docs/fact_sheet.md`, cited as "F#") or the answer says "not found". All fact-sheet rows are still "Claude; Kent to confirm", so confirm them before rehearsing. Other claims cite the repo file they come from. [assumed] means a team judgment, not derived. [from notes] means our own discovery-session notes, which are paraphrase, not a user quote. Simulated reviewers are not user evidence and are not used here.

Format: 6 minutes with demo plus 2 minutes Q&A (confirm with an organizer; an earlier email said 5 plus 2).

## Evaluating (expect the most pressure here)

| Likely question | Short answer | Backing | Who |
|---|---|---|---|
| What is your biggest weakness? | Our own test failed. On award history, only 1 of 3 agencies reached the 50% bar we set beforehand (DPI 2 of 3 programs, DEQ 3 of 7, DHHS 4 of 11), and a soonest-deadline baseline beat us in all 3. | F15, F16; bar fixed before the run in `saturday/02_decisions.md` #7 | Kent |
| Then why should we fund it? | The tool does not rely on that number. It shows the rule, the plan goal it matched and days left for each row, so a person can check every match in seconds. The backtest says the ranking alone is not enough, which is why a person decides. | F15; `docs/QUEST_BRIEF.md` (humans decide) | Kent |
| Where did you get 50%? | It is a team judgment, not derived. We fixed it before looking so we could not move it after. | F15 says "team judgment, not derived" | Everett |
| How good is the backtest? | Weak evidence. Counts are programs, not notices, program-level matching favors repeat funding, and the intervals are wide. | F15 | Everett |
| Did you try to improve it after it failed? | Yes, as exploratory work, labelled as done after seeing results, so it is not a pass of the bar. On a wider test over all 159 won programs (18 agencies mapped by exact name, 12 with 3 or more wins), the Top 10 reached 58 of 159 (36%), against 17% for a soonest-deadline sort and about 13.5% for a random 10. 4 of those 12 agencies were at or above 50%. | F26, F28, F29 (F27: Top 50 reaches 97 of 159, 61%) | Everett |
| Did tuning the text match help? | No. We tried 9 settings; the best reached 63 of 159 against 58 for the current one, and no setting beat the current one on held-out agencies in both directions, so we changed nothing. Removing the centering across agencies would drop it to 41 of 159. | F30 | Kent |
| Do the AI labels work? | Not well enough to rely on. The local model failed our agreement gate on the first set and again on 30 blind items. The two people labelling also disagreed often, so the hand labels are noisy too. Labels never enter the ranking and are not in the demo. | Gate result in `drafts/claude/docs/holdout/label_check_result.md`; **the figures are not in the fact sheet, so say no numbers aloud until Kent adds them** | Noah |
| Where was the AI wrong? | See `drafts/claude/docs/field_notes_draft.md` section 7: the known-good test case (Clean School Bus, CFDA 66.045) had no rows in the data, and the model labels failed the gate. | Field notes section 7 | Noah |
| What about false positives? | A wrong match costs a coordinator a quick look, because each row shows its rule and goal snippet. We show "check eligibility" instead of guessing, and hide only clear no's (a text no carries the exact quote). | F7, F8 | Kent |
| What about false negatives? | This is the real risk and our backtest is the only measure we have. In a pilot, keep the manual monitoring running beside the tool and measure what it misses. | F15; brief names this as the mitigation (`docs/QUEST_BRIEF.md` threats table) | Kent |
| What did you hide, and can I see it? | 3,030 agency-by-opportunity pairs were hidden as clearly not eligible. The tool keeps examples visible so a person can disagree. | F7; payload has hidden examples (F11) | Marco |
| What did you assume without proof? | The 14-day closing-soon line, the 0.5 geography penalty for titles naming another state, and the DERA link to DEQ and DPI. DERA's program-to-agency link is [uncertain]. | F13, F14, F17; `saturday/gate_check_1245.md` says Kent confirmed the penalty, the DERA floor and the DPI link | Kent |

## Understanding and Framing

| Likely question | Short answer | Backing | Who |
|---|---|---|---|
| Who is the user? | A grants lead at one agency, often one person with no time and sometimes no dedicated role. [from notes] | `planning/07_discovery_findings.md` | Matthew |
| Did you talk to real users? | We joined the organizers' discovery session on Friday and our notes shaped the build (time is the constraint; fewer questions; show a deadline on every match). We did not run user tests with agency staff. Say so plainly if asked. | `planning/07_discovery_findings.md`; `testing/README.md` says simulated personas are not user evidence | Matthew |
| What did the session change? | Rank on what is worth the effort, not fit alone; make eligibility a visible step; show days left everywhere; cut the onboarding ranking. | `planning/07_discovery_findings.md` | Matthew |
| What is the decision the tool supports? | Which open federal opportunities this agency should look at first, early enough to apply. A person makes the final call. | `docs/QUEST_BRIEF.md` | Kent |
| Why is Grants.gov alone not enough? | It is not comprehensive: other agencies post separately. We also pull Simpler.Grants.gov, Federal Register notices and USAspending past awards, and add the SAM program catalog for statutory authority. We did not load SAM postings or the USDOT page. | `field_notes_draft.md` row on sources; `src/R/05b_sam_listings.R` | Noah |
| Why 32 agencies when OSBM has 34 plans? | The State Board of Education plan folds into DPI, and Guiding Principles was a duplicate of it. | F1, F2; `saturday/02_decisions.md` #8 | Kent |

## Solving (what it does, and Azure)

| Likely question | Short answer | Backing | Who |
|---|---|---|---|
| What does it do today? | For each of 32 agencies it ranks 1,576 open opportunities, shows a top 10 with days left, eligibility and the matched plan goal, and flags what closes within 14 days (73 rows across agencies). | F2, F3, F17 | Kent |
| How big is the work? | 50,432 agency-by-opportunity pairs scored. | F4 | Kent |
| How does it rank? | Keyword fit between each opportunity and the agency's own plan goals, with eligibility rules and a halved score when the title names another state (40 opportunities). No AI decides the rank. | F13; `saturday/02_decisions.md` #11 | Kent |
| What data is missing? | 488 open opportunities have no usable close date and 887 have no usable award ceiling. We say "rolling or no date listed" instead of guessing. | F5, F6 | Kent |
| Why is it on Azure? | Required. Hosting is in the provided subscription. What we spent and the cold-start time: not found (Marco to supply). Whether Azure OpenAI is ours to use: not confirmed in the repo. | `src/docs/azure_setup.md`; field notes TO FILL | Marco |
| Is any private data sent to a model? | The data is public opportunities and public agency plans. Our privacy statement for sponsors is not written yet: not found (Marco and Kent). | `planning/07_discovery_findings.md` conflicts section | Marco |
| Can another agency reuse it? | Each agency's goals come from its own plan, held in one table (`src/docs/agency_goal_summaries.csv`, 158 goal rows per `handoff.md`), and the rules are in `data/manual/criteria.csv`. How much work a new agency takes: not tested, so do not claim ease. [uncertain] | `handoff.md`; `Finalists/CLAUDE.md` | Kent |

## Driving Impact

| Likely question | Short answer | Backing | Who |
|---|---|---|---|
| What should the director do Monday? | Pick two or three agencies for a pilot, name one contact in each to review results, and keep manual monitoring running alongside so we can measure what the tool misses. | `field_notes_draft.md` named weakness paragraph; brief threats table | Kent |
| What does it replace? | Nothing yet. It adds a first pass beside what coordinators do now. A person decides. | `docs/QUEST_BRIEF.md` | Kent |
| Why trust it? | Every row shows the rule, the goal it matched and a snippet. Any AI text that ships carries a quote that a script checks against the source. Our own test failed and we show it. | F15; decisions #9 | Kent |
| What would a pilot cost? | Not found. We have no cost estimate beyond the Azure budget alerts. Do not give a figure. | `planning/` has none | Marco |
| How does it keep fresh? | A daily job refreshes and rescores from cached data and stamps "data as of". It re-scores cache only and does not fetch new postings. | `src/docs/daily_job.md`; `saturday/gate_check_1245.md` | Marco |
| What happens when plans go stale? | Some plans are old, and the ranking inherits that. The stale-plan count is not in the fact sheet, so do not quote one. [uncertain] | `handoff.md` data setup notes (names the stale plans) | Kent |

## Likely curveballs

| Likely question | Short answer | Backing | Who |
|---|---|---|---|
| Is the DERA result cherry-picked? | DERA is our named test case. It ranks 1 for DEQ and 3 for DPI, but only because a hand-made program map lifts it, and that agency link is [uncertain]. | F14 | Kent |
| Your baseline beat you. Why not just sort by deadline? | Both are true. On our pre-set test (4-week windows, 3 agencies) the soonest-deadline baseline beat us in all 3. On the wider exploratory test over all 159 won programs, our Top 10 reached 36% against 17% for deadline order, but that test was built after we saw the first result, so it is not a pass. Our value is the matched goal, the rule and the eligibility flag beside the deadline. | F16 (pre-set test); F26, F29 (exploratory test, do not quote as the bar) | Kent |
| Did you use AI to build this? | Yes. Every use is logged with what a human checked. | `AI_USAGE_LOG.md` | Marco |
| What would you build next? | Use the pilot to learn from real labels, retune with them, and add the missing sources (SAM postings, USDOT). | `field_notes_draft.md` | Kent |

## Open items before rehearsal
- Add the label-check numbers to the fact sheet or keep them out of the talk (Kent).
- Cost spent and cold-start time (Marco).
- Privacy statement for sponsors (Marco, Kent).
- Whether Azure OpenAI is ours (Matthew asked organizers).
- Count of stale plans from a script (not found).
