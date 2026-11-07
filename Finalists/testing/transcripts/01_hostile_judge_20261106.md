# Hostile judge review (project state, Fri Nov 6 night)
Material: no pitch script exists, so I judged the repo against the five criteria. Time check: [cannot assess], no script; 6 min = ~780-900 words minus demo.

## 1. Scores
| Criterion | Score | Reason |
|---|---|---|
| Understand | 2 | Discovery notes exist (planning/07) but are "our notes, not verbatim quotes"; primary user is "[assumed]". |
| Frame | 3 | Brief, requirements and 15 decisions are clear; no criteria.csv, no sponsor quotes tied to fields. |
| Solve | 1 | Only built piece is a display-only Azure proof; "no scoring, ranking or LLM". Ranking has not run. |
| Evaluate | 1 | Labels, pool and backtest all unbuilt; fact_sheet.md has one empty row. |
| Drive Impact | 1 | No pilot shape, owner, cost or budget ask; "who owns it after Sunday" not asked. |

## 2. Findings
| # | Where | Problem | Type | Sev | Fix |
|---|---|---|---|---|---|
| 1 | handoff status table | Nearly everything "not started" ~36h out; Sat 1 pm gate is a working ranking | evidence | high | Cut to one agency x one window now |
| 2 | app/app.R "Display only" | Azure used as a host only; no OpenAI, no job, no Blob use shown | Solve | high | Show one real Azure service doing real work |
| 3 | data/manual/ empty; score.R needs criteria.csv | Method engine exists but no criteria, so no result | evidence | high | Write criteria.csv from sponsor quotes first |
| 4 | context "70% recall in top 10" | Pool of 20 per agency, 12 picked by keywords, ranker is keyword: circular; one item moves recall 5-10 pts | evidence | high | Report counts, CI-ish range, random-stratified items |
| 5 | context "missed" | Could be read as agency never saw it; only means "tool would flag" | trust | high | Say "would have flagged" everywhere |
| 6 | Scale/plans | 4 of 34 plans stale (Commerce FY21-23), DHHS/DOT/Agri thin; uneven documentation is a named threat | evidence | med | Show per-agency confidence |
| 7 | handoff: Azure OpenAI "not pre-provisioned", privacy "[uncertain]" | Privacy answer conflicts with earlier "local model" note | trust | high | Decide: keyword-only + no user data to LLM, state it |
| 8 | api_keys.env committed | Keys in git; repo "private" yet judges need access | trust | med | Rotate, remove, use Azure env settings |
| 9 | Qualifier reuse | Qualifier README says rules live in tiering.js; Finalists plan makes tier a "second axis" but no tier code in Finalists | framing | med | Cut the second axis unless it ships |
| 10 | Feedback/Rocchio, closing-soon panel, daily job, embeddings | Scope far above 36h capacity | time | med | Follow cut order; drop Rocchio |
| 11 | 6,523 rows, 723/1,472 open lack award ceiling; 70 bad close dates | "Payoff vs effort" rank rests on missing data | evidence | med | Show "unknown payoff" treatment |
| 12 | "school bus" window "about one month" unverified | Worked example may not survive a fact check | evidence | med | Verify or drop |
| 13 | Rate/time: R Shiny on Container Apps untested | Waiting minutes fails sponsor requirement | Solve | med | Precompute; test latency |
| 14 | Qualifier is complete (57 top rows, 24 facts check) | Qualifier numbers risk leaking into finals slides | clarity | low | Keep separate; fact_sheet only |

## 3. Three worst weaknesses
1. Nothing that answers the problem runs yet; the only live artifact displays a table.
2. The success test (70% recall) is built on a tiny, keyword-biased, self-labelled pool and a keyword ranker, so it cannot be believed.
3. No evidence real users shaped it and no pilot/owner/budget answer for OSBM.

## 4. Eight hardest Q&A questions
1. Show me one opportunity NC would have missed that your top 10 flags. (Weak: "the school bus one" without dates or a ranking run.)
2. Why 70% recall, and why 20 items per agency? (Weak: "it's a reasonable bar.")
3. Your labels came from your own team and keywords; how is that not circular? (Weak: "we double-labelled.")
4. What does Azure do here that a spreadsheet would not? (Weak: "it hosts the app.")
5. What goes to the model, and does Azure OpenAI train on it? (Weak: "it's public data" or "I think not.")
6. Which agencies get bad results because plans are stale or thin? (Weak: "a few.")
7. Who runs this in July and what does it cost? (Weak: "OSBM could.")
8. A busy staffer sees 10 items; what happens if the 11th is the one? (Weak: "they can widen the window.")

## 5. Vote against if
It demos a table without a ranking, claims recall without counts and the pool bias, calls team labels truth, or has no owner/cost/pilot answer.

## Clarifying questions for team
1. What is the minimum ranking you will have by Sat 1 pm gate, and for which agency?
2. Will the model (Azure OpenAI) be used at all, or is keyword fit final?
3. Who is the named pilot user and sponsor-quote evidence you can cite?
4. What do you say about repo access and committed keys?
5. What is the pilot ask (owner, cost, scope) for OSBM?
