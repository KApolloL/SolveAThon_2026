# Backtest keyword-gap test (task E4)

Script: `src/R/25_backtest_keyword_gap.R` (offline, run from `src/`). Output: `data/processed/backtest_keyword_gap.csv` (62 rows). Follows `24_backtest_misses.R` and the open question in `backtest_error_analysis.md`.

## What was tested
The 62 won programs (agencies with 3+ won programs) whose best 4-week rank was below 50. For each, the best-ranked notice's title and summary (`opp_text`) was tokenized with `kw_tokenize` (stopwords removed), and compared with the agency's full plan text. Recorded: tokens shared by notice and plan, the 5 most frequent shared words in the plan, the notice's keyword fit (`fit`, 0 to 1) and the median fit of that agency's Top-10 notices in the same window.

## Result
- 62 of 62 notices had fit below their agency's Top-10 median fit.
- 11 of 62 had fit of exactly 0 (the notice is no closer to this plan than the average agency's plan).
- Median fit was 0.102; median Top-10 fit was 0.540.
- Median shared tokens: 26. Median share of the notice's tokens found in the plan: 0.439.
- Counts by agency: dhhs 19, dps 13, deq 8, commerce 5, dpi 5, dacs 3, doi 3, wrc 3, ncdot 2, dncr 1.

Reading: the low rank is consistent with a keyword gap. These notices score far below what Top-10 notices score on the same measure. It is not proved to be the cause (see limits).

## Six example rows
| Agency | CFDA | Notice (best-ranked) | Best rank | Fit vs Top-10 median | Shared tokens | Top shared words |
|---|---|---|---|---|---|---|
| dhhs | 10.578 | FY 2026 WIC Infrastructure Grant | 803 | 0 vs 0.5882 | 24 of 98 | service system program cost data |
| dacs | 10.720 | Community Wildfire Defense Grant 2024 (FY25) Northeast-Midwe | 733 | 0 vs 0.3129 | 59 of 182 | forest service program strategy year |
| dhhs | 93.165 | State Loan Repayment Program (State LRP) | 69 | 0.1247 vs 0.4557 | 8 of 24 | health care program state operating |
| dpi | 10.541 | FY 2026 CN Technology Innovation Grant for Child and Adult C | 120 | 0.3073 vs 0.712 | 242 of 408 | student public state increase support |
| dps | 16.606 | BJA FY25 State Criminal Alien Assistance Program (SCAAP) | 53 | 0.2961 vs 0.5813 | 37 of 70 | service safety public program resource |
| dhhs | 16.560 | NIJ FY 2026 Invited to Apply - Novel Psychoactive Substance  | 69 | 0.004 vs 0.2766 | 7 of 28 | opportunity operation enhance identify rapidly |

The DPI row shows the other side: a high share of tokens in common (many shared words) yet fit still below the Top-10 median, so a shared-word count alone does not explain the miss.

## Hand-tag sample for Everett (10 rows, evenly spaced in the CSV, flag `hand_tag_sample`)
Read the notice and the agency's mission. Tag in the blank column: `real gap` (notice is on-mission but wording differs), `off-mission` (agency would not pursue it), or `other` (say why).

| Program | Notice | Top shared words | Everett's tag |
|---|---|---|---|
| commerce 17.245 | Change 1 to Training and Employment Guidance Letter No. 01-25: Process | state program year workforce employment | |
| dacs 15.657 | F24AS00431 FY24 Recovery Implementation | service measure resource time plan | |
| deq 81.041 | Inflation Reduction Act (IRA) of 2022: State-Based Home Energy Efficie | community program provide state support | |
| dhhs 10.579 | USDA-FNS-CN-EAG-FY26 | service improve department support promote | |
| dhhs 93.052 | Advancing State Implementation of the National Strategy to Support Fam | plan support partner supporting address | |
| dhhs 93.788 | Tribal Opioid Response | service access support program community | |
| dpi 10.579 | USDA-FNS-CN-EAG-FY26 | school student public education state | |
| dps 16.606 | BJA FY25 State Criminal Alien Assistance Program (SCAAP) | service safety public program resource | |
| dps 97.023 | Fiscal Year 26 Community Assistance Program - State Support Services E | service program ensure community reduce | |
| wrc 97.056 | Fiscal Year 2025 Port Security Grant Program | program opportunity state management associated | |

## Limits
- Fit is a relative score (centered per notice, scaled by the agency's best), so a low value can also mean the plan is thin; plan text length differs by agency.
- Shared words are crude: plural-stripped tokens, no synonyms, and common words like "program" or "state" appear in many lists.
- The best-ranked notice per program is one notice; the program's other notices were not examined.
- All 62 are below the Top-10 median by construction of being ranked below 50, so "62 of 62" is expected and is not independent evidence. The informative signals are the 11 zero-fit rows and the hand tags.
- Program-level match favors repeat funding (as in `24_backtest_misses.R`). The run prints a `NOTE: using TOY EXAMPLE data` line from shared code; I did not trace it, and the 62-row count matches the task brief, but confirm it is harmless.
- Other causes (gates, deadline timing, off-mission notices) are not excluded.
