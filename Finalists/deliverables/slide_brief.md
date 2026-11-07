# Slide brief (draft by Kent's Claude, Sat Nov 7; Kent to confirm every line)

## Constraints
- Talk: 6 minutes with a brief demo plus 2 minute Q&A, in person (earlier email said 5 plus 2; confirm).
- Audience: judges and NC government staff. Non-technical. No jargon.
- Submission due Sunday 9:00 AM: slides, Solution Design and GenAI Field Notes, repository, link to the working product.
- 6 to 8 slides, one idea per slide.
- Numbers: only those below, each from `src/docs/fact_sheet.md` (row number given). Do not invent, round differently or add figures. If something is missing, write "NEEDED" on the slide and tell Kent.

## Problem in one sentence
A grant writer at an NC state agency cannot read every open federal opportunity; the Federal Funds Matchmaker ranks them against that agency's own strategic plan, shows the plan goal each one matches, and hides what the agency cannot apply for.

## Slides

### Slide 1: The ask
- **Message:** Give each state agency a ranked, plan-matched list of open federal grants, refreshed daily.
- **On the slide:** headline; "32 agencies"; "1,576 open opportunities ranked" (fact rows 2, 3); the decision needed (NEEDED: Kent to state the ask and owner).
- **Figure:** screenshot of one agency's Top 10 (DEQ), taken from the live tool.
- **Speaker note:** Open with the answer, then show one agency.

### Slide 2: Why it helps
- **Message:** The best matches are not the ones a keyword search finds, and ineligible ones waste time.
- **On the slide:** one example: the national DERA program (Diesel Emissions Reduction Act) is the top result for DEQ and also reaches DPI (fact row 14). "3,030 agency-opportunity pairs hidden as clearly not eligible" (row 7). "16,924 marked: check eligibility, shown not hidden" (row 8).
- **Speaker note:** Say that DERA reaches DPI because of a hand-built program link that we still need to confirm (row 14 is marked uncertain).

### Slide 3: How
- **Message:** Three plain steps.
- **On the slide:** (1) Read each agency's plan and each grant notice. (2) Score how well the grant's words match the plan, drop what the agency cannot apply for, and lower grants that name another state. (3) Show the plan goal that matched, with its exact text.
- **Figure:** simple three-box process diagram, no jargon (NEEDED: teammate draws).
- **Speaker note:** An AI model only reads and labels text; it never decides the ranking or eligibility.

### Slide 4: Does it work
- **Message:** We tested it against grants agencies actually won, and the result was mixed; we say so.
- **On the slide:** "Bar set before the test: at least 50% of an agency's won programs in its Top 10, in 2 of 3 agencies." Result at 4 weeks: DPI 2 of 3, DEQ 3 of 7, DHHS 4 of 11. "1 of 3 agencies met the bar" (row 15). "A plain sort by soonest deadline scored higher in all 3" (row 16).
- **Figure:** `outs/figures/backtest_recall.png`.
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
