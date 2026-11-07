# Test breaker findings (criteria.csv does not exist; tested score.R on toy tables + real opportunities.csv)

## Test run
`Rscript tests/run_tests.R` (Finalists/src): "54 of 55 tests pass (on TOY example data)". One fail: "R and JS agree: payload.json exists (run R/10_run_ranking.R)". All inputs are toy files (items/criteria/test_cases/facts examples), so a pass says nothing about real data. 10_run_ranking.R not run (would write to repo).

## Test cases (not yet approved by Kent; known_cases_draft.csv KG1/KB1/KB2/KB3/KB4/DQ1-7 not duplicated)
case_id,type,item_id,other_id,n,filter_id,criterion_id,expected,description
T1,points_equal,363936,,,,award,unknown not 0 -> weight rescaled,DERA has ceiling so control; pair with a missing-ceiling item
T2,points_equal,HRSA-27-063,,,,award,unknown (not 0 points),ceiling listed as 0 (60 open items) must not score as lowest real award
T3,points_equal,SFOP0007154,,,,deadline,part dropped (not 1.0),close 2099-01-01 must not get full "soon" or "late" points
T4,dropped_by,HRSA-27-072,,,open,,not dropped as overdue? needs Kent rule,only posted item with past close_date (2026-09-20)
T5,dropped_by,A20AC00017,,,open,,decision needed,forecasted with close 2020-05-07; date_gte_days filter would drop it
T6,ranks_above,363936,361xxx-any-notice,,,,notice never above a dated posted match,notices have no close_date/ceiling
T7,not_in_ranking,356598,,,,,FR-FSP-24-003 is 1.06bn ceiling: must not outrank by scale clipping
T8,points_equal,edge-a,,,,soon,exactly 21 days left passes date_gte_days 21,boundary (21 is team assumption)
T9,in_top_n,any,,10,,,flag = exactly 10 per agency per window,count test; fewer than 10 passes -> flag all
T10,points_equal,any,,,,all weights 0,total 0 and tie order stated,currently orders by id alphabetically
T11,not_in_ranking,dup id row,,,,,duplicate id rejected,rank_items keeps both copies

## Data facts (real opportunities.csv, run in R)
- 6,523 rows: closed 4,947; posted 884 (context says 882, drift); forecasted 588; notice 104. No duplicate opp_id or opp_number. Duplicate titles among open: 30 (different opp_numbers, e.g. AFCP 2020 pair 322814/322815; RFA-CA-28-002 vs RFA-CA-27-002), so title de-dup would be wrong and no de-dup exists for near-twins.
- Open 1,472: ceiling NA 723, ceiling 0 = 60, no close_date 117, close >= 2030 = 70 (12 are 2099), close before 2026-11-06 = 198 (197 forecasted + 1 posted). Notices: 0 have close_date.
- Max ceiling 5.07bn; 6 rows over 1bn (FR-AMT-26-002 3.13bn). No negative values, no ceiling < floor.
- eligibility_text NA: 1,079 of 6,523. 323 titles still carry HTML entities in this file.
- EPA-OAR-OTAQ-26-01 (opp 363936): posted, close 2027-01-22, ceiling 12m, applicant_types code "25" only (so tribal/type filter must treat "25" as unclear, not ineligible).

## Failures found
| # | what I did | expected | actual | reproduce | triage |
|1| close=2099-01-01, criterion `scale` 0..1 on a Date | far-future date read as unknown | scored 1.00 "Time"; scale on a Date uses raw day count and saturates; date_gte_days passes 2099 | score.R t2 toy | solution |
|2| ceiling NA / 0 with if_missing default | "unknown", weights rescale (decision 5) | NA gets 0 points (or 0.5 with half); no rescale exists; a 0 ceiling scores same as unknown | rule_eval/evaluate_criteria | solution |
|3| all weights 0 | refuse / warn | silent total 0, "No score criteria are on", ranked by id alphabetically | weights=c(ceil=0,soon=0) | solution |
|4| criteria with only filters (no score rows) | works | crash: bind_cols can't recycle size 6 to size 0 | cr with only a filter | solution |
|5| `contains` value `State|(` | clear error | raw ICU regex error; values are regex, so "." or "(" in a value misbehaves | | solution |
|6| duplicate id in items | rejected | both kept, both ranked | rank_items(bind_rows(it,it[1,])) | solution |
|7| filter drops by label only; payload fails | n/a | dropped_by is label text joined by "; ", ids lost in ranking.csv | | solution |
|8| ties | stable tiebreak with reason | equal scores break on id string, which is arbitrary to user | | instructions |
|9| run_tests.R passes on toy data | real data tested | tests never touch opportunities.csv; payload.json test fails until ranking is run | | solution |
| - | top-10 per agency per window, "check eligibility", hide count, stale-plan warning, repeat-run identity | | not implemented in score.R (no agency or window dimension); not testable | | solution |

## Three likeliest ways to mislead
1. Missing ceiling (49%) and 0 ceiling score as lowest, burying real leads, while 2099 dates look "soonest" or "latest".
2. Forecasted items with past close dates (197) and posted-with-past date sit in the list as if live.
3. Recall measured on a 20-item pool, 12 picked by keywords, against a keyword-based fit score, flatters the tool.

## Clarifying questions
1. Is a close_date on or after 2030 treated as unknown, and who confirms a 10-item sample?
2. Does ceiling 0 mean unknown for every program type?
3. Past close_date on a forecasted item: hide, or show "date listed has passed"?
4. Should missing parts rescale weights (decision 5) or score zero/half as score.R does now?
5. Where does agency and window (top 10 per agency) live: score.R or the tool only?

## Cannot assess
criteria.csv absent, no JS tool output compared, no embeddings fit score, no stale-plan data, flag logic, hide-ineligible toggle, repeat-run identity on real data.
