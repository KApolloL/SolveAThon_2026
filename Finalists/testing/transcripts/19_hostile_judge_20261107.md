# Hostile judge, Sat Nov 7 2026 (no script exists; judged as it would be pitched today)

Material: field_notes_draft.md, README.md, fact_sheet.md, qa_cheatsheet.md, backtest_result.csv, saturday/01_goals.md, planning/09_tool_plan_update.md, src/tool/matchmaker.html (contains the banner "STUB DATA: not real opportunities"), azure_setup.md. Manager-verified facts used as given. Real-user evidence: none (field notes: "No evaluation has been run and no real user has seen the tool").

## 1. Scores
| Criterion | Score | Reason |
|---|---|---|
| Understand | 2 | One discovery session shaped real decisions (time, payoff versus effort), but field notes admit no real user has seen the tool and the primary user is still [assumed]. |
| Frame | 3 | Problem, school-bus example and named weakness are clear, but the pass bar was not defended and the tool ranks on keyword fit only ("other weights 0"). |
| Solve | 2 | Azure serves a page, but the daily job is an echo stub and Azure OpenAI is "created and tested, not wired in"; Top 10s contain junk (Cape Verde embassy program for the State Auditor). |
| Evaluate | 2 | Honest enough to show a failed bar, but the denominator counts only won programs already in the top 50 and the soonest-deadline baseline beats the tool in DEQ and DHHS; fact sheet has no backtest row. |
| Drive Impact | 1 | "Ask OSBM to name one owner" is the only pilot ask; no cost, owner, success measure or scale path in any deliverable, and Pursue/Pass lives in browser localStorage only. |

## 2. Findings
| # | Where | Problem | Type | Sev | Fix |
|---|---|---|---|---|---|
| 1 | backtest_result.csv vs 01_goals "at least 50%... 2 of 3" | Tool fails its own pre-set bar (4-week: DPI 2/3, DEQ 3/7, DHHS 4/11; 1 of 3 pass or fewer). Any "it works" claim contradicts the team's own file. | evidence | high | Lead the limits slide with the miss; say bar was set before the run and not met. |
| 2 | backtest baselines | Soonest-deadline top 10 beats the tool in DEQ (71% vs 43%) and DHHS (73% vs 36%). A judge reads: "your AI is worse than sorting by date." | evidence | high | Admit it; reframe the tool's value as fit plus eligibility, and show where it adds beyond date sort, or do not claim recall. |
| 3 | `20_backtest_awards.R:79-82` | Denominator only counts won programs already in the top 50; baselines drawn from that top 50. The measured recall is an upper bound on a pre-filtered set, not recall against manual monitoring. | evidence | high | State this on the slide or drop the percent; never say "caught X%" without the denominator rule. |
| 4 | "keyword fit only, other weights 0" | Payoff-versus-effort was the sponsors' key point; the build ignores it. Deadline, award size and effort are zero-weighted. | framing | high | Say so, or turn on a minimal deadline/award weight and re-measure. |
| 5 | Top 10 examples | Auditor rank 1 is a Cape Verde embassy program; Revenue rank 1 an Air Force research call; OAH ranks 1 and 2 HUD paperwork notices. No fit floor. False positives are visible in minutes. | evidence | high | Add a fit floor so thin agencies show fewer rows (the plan already says "never padded"). Show one bad row in the pitch. |
| 6 | 61 Top-10 rows are notices the UI never shows | Table and screen disagree; user sees a different list than the one measured. | trust | high | Align UI with scored set or exclude notices from the measured set. |
| 7 | matchmaker.html "STUB DATA" banner | Demo screen may show fake data. Demoing stub data as the product is a trust failure. | trust | high | Demo only real payload.json; delete the banner path before the demo. |
| 8 | planning/09 "Daily Azure job... core cloud story" | Daily job is an echo stub and `MODE=job` not tested in cloud; Azure OpenAI unused. "Azure for a reason" is not shown. | evidence | high | Say plainly Azure hosts the page and storage; do not call the job or AI part live. |
| 9 | Pilot ask | "Ask OSBM to name one owner" with cost "computed before it goes on a slide" but none exists. No measure agreed. | next step | high | One line: 60 days, 3 agencies, named coordinator, cost per month, success = misses found vs manual list. |
| 10 | field notes line 15 | No real user feedback; personas are simulated. Understand cannot score above 2. | evidence | medium | Use only the discovery session; never cite personas as users. |
| 11 | Pursue/Maybe/Pass "never cut" | Decisions saved only in the browser; no one can see them, no feedback to the tool. Human-in-the-loop is cosmetic. | trust | medium | Say it is a prototype button; say what would be stored in a pilot. |
| 12 | Hidden-as-ineligible (3,030 pairs) | Hiding rule has no measured false-hide rate; the notice reader gate is not run. A wrong hide loses a real grant. | evidence | medium | Report hand-check of a sample of hidden rows, or say none done. |
| 13 | Fact sheet vs pitch | Fact sheet lists no backtest, recall, or eligibility accuracy row; any such number is unsupported. | evidence | medium | Add rows with reproducing scripts before the slide uses them. |
| 14 | 12 of 20 pool items picked by keywords | Circularity; pool retired but the same weakness remains in the 60 labels. | evidence | medium | Do not cite the pool. |
| 15 | Privacy | Notice reader would send notice text to Azure OpenAI; the sponsors said no sensitive data to arbitrary LLMs. Public notice text is fine, but the pitch has no sentence on it; training-use is [uncertain]. | trust | medium | One sentence: only public notice text; no agency data. |
| 16 | Missing sources | SAM.gov and USDOT not loaded; Grants.gov incomplete per sponsors. Recall against manual monitoring unanswerable. | framing | medium | Put it on the limits slide with the school bus example (which source it came from is unverified). |
| 17 | DERA lift | Program-to-agency link for DERA is [uncertain]; the gate case is hand-lifted via program_map. A hand-fixed demo case is a cherry-pick. | trust | medium | Tell judges it was hand-mapped. |
| 18 | Structure | No script. Plan content (user, problem, tool, demo, backtest, pilot, roadmap) leads with the build, not the answer. | clarity | medium | Open with the ask and what a director does Monday. |
| 19 | 6 vs 5 minutes | Still "confirm". | time | low | Confirm at check-in. |

## 3. Three worst weaknesses
1. The tool fails its own backtest bar and loses to sorting by deadline in two of three agencies, on a denominator that flatters it.
2. The visible output has obvious junk at rank 1 for several agencies because ranking is keyword-only with no fit floor, while the sponsors' payoff-versus-effort need is zero-weighted.
3. There is no pilot: no owner, cost, measure or user evidence, and the cloud/AI story (job, Azure OpenAI, feedback) is stubbed or unwired.

## 4. Eight hardest Q&A questions (weak answer in brackets)
1. Your own test says 4 of 11 DHHS programs surfaced and a deadline sort gets 8 of 11; why should OSBM fund this instead of a sorted spreadsheet? [Weak: "keyword fit is a start" or quoting a different, flattering number.]
2. Your recall only counts programs already in the top 50; what is the real recall against what a grant writer finds manually? [Weak: "we measured recall" with no mention of the pre-filter; or "we can't know."]
3. Why is the State Auditor's top match a Cape Verde embassy program, and what stops a staffer losing trust on first use? [Weak: "that's just the demo data" or "they will learn to ignore it."]
4. You pre-set 50% in 2 of 3 agencies and missed; who chose 50, and what would you have done if you had passed? [Weak: "the bar was arbitrary anyway."]
5. What exactly does Azure do here that a laptop could not, and which of those parts run today? [Weak: lists services; claims the daily job or OpenAI works.]
6. Name one real user who has seen this and what they changed. [Weak: cites personas or teammates as users.]
7. What does OSBM sign on Monday: cost per month, who owns it, what number says it worked at day 60? [Weak: "a few agencies, we'd figure it out."]
8. You hide 3,030 agency-opportunity pairs as ineligible; how many of those hides are wrong, and who sees them? [Weak: "we show a count and a toggle," with no error rate.]

## 5. What would make me vote against
- A claim that the tool "catches" or "finds" grants with no denominator rule and no mention of the failed bar or the deadline baseline.
- A demo that opens on stub data or a rank-1 row the team did not look at.
- Presenting the daily job, Azure OpenAI, or the feedback loop as working.
- Persona or teammate statements offered as user evidence.
- No concrete pilot ask (cost, owner, measure) when the final slide says "pilot".
- Numbers on slides that are not in the fact sheet.

## Time fit (no script exists)
At 130 to 150 words per minute, 6 minutes minus about 1.5 for demo is roughly 585 to 675 spoken words. The planned content (user and problem, sponsor findings, approach, eligibility, demo, backtest with baselines, limits with five items, pilot, scale roadmap) is easily 1,000+ words and will run over [uncertain]. Cut: the eligibility four-step detail, match board, per-feature tour, scale roadmap beyond one sentence, and the model-label story. Keep: ask, one bad row shown honestly, the backtest miss and its meaning, one limits slide, one pilot line. Order today: build first, answer last; reverse it.
