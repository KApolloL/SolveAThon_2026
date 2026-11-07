# OSBM sponsor review (persona, one-shot). Simulated persona, not user evidence.
Basis: handoff.md (Fri ~9pm), planning/07 and 08, context.md, QUEST_BRIEF, app/app.R, eval README, fact_sheet.md, qa_cheatsheet.md, azure_setup.md, QualifierChallenge handoff.

## Findings, ranked
1. Nothing that serves my goal is built yet. The live Azure app (app/app.R) is display only: counts and a table. No scoring, ranking, profile or reason exists. fact_sheet.md and qa_cheatsheet.md are empty templates; data/manual/ is empty (no criteria.csv). Plan is credible on paper; I am judging a plan.
2. Missed-opportunity claim has no baseline. Decision 2 and amendment J define "missed" as "the tool would have flagged it". I asked for a baseline. A backtest over closed items shows retrieval of items a labeler calls relevant; it does not show what agencies missed. Do not call it "catches that manual monitoring missed". Also recall is measured on 20 team-labelled items per agency (one item = 5-10 points), 12 of 20 keyword-picked, so a 70% pass is weak evidence.
3. Coverage is Grants.gov only. 6,523 rows, Grants.gov plus a mirror (Simpler added 0). SAM.gov, DOT, foundations, earmarks are out, and I named them. The pitch must say the "missed" number is a floor, bounded by one source, and show a pilot path to add sources. Also the Federal Register notice pull has unknown recall.
4. The school bus case is an anecdote not yet a test. CFDA 66.045 is [uncertain], application window unverified, and it is listed as a gate item. If the tool does not rank it for DPI/DEQ, the sponsor story collapses; if it does, that is one case, not a rate.
5. Quality of applications is unaddressed. I asked for fewer misses AND high-quality applications. Draft help is stretch only. Pitch needs one line on how a flagged lead becomes a better application (eligibility, effort, tier), else it is only an alerting tool.
6. Adoption and ownership are thin. I said no dedicated OSBM team. Handoff lists "who owns it after Sunday" as not asked. Stack is R Shiny plus a JS tool plus Azure OpenAI, Container Apps, Blob, daily job, Rocchio feedback: a lot of moving parts for a cross-agency partnership with staff turnover. Weekend-fit signs: 15 decisions plus 12 amendments, 7-item cut order, feedback endpoint. Cut scope; harden the table, quote check, daily job.
7. Fit is keyword/TF-IDF against strategic plans. Plans are stale or thin for Auditor, Elections, Wildlife, Commerce (FY21-23), DOT unlabeled, DHHS partly OCR. Smaller agencies (my target) have the worst plans. Say so; the warning badge is the right move.
8. Privacy: Azure OpenAI is not provisioned, training/retention terms uncited. Honest [uncertain], fine; do not claim privacy on a slide before reading the docs.
9. Trust details good: quote check, LLM never decides, "team-labelled", unknown never defaults to Tier 1. 70 far-future dates, 723 of 1,472 open items without award ceiling: ranking on "payoff" will be half-blind; show it.
10. Housekeeping: 5 vs 6 minute talk unresolved; repo private and judge access unresolved; api_keys.env committed (they note private; risky if mirrored to judges); Marco's branch needs main merged; default 2-week window versus the 21-day in-time test means default view cannot be "in time" for short windows by design; say that.

## Strengths to keep
Sponsor-driven changes recorded (payoff vs effort, eligibility, fewer questions); honest weakness (recall vs shortlist length) measured; in-time vs all catches curve speaks to my deadline problem; daily refresh and closing-soon panel are the right adoption features.

## Five clarifying questions
1. What is the baseline for "missed": do you have any agency's own tracked list (even DPI's school bus history) to compare, or will you state recall only against team labels?
2. How will the pitch handle the coverage gap (SAM.gov, DOT, foundations, earmarks), and what is the pilot step to add them?
3. Who owns and runs this after Sunday, and what skills must that person have (R, Docker, Azure OpenAI, labeling)?
4. How does a flagged lead turn into a better application, beyond a short list and tier?
5. If the final ranker is keyword-only (embeddings cut), does the Azure requirement still add value I should pay to pilot?
