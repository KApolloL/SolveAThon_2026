# Non-grants staffer review (one-shot persona; simulated, not user evidence)

Material: Finalists/app/app.R (Azure proof), planning/08_product_decisions.md, Finalists/README.md, QualifierChallenge README, outs/top_results.csv, grant-triage-tool.html (index.html/ui.js text).

## Findings, ranked (where I stop or leave)
1. Finalists app shows nothing I can use. It is a 6,523-row raw table with column filters, "MODE = app", "Display only: no scoring". No agency picker, no short list, no days left, no "can my agency apply". I leave in seconds.
2. No first step anywhere. Rows give a link to simpler.grants.gov, nothing like "call X / do Y this week". The README/decisions never say what a staffer does after finding an item.
3. Qualifier tool front page asks me questions I cannot answer: "Usable runway", "Can I commit matching funds?", "Staff for a new application (FTE)", "Minimum award", "Reference date", "appropriation", "burden", "Impact score weights". I stop at the first control. Defaults exist but they are not explained as safe to ignore.
4. Jargon never defined: forecast/forecasted, cost share, cooperative agreement, ceiling, FTE, Tier 1-4, "whose signature", "restricted", "screened out", CFDA, applicant type, recall, window. "Tier 1: writer can act" assumes I am a grant writer; I am not.
5. Eligibility is not a plain yes/no up front. Plan says "check eligibility" for unclear items; I will not guess, and "state agency can apply" is buried in a long rationale string.
6. Too much on screen: scenario box, presets, examples, chips, three collapsible panels, piles, Tier 4, "Everything the tool is not showing". I cannot tell which is my short list.
7. Plain reasons are dense: rationale strings are dot-separated fragments ("139 days to deadline · about $7.5M per award (estimated: total / expected awards)"). Days left is there but not the headline.
8. Deadlines unreliable for me: far-future/"rolling or no date listed", forecasts with no real close date; a forecast in my list looks like something I can act on today.
9. Written for graders, not me: product plan talks about recall, backtests, Rocchio, embeddings. Nothing says what the tool is for in one line for a once-a-month user, or how to get my agency into the picker if it has stale/thin plan data.
10. Two products (qualifier DHHS tool linked from Finalists app) with different audiences; unclear which one to open. Googleapis font and website links need internet; fine.

## Clarifying questions
1. Is the monthly user supposed to open one screen and see 10 items for their agency with zero setup? If so, which screen is that today?
2. Who tells a non-grants person the first step (who to email, which form, who signs)? Is that in scope?
3. Can eligibility be one word ("Yes / No / Ask") before anything else, and what does "Ask" mean they should do?
4. Should the tiers be renamed for non-writers (e.g. "you can start now / needs your boss / needs leadership")?
5. Do forecasts belong in a default list for me, or only behind a toggle with a "not open yet" label?
