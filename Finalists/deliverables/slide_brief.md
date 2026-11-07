# Slide brief (v2, Noah's Claude, Sat Nov 7 ~4:30 pm; replaces Kent's v1 draft)

Built from Noah's answers to 24 scoping questions and the printed judging rubric (`docs/JUDGING_RUBRIC.md`). The build plan, owners and open items are in `deliverables/slide_plan.md`. **Kent: confirm every line marked [confirm] before the deck is built.**

## Constraints
- Talk: **6:00 including a live demo, then 2:00 Q&A** (confirmed). In person, Sun Nov 8, 10:26 to 10:34 am. Aim to finish at 5:45.
- Five speakers, one per judging criterion (see timing table). Each handoff is one sentence, no "now I'll pass to...".
- Audience: judges, OSBM sponsors and agency staff. **Sponsors and end users are the authority on Understand, Frame and Drive Impact (3 of 5 criteria)**, so plain language first and technology second.
- Deck builder: Noah's Claude builds the .pptx in a **custom clean design**, keeping the organizer template's order (title, solution design, architecture/demo, pilot and scaling, Q&A, backup).
- Numbers: only from `src/docs/fact_sheet.md`, cited by row. Rows are still "Kent to confirm"; they may be used, and the checklist at the end lists each one for Kent. Anything missing reads **NEEDED** on the slide. Never round differently or add figures.
- Words: "would not have flagged", never "missed", for backtest results. Discovery content is "sponsors told us", never a quote. Simulated personas and mentor remarks are never "users said".

## Problem in one sentence
An agency grant lead in NC state government, often not a grants specialist and short on time, cannot read every open federal opportunity. The Federal Funds Matchmaker ranks them against that agency's own strategic plan, shows the plan goal each one matches, flags the deadline and hides what the agency cannot apply for. A person makes the final decision.

## Timing (one speaker per criterion; Starter Kit time map)
| Clock | Criterion | Slides | Speaker [confirm] |
|---|---|---|---|
| 0:00 to 0:45 | Understand | 1, 2 | Matthew (ran discovery checks and mentor slots) |
| 0:45 to 1:15 | Frame | 3 | Noah |
| 1:15 to 3:30 | Solve (live demo) | 4, 5, 6 | Marco drives and narrates |
| 3:30 to 4:45 | Evaluate | 7, 8 | Everett (owns the backtest) |
| 4:45 to 6:00 | Drive Impact | 9, 10 | Kent (states the ask) |
| Q&A | all | 11 to 15 backup | Whoever owns the criterion asked about |

## Slides

### Slide 1: Title (on screen while Speaker 1 starts; no time of its own)
- **On the slide:** "Federal Funds Matchmaker: the right federal grants to the right NC agency, in time to apply." Team Wasian: Kent, Marco, Everett, Noah, Matthew. Solve-a-thon 2026, Nov 8, 2026. Live product URL (NEEDED: final Azure URL, Marco).

### Slide 2: Who we built it for (Understand, 0:00 to 0:45)
- **Message:** We built for the agency grant lead, and for the people who would fund, approve and keep it running.
- **On the slide (user canvas, four boxes):**
  - **User:** agency grant lead. Some agencies have one person who scans Grants.gov constantly; others have nobody in charge, so everyone scans a little. Many are not grant experts.
  - **Their goal:** find the few federal opportunities worth applying for, early enough to apply.
  - **Context:** no time, short deadlines, unclear eligibility, unclear which agency should apply. A past fix (agency contacts plus a periodic survey) did not work.
  - **Around them:** funds it: OSBM (pilot budget). Approves applications: agency leadership. Keeps it running: OSBM sponsors with state IT hosting, **our proposal, not agreed** [confirm].
- **Hook (speaker only):** the school bus story: sponsors told us NC missed a first-year federal school bus deadline because nobody noticed it in time. **Any dollar amount or date: NEEDED until verified and added to the fact sheet.** Note: Matthew's check (`data/manual/sat_checks.csv`) found DERA's current window is about four months and that school bus replacement is a separate EPA program, so do not say the bus window was one month.
- **Source:** `planning/07_discovery_findings.md` (our notes, not quotes).
- **Figure:** none; the canvas is the visual.

### Slide 3: What we heard, what we changed (Frame, 0:45 to 1:15)
- **Message:** Every main design choice traces to something sponsors told us, and we wrote down what we left out.
- **On the slide (heard → changed table; figure `outs/figures/heard_changed.png`, NEEDED):**
  | Sponsors told us | So we built |
  |---|---|
  | Users don't know eligibility rules | The tool sorts eligibility: 4,758 agency-opportunity pairs hidden (clearly not eligible, or run by a U.S. embassy abroad), 16,924 shown with "check eligibility" (rows 7, 8) |
  | No time; more questions is bad | One required question (pick your agency). Everything else optional |
  | A deadline was missed because nobody noticed | Days-to-deadline on every row and a closing-soon list |
  | Nobody knows which agency should apply | All 32 agencies ranked (row 2), plus a view across agencies |
- **Left out on purpose (one line):** writing proposals, private foundations, a setup quiz, past awards in the score, AI labels in the ranking.
- **Speaker note:** Say requirements in priority order: save time, simple, eligibility, deadline, cross-agency, public data only. "Payoff versus effort" (award size, burden) is partly covered: say only what the tool does. [confirm with Kent what the score uses]

### Slide 4: How it works (Solve, 1:15 to 1:35)
- **Message:** Three plain steps, and a person decides.
- **On the slide:** (1) Read each agency's strategic plan and every open federal notice. (2) Score how well each notice matches the plan, remove what the agency cannot apply for, and lower notices aimed at another state. (3) Show the matching plan goal with its exact words, the deadline and a Pursue / Maybe / Pass choice.
- **Numbers:** 1,576 open opportunities (row 3), 32 agencies (row 2), 153 plan goals (row 19).
- **Figure:** `outs/figures/process_3step.png` (NEEDED).
- **Speaker note:** The AI only reads and labels text with a quote; it never ranks or hides anything.

### Slide 5: Live demo (Solve, 1:35 to 3:10)
- **Message:** It runs on Azure today, for any of the 32 agencies.
- **On the slide:** URL plus one screenshot as the fallback image (`outs/figures/demo_deq_top10.png`, NEEDED after the feature freeze).
- **Demo path: PLACEHOLDER.** Features are still being added. Fill in after the 6:00 pm build stop. Fixed parts:
  - Agency: **DEQ**. Start on the DEQ Top 10, which has DERA at rank 1 (row 14).
  - Must show: Azure URL in the address bar, the ranking and its reason, a hidden-ineligible example, and a person choosing Pursue / Maybe / Pass.
  - Steps: NEEDED (Marco, after freeze). Time each step and keep the total at 1:35 or less.
- **Backup:** screen recording of the same path, 90 seconds (NEEDED, Marco). Set min replicas to 1 before 8:30 am to avoid the 38-second cold start.
- **Speaker note:** Say that the DERA link to DEQ and DPI comes from a hand-made program link we still need to confirm (row 14 is marked uncertain).

### Slide 6: Architecture (Solve, 3:10 to 3:30)
- **Message:** A small, cheap setup the state can run and hand over.
- **On the slide:** diagram from feeds (Grants.gov, Simpler.Grants.gov, Federal Register, SAM.gov listings) and the 34 OSBM plans, through the R pipeline, then `payload.json`, then the Azure Container App, then the browser. Mark what is live versus planned (daily job, Blob, Azure OpenAI).
- **Figure:** `outs/figures/architecture.png` (NEEDED; organizer architecture skill, then checked line by line against what is actually deployed).
- **Messy data handled (one line):** 488 with no usable close date and 887 with no usable award ceiling are kept and labeled, not dropped (rows 5, 6). (Rubric Solve 4.)

### Slide 7: Does it work? (Evaluate, 3:30 to 4:30)
- **Message:** We tested it against grants agencies actually won, set the bar first, and it did not pass. Here is what that tells us.
- **On the slide:**
  - "Bar set before the test: at least 50% of an agency's won programs in its Top 10, in 2 of 3 agencies."
  - Result, 4-week windows: DPI 2 of 3, DEQ 3 of 7, DHHS 4 of 11. **1 of 3 agencies met the bar** (row 15).
  - "A plain sort by soonest deadline did at least as well in all 3" (row 16).
  - "Our AI labels failed a blind check, so none are used in the ranking." (`drafts/claude/docs/holdout/label_check_result.md`; no number on the slide.)
- **Figure:** `outs/figures/backtest_recall.png` (exists).
- **Optional line (exploratory, rows 7 and 26) [Kent to confirm]:** "A Claude review of our own output caught overseas U.S. Embassy grants in state agencies' lists. That was our keyword ranking, not the AI labels. One filter rule removed them, and reach rose from 58 to 59 of 159 won programs." Also fits backup slide 13 and the field notes' "AI was wrong" table.
- **Speaker note:** Use `src/docs/backtest_framing.md`. Why it still helps: the test rewards repeat funding, not new fits, and the samples are small (3 to 11 programs). The tool does what a deadline sort cannot: removes ineligible items, shows the plan goal, flags other-state items. The 50% bar is a team judgment. We did not move it after seeing the result.

### Slide 8: Weakness and tradeoff (Evaluate, 4:30 to 4:45)
- **Message:** Our main weakness is that word matching misses real fits that use different words.
- **On the slide:** Tradeoff: word matching is transparent (every match shows the words behind it) but misses synonyms. Fix: meaning-based matching on Azure, untested. In the pilot: grant leads keep their manual checks so we can measure what the tool misses.

### Slide 9: The ask: a 60-day pilot (Drive Impact, 4:45 to 5:35)
- **Message:** Fund a 60-day pilot with three agencies; this is what it replaces and how you will know it worked.
- **On the slide:**
  - **Who:** grant leads at DEQ, DPI and DHHS [confirm agencies], one each. OSBM owns it (our proposal).
  - **Replaces:** each agency scanning Grants.gov alone, and the contact-and-survey approach that did not work.
  - **Measure built in:** grant leads mark Pursue / Maybe / Pass and keep their usual manual checks; each week we report what the tool caught, what it would not have flagged, and what was pursued. Today the marks stay in the browser; saving them centrally is pilot work (say so).
  - **Cost:** NEEDED: measured Azure cost from Marco, added to the fact sheet first.
  - **Why now:** 73 Top 10 items close within 14 days, across 26 agencies (rows 17, 18).
- **Speaker note:** One sentence: "We are asking for a yes on a 60-day pilot, an OSBM owner, and three grant leads."

### Slide 10: Roadmap and risks (Drive Impact, 5:35 to 6:00)
- **Message:** Three realistic steps, each with its main risk.
- **On the slide:**
  1. **Pilot (60 days):** three agencies, weekly catch report. Risk: grant leads stop doing manual checks, so we lose the comparison.
  2. **Better matching plus saved feedback:** meaning-based matching on Azure OpenAI; Pursue / Maybe / Pass saved centrally to tune weights. Risk: the matching has not been tested yet and may not beat word matching.
  3. **Statewide and more sources:** all 32 agencies, daily alerts, more sources (agency sites like DOT, foundations). Risk: stale or vague agency plans (4 plans ended before 2026) weaken matches.
- **Close (last line spoken):** "Would you fund a pilot? A yes means 60 days, three agencies, one owner at OSBM."

### Slides 11 to 15: Q&A backup (not presented)
11. Data sources and coverage (what is pulled, what is not: SAM catalog via bulk file, DOT page blocked).
12. Eligibility rules with one hidden example and its quote.
13. AI use: where the AI was wrong and how we caught it (label check; goal-heading fit that failed on real data; 2019-date stub; embassy notices, below).
14. Stakeholders in more detail (optional stakeholder map).
15. Cost and security: public data only, keys not in the judge repo, Azure spend.

## Style (custom design)
- Clean, high contrast, one idea per slide, large type (headline 36pt or more, body 24pt or more).
- One accent color and neutral grays; check that charts read the same with the `dataviz` skill palette. Direct labels, no legends.
- No em dashes, no stock photos, no clip art. Footer: "Solve-a-thon 2026 · Team Wasian".

## Checks before submitting (Kent ticks)
- [ ] Fact rows used: 2, 3, 5, 6, 7, 8, 14, 15, 16, 17, 18, 19. Each confirmed by Kent.
- [ ] No NEEDED left on any slide (school bus figure, cost, URL, demo path, figures).
- [ ] Demo path timed at 1:35 or less, with the recording ready.
- [ ] Read aloud with all five speakers at 5:45 or less.
- [ ] Every "live on Azure" claim checked on the URL Sunday morning.
### Slide 1: The ask
- **Message:** Give each state agency a ranked, plan-matched list of open federal grants, refreshed daily.
- **On the slide:** headline; "32 agencies"; "1,576 open opportunities ranked" (fact rows 2, 3); the decision needed (NEEDED: Kent to state the ask and owner).
- **Figure:** screenshot of one agency's Top 10 (DEQ), taken from the live tool.
- **Speaker note:** Open with the answer, then show one agency.

### Slide 2: Why it helps
- **Message:** The best matches are not the ones a keyword search finds, and ineligible ones waste time.
- **On the slide:** one example: the national DERA program (Diesel Emissions Reduction Act) is the top result for DEQ and also reaches DPI (fact row 14). "4,758 agency-opportunity pairs hidden as not usable: clearly not eligible, or run by a U.S. embassy abroad" (row 7). "16,924 marked: check eligibility, shown not hidden" (row 8).
- **Speaker note:** Say that DERA reaches DPI because of a hand-built program link that we still need to confirm (row 14 is marked uncertain).

### Slide 3: How
- **Message:** Three plain steps.
- **On the slide:** (1) Read each agency's plan and each grant notice. (2) Score how well the grant's words match the plan, drop what the agency cannot apply for, and lower grants that name another state. (3) Show the plan goal that matched, with its exact text.
- **Figure:** simple three-box process diagram, no jargon (NEEDED: teammate draws).
- **Speaker note:** An AI model only reads and labels text; it never decides the ranking or eligibility.

### Slide 4: Does it work
- **Message:** We tested it against grants agencies actually won, and the result was mixed; we say so.
- **On the slide:** "Bar set before the test: at least 50% of an agency's won programs in its Top 10, in 2 of 3 agencies." Result at 4 weeks: DPI 2 of 3, DEQ 3 of 7, DHHS 4 of 11. "1 of 3 agencies met the bar" (row 15). "A plain sort by soonest deadline scored higher in all 3" (row 16).
- **Figure:** `outs/figures/backtest_recall.png` (the pre-set test). Optional second figure, exploratory: `outs/figures/backtest_recall_v2.png`. Label it "exploratory, built after the first result". Numbers (fact sheet rows 26 to 29): Top 10 reaches 59 of 159 won programs (37%), a soonest-deadline sort 19.5%, a random 10 about 14%; Top 50 reaches 63% (100 of 159). Do not say the bar passed. Tuning the text fit with held-out agencies changed nothing (row 30).
- **Speaker note:** Use `src/docs/backtest_framing.md`. Say "would not have flagged", never "missed". The 50% bar is a team judgment.

### Slide 5: Limits
- **Message:** Where it can mislead and what to check first.
- **On the slide:** Keyword matching can miss a real fit that uses different words (the named weakness; the fix, better matching, is untested). The test counts repeat funding, not new opportunities. Small samples (3 to 11 programs per agency). Eligibility "Ask" items need a person to read the notice. Model labels were not validated on the held-out check, so none ship in the ranking.
- **Speaker note:** Offer the Q&A cheat sheet.

### Slide 6: Next step
- **Message:** Pilot with a few agencies and a named contact.
- **On the slide:** decision, owner, date (NEEDED: Kent). "73 Top 10 rows close within 14 days across 26 agencies" shows the daily panel's value (rows 17, 18).
- **Speaker note:** Daily refresh status: say what is live. Do not claim a cloud refresh until it runs (see `src/docs/daily_job.md`).

## Style
- Plain words, large type, one chart per slide. No em dashes, no stock photos, direct chart labels.
- Colors: NEEDED.

## Checks before submitting
- Every number matches `fact_sheet.md`.
- 6 minutes or less read aloud, demo included.
- Slide 1 states the recommendation before the method.
