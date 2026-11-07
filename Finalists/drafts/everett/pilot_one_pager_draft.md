# Federal Funds Matchmaker: pilot ask

Draft by Everett's Claude for Kent. Unverified by a human. Numbers are from `src/docs/fact_sheet.md` (row in brackets). Anything not in the repo is a placeholder.

## The ask
Approve a [proposed: 3-month] pilot of the Matchmaker with [proposed: 3 agencies, see Pilot shape], staffed by [to decide: cost and staffing are not in the repo].

## Who uses it
An agency grant coordinator, who sees a ranked list of open federal grants for one agency, with the plan goal each one matches. OSBM is the sponsor. [assumed: user role, per CLAUDE.md]

## What it replaces
Reading every open notice by hand. The tool ranks 1,576 open opportunities [row 3] for 32 agencies [row 2] and hides 3,030 agency-opportunity pairs that are clearly not eligible [row 7]. Items that close within 14 days are flagged: 73 Top 10 rows across 26 agencies [rows 17, 18].

## Why trust it, and why not too much
- A person decides. The AI model only reads and labels text; it never sets the ranking or eligibility.
- Every match shows the plan goal it came from, in the plan's own words. [unverified: not checked against the live tool]
- Test against grants agencies actually won (exploratory, built after we saw the first result): the Top 10 reached 58 of 159 won programs (36%); a soonest-deadline sort reached 17% and a random 10 reached 13% [rows 26, 29]. The Top 50 reached 61% [row 27].
- The test we set in advance failed. The bar was 50% of won programs in 2 of 3 agencies; only 1 of 3 met it [row 15]. A deadline sort beat us in all 3 on that test [row 16]. We did not change the bar.
- Limits: the test counts repeat funding, which favors programs an agency already wins, and cannot reward a new good fit. Samples are small. Keyword matching can miss a real fit that uses different words; better matching is untested.

## Pilot shape
- Agencies [proposed by Claude, Kent to confirm]: three that differ on purpose, because the backtest is small and mixed: one where award-history backtest looked strongest (for example NCDOT or Wildlife Resources), one in the middle (for example Public Safety), and DHHS as the hard case, where it looked weakest. Those agency-level counts are in `backtest_v2_result.csv`, not the fact sheet [not for speech]. The tool already covers all 32 [row 2].
- Length [proposed]: about 3 months, long enough to see several 4-week windows of new notices. Not derived from data.
- Measured (proposed, Kent to confirm): how many Top 10 items the coordinator opens, pursues or rejects and why; any real opportunity the tool did not show (false negatives); time saved against the coordinator's current routine. No targets are set here, because none are in the repo.
- Daily refresh: [unverified] do not claim it is live until it runs (`src/docs/daily_job.md`).

## Scale path
Pilot agencies first, then the other agencies in the tool [row 2]. Before widening, test better matching (embeddings) and confirm the program-to-agency links, such as the DERA link, which is marked uncertain [row 14].

## Next step
- Decision [proposed]: the OSBM budget director approves or declines a 3-agency, 3-month pilot, after seeing this page.
- Owner [to decide]: an OSBM staff lead plus one grant coordinator per pilot agency. Names are Kent's.
- Date [to decide]: no date is in the repo; set after the Sunday pitch.
