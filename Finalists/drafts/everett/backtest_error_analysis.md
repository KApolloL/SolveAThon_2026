# Where the v2 Top 10 would not have flagged programs agencies won (E2 draft)

> Historical note (Sat Nov 7, ~5:30 pm): this file records an earlier change and is kept as written. After the overseas-embassy filter the current values are in `src/docs/fact_sheet.md` (updated Sat Nov 7, ~7 pm, after the embassy filter, region list and tribal-title rule: Top 10 61 of 157, Top 50 98, baselines 19.7% and 14.1%, rows 26, 27, 29).

Status: draft by Everett's Claude, for Kent. Numbers come from `src/R/24_backtest_misses.R` (offline, reads `agency_award_map.csv` and `nc_awards_by_cfda.csv`, rebuilds the 4-week full pool the way `21_backtest_v2.R` does). Not in `fact_sheet.md`; **Kent adds what he wants and confirms.** Unverified by a human. Exploratory, not the pre-set bar. Program-level match favors repeat funding; there is no link from an award to a notice.

## What was checked
For the 159 won programs (12 agencies with 3+ won programs, 4-week windows) that had an open notice in the agency's full pool, I took the best rank that any notice for the program reached in any window.

| Where the best rank landed | Programs | Median windows with a notice | Median best rank |
|---|---|---|---|
| Top 10 | 58 | 6 | 3 |
| Rank 11 to 50 | 39 | 5 | 23 |
| Below rank 50 | 62 | 3 | 167 |

- After the 3 award-map promotions (Kent, Sat Nov 7) the script gives the new rows 26 and 27 values (the old values were 57 of 157 and 95 of 157): 58 of 159 in the Top 10, and 97 of 159 (58 + 39) in the Top 50.
- A typical agency pool is about 750 notices per window (median over the three groups, 677 to 777), so rank 167 is not "just outside".
- No won program was lost to a hard gate in this run: every one of the 159 has a rank. So "eligibility hidden" is **not** where these programs went, at least under today's gates. (Verified in the script output; the gate logic itself I did not audit.)

## What it suggests (inferred, not proven)
1. **Below-50 programs show up in fewer windows (median 3 vs 5 to 6).** That fits the idea that these are programs with sparse or oddly timed notices, but I did not test causes.
2. **Keyword fit is the likeliest cause, still untested.** Sample below-50 titles are administrative or off-topic for the agency's plan words, e.g. Commerce: "Training and Employment Guidance Letter", "Work Opportunity Tax Credit Additional Funding Allotments"; DACS: "FY24 Recovery Implementation"; DEQ: "Clean Vessel Act", "Geologic Mapping". These are titles, not tests. A real test needs the notice text vs the plan text for each one (a word-level check, or Noah's labels once done).
3. **DHHS is the weakest case:** 19 of its 30 won programs sit below rank 50 and 4 reach the Top 10. Worth a sentence in the weakness write-up.
4. **Timing is a weak signal, not ruled out:** measured at the best-ranked notice, 38 of 58 (66%) Top 10 programs had under 21 days left from the window end, against 32 of 39 (82%) and 48 of 62 (77%) in the other two groups. So programs that reach the Top 10 are somewhat more often in time, but most are not. This is a different measure from the in-time count in `backtest_v2_intime.csv` (42 of 58 reach the Top 10 with 21+ days left on ANY Top 10 notice), so the two numbers do not conflict but must not be quoted together. Corrected after the hostile-judge pass; the earlier wording 'does not separate' was too strong.

## Limits
- "Won" means a confirmed recipient on the award map; repeat funding inflates recall.
- Best rank across windows is generous: a program counts if it reached the list in any window.
- Small denominators: 1 to 38 programs per agency (see `outs/figures/backtest_v2_by_agency.png`).
- Cause labels above are descriptions of rank, not causes.

## Still open (from my handoff)
- Unmapped agencies: UNC campuses, Volunteerism, DIT, Adult Correction (Noah's N12 report). Not analysed here.
- Next test if Kent wants it: for the 62 below-50 programs, list the shared words between the best notice and the plan text, and tag keyword gap vs notice-text gap by hand (human check needed).
