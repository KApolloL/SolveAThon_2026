# Stage judge: Frame (Sat Nov 7, 2026)

Stale statements noticed: `testing/context.md:14` says `criteria.csv` does not exist (it does, 5 rows); `:16` gives a 70% recall bar on a 20-item pool (replaced by the award-history bar, `saturday/01_goals.md:32-36`); `:13` says fact sheet is empty (14 rows now); `planning/08_product_decisions.md:19` and `planning/02_framing_worksheet.md:97` still carry the 70% pool bar; `drafts/claude/docs/field_notes_draft.md:85` still names it. `handoff.md:65` has no Saturday backtest status.

## 1. Score: 3 of 5
The framing is unusually well documented: one agreed problem, named users, a long "not solving" list, a written cut order and a bar fixed at 1:17 am before any ranking existed. But the stated problem is "miss or find late", and the committed test measures repeat-funding recall on about a dozen agencies, which does not prove it; sponsor requirements 3 and 4 (payoff vs effort) are zero-weighted, and the primary user is still [assumed].

## 2. Best one-sentence problem statement
"NC agency grant coordinators (often not grant specialists, with no time and no dedicated owner) `[planning/07_discovery_findings.md:6-8, 02_framing_worksheet.md:18]` miss or find late federal opportunities that fit their agency `[02_framing_worksheet.md:15]` because scanning Grants.gov and judging fit against strategic plans is manual and uneven across agencies `[QUEST_BRIEF.md:18]`; OSBM needs a cross-agency, AI-assisted shortlist, with eligibility sorted by the tool, days-left shown and a stated reason, so a human can decide pursue or pass before the close date `[07:19-21, 02_framing_worksheet.md:26, QUEST_BRIEF.md:54]`, and so someone can finally say how many are missed `[07:11, 07:33]`."

The narrowing is said out loud in part: open items only (`fact_sheet.md:9`), Grants.gov plus a few sources, no SAM.gov or USDOT (`02_framing_worksheet.md:62-63`). "Missed" is redefined as "the tool would have flagged this" (`08_product_decisions.md:9`), which is honest but is a narrower claim than the sponsor problem.

## 3. Requirements table
| # | Requirement | Source | Testable? | Bar fixed before results? | Checked by | Status |
|---|---|---|---|---|---|---|
| R1 | Load federal opportunity data | brief | yes | n/a | `fact_sheet.md` row 3 (1,576 open) | met |
| R2 | Agency profiles from real NC plans | brief | partly (counts only) | no bar | fact rows 1-2 (34 plans, 32 agencies) | met as count; profile quality not checked (12 agencies have 3 or fewer goals, `09_tool_plan_update.md:70`) |
| R3 | Score and rank per agency | brief | yes | no bar on fit quality | `test_cases.csv` c1-c5 (5 unit cases only) | met mechanically, quality unmeasured |
| R4 | Summarize / plain reason with quoted evidence | brief | yes (quote check) | not stated numerically | quote check; not in fact sheet | not checked |
| R5 | Simple interface | brief, discovery 2 | weakly (mentor timed task, `08:53` K) | no bar | `saturday/mentor_log.md` | not checked |
| R6 | Runs on Azure | brief hard rule | yes | n/a | `azure_setup.md` | met (hosting) per field notes; job untested |
| R7 | Public data only | brief, discovery 6 | yes | n/a | none named | not checked |
| R8 | Human decides | brief | by design | n/a | Pursue/Pass button is stretch (`01_goals.md:44`) yet listed Never cut (`:52`) | unmet/not checked |
| R9 | Sort eligibility by tool, not person | discovery 3 | yes | no bar | c4/c5; fact rows 7-8 | partly met (16,540 pairs still "check eligibility") |
| R10 | Payoff vs effort, not fit alone | discovery 4 | yes | no | `criteria.csv:4-6` weights 0 | unmet by default |
| R11 | Days left on every match, deadline in time | discovery 1, brief bonus | yes | X=21 team assumption | c2, c3 | met in display; scoring weight 0 |
| R12 | No added user questions | discovery 1-2 | yes | no | one required dropdown (`02_decisions.md:16`) | met by design |
| R13 | False positives / negatives / uneven docs / data quality | brief threats | yes | partly | backtest, thin-plan flag, "unknown" rules | partly; backtest fails |
| R14 | Backtest: >=50% of won programs in top 10, 4-week windows, 2 of 3 agencies | team (decision 7) | yes | **yes (1:17 am Sat, before ranking)** | `src/R/20_backtest_awards.R` | **unmet** (DPI 2/3, DEQ 3/7, DHHS 4/11) |
| R15 | Named cases: DERA in top 10 for DEQ and DPI, tribal-only hidden, 2099 dates unknown | team | yes | yes | fact rows 14 (f16, f17), c4 | DERA met; others not in fact sheet |
| R16 | Beyond Grants.gov | discovery 8 | yes | n/a | none | unmet, declared out of scope |
| R17 | Privacy: no sensitive data to model | discovery 7 | yes | n/a | Azure doc not read (`field_notes_draft.md:192`) | not checked |
| R18 | Handover / sustainable, cross-agency owner | discovery 5 | yes | n/a | pilot ask (`09:80-87`) | not checked |

## 4. Findings
| # | Where | Problem | Severity | Fix |
|---|---|---|---|---|
| F1 | `saturday/01_goals.md:33-36` vs `src/R/20_backtest_awards.R:79-82` | The headline test of "would not have been missed" fails, and its denominator counts only won programs already in the tool's top 50, so even the failing numbers flatter it. It also measures repeat funding on about a dozen agencies, not whether a coordinator would have noticed a new opportunity in time. | high | Say on the slide it fails; recompute the denominator over all won programs with an open notice; relabel it "reaches programs NC agencies have already won", not "misses". |
| F2 | `data/manual/criteria.csv:4-6` | Weights for award size, cost share and runway are 0; only `fit` scores. Sponsor requirement 4 (payoff vs effort) and the school-bus lesson (time) are off by default, while field notes (`field_notes_draft.md:51`) say they were "added as criteria". | high | Either turn on one default weight with a reason, or state in the notes and Q&A that they are display-only and change the field notes claim. |
| F3 | `data/manual/criteria.csv:2,4,5` | 3 of 5 rows are sourced "Team default for Nov 7 build [from notes; confirm with Kent]"; the `eligible` row is the only hard filter and it has no sponsor quote. | medium | Confirm with Kent or mark as team defaults on the slide; do not call criteria "tied to a sponsor quote". |
| F4 | `README.md:11`, `planning/03_problem_types.md:16`, `testing/context.md:8` | The primary user and the problem type are still marked [assumed] / "until the gate is ticked", though the gate was ticked (`02_framing_worksheet.md:90`) and the product is built. | medium | Replace with the confirmed user (or say it is unconfirmed) in README and context. |
| F5 | `drafts/claude/docs/field_notes_draft.md:85`, `planning/08_product_decisions.md:19`, `02_framing_worksheet.md:97` | Three files still state the superseded 70% hand-labelled pool bar and N=20; `saturday/01_goals.md:32` states the 50% award bar. Two success tests in circulation. | medium | Add "superseded by saturday/01_goals.md decision 7" at each and update the field notes success-test paragraph. |
| F6 | `saturday/01_goals.md:36` | 50% bar is "a team judgment, not derived", and the bar is on programs, not on the problem's outcome (late or missed notices). The in-time curve (X=21) exists as a goal (`:42`) but has no pass bar. | medium | Add a pass bar or state it as descriptive only; say what the award test cannot show (new, never-won programs). |
| F7 | `data/manual/sat_checks.csv:3` | The sponsor worked example ("about one month" window) is contradicted by DERA (posted Sep 25, 2026, closes Jan 22, 2027, about four months). The framing story may rest on a different program. | medium | Keep the school bus story as sponsor-reported only; do not put "one month" on a slide; Matthew to confirm Clean School Bus is the separate program. |
| F8 | `saturday/01_goals.md:44,52` | Pursue/Pass button is the only implementation of "human decides" (R8) yet appears both in end-of-build item 5 and "Never cut", while the cut order omits it. Hard rule coverage is unclear. | medium | Pick one: build it or say the decision is made off-tool; test it. |
| F9 | `src/docs/fact_sheet.md` (14 rows, none on eval) | No backtest result, no recall, no named-case pass for tribal-only or 2099 dates is in the fact sheet, although these are the committed requirements. | medium | Add facts for the three backtest counts, intervals, baselines, and named cases with scripts. |
| F10 | `planning/08_product_decisions.md:13` vs `saturday/02_decisions.md:15` | Scope claims shift (match board, qualifier features, 12 stretch items) beyond the problem; cut order is written (`01_goals.md:30,48`) but nothing records that "did the cut happen". Honesty of the cut is not yet auditable. | low | Add a "cut at 12:45" line to goals recording what was cut. |

## 5. [cannot assess]
- Whether the discovery notes match what sponsors said (only our merged notes exist; `notes/vault/` not examined).
- Whether R4 quote check pass rate, R5 mentor result, R17 privacy hold today (no files with results found in my material).
- Whether the live `criteria.csv` weights are what the deployed app uses.
- Whether Kent has confirmed the primary user after Friday.
