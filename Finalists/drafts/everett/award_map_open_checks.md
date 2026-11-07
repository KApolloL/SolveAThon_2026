# Award map: the open checks, answered (E8 draft, Everett's Claude, for Kent)

> Historical note (Sat Nov 7, ~5:30 pm): this file records an earlier change and is kept as written. After the overseas-embassy filter the current values are in `src/docs/fact_sheet.md` (updated Sat Nov 7, ~7 pm, after the embassy filter, region list and tribal-title rule: Top 10 61 of 157, Top 50 98, baselines 19.7% and 14.1%, rows 26, 27, 29).

Status: web lookups, all [uncertain] until Kent confirms. UPDATE: Kent chose "apply all three" (Sat Nov 7). The three rows are now confirmed in `agency_award_map.csv` and the backtest scripts were rerun; see the last section. DIT stays uncertain. Exploratory backtest; program-level match favors repeat funding.

| Open check | Finding | Source | Proposed map change |
|---|---|---|---|
| Division of Employment Security inside Commerce? | Yes. Created within the Department of Commerce, under the Assistant Secretary of Commerce (N.C.G.S. 96-3; S.L. 2011-401). | [NC General Statutes 96-3 (Justia copy)](https://law.justia.com/codes/north-carolina/2016/chapter-96/article-1/section-96-3/), [S.L. 2011-401](https://www.ncleg.gov/EnactedLegislation/SessionLaws/HTML/2011-2012/SL2011-401.html) | `DIVISION OF EMPLOYMENT SECURITY` to `commerce`, confirmed (5 awards in recipients file) |
| Division of Motor Vehicles inside NCDOT? | Yes, a division of NCDOT. Sources found were mostly Wikipedia mirrors; official ncdot.gov page not opened [unverified]. | [Wikipedia: NC DMV](https://en.wikipedia.org/wiki/North_Carolina_Division_of_Motor_Vehicles) | `MOTOR VEHICLES, NORTH CAROLINA DIVISION OF` to `ncdot`, confirmed after one official-page check (7 awards) |
| Department of Adult Correction | Separate cabinet department since 1 Jan 2023 (S.L. 2021-180), split from the Department of Public Safety; juvenile justice stayed in DPS. It has its own plan in the 32 agencies (`agency_map.csv`: `dac`). The name is NC-specific as far as I know [unverified]. | [OSBM report](https://osbm.nc.gov/ncga-reportdaccreationfinal-report/download), [Wikipedia](https://en.wikipedia.org/wiki/North_Carolina_Department_of_Adult_Correction) | `DEPARTMENT OF ADULT CORRECTION` to `dac`, confirmed (2 awards) |
| Department of Information Technology | A cabinet department created in 2015; it has its own plan (`ncdit`). But "Department of Information Technology" is a common name across states and the recipient has no NC marker (6 awards, about $1.56 billion obligated per `nc_awards_recipients.csv`), so the name alone cannot say which state. | [Wikipedia: NCDIT](https://en.wikipedia.org/wiki/North_Carolina_Department_of_Information_Technology) | Leave `uncertain` until the award place of performance or DUNS/UEI is checked |

Also relevant: because DPS lost its prison arm in 2023, older awards to "Department of Public Safety" may belong to what is now Adult Correction. I did not test this [unverified].

## What the change would do (scratch run, not committed)
I promoted the first three rows to confirmed in a scratch copy of the map and reran the same Top 10 logic as `26_backtest_v2_intime.R` (output not saved to the repo):
- Won programs (agencies with 3+): 157 to 159. Top 10 catches: 57 to 58. In time (21+ days): 41 to 42.
- Commerce 11 to 12 won (3 to 4 caught); NCDOT 13 to 14 (8 to 8). Adult Correction stays under 3 won programs, so it does not enter the pooled count.
- So the effect is small, but it would change the quoted 57 of 157, so it is Kent's call whether to apply it before the fact sheet is frozen.

## Recommendation
Apply the three promotions (after the DMV official-page check) only if Kent wants the pooled figure to be 58 of 159; otherwise keep the map as is and state in Q&A that divisions inside Commerce and NCDOT are not counted. Either way the headline (about one third reaches the Top 10, versus 17% for a deadline sort) does not change.

## APPLIED (Kent chose "apply all three", Sat Nov 7)
`agency_award_map.csv`: Adult Correction to `dac`, Employment Security to `commerce`, Motor Vehicles to `ncdot`, all `confirmed` (DIT stays uncertain). DMV check: official NCDOT pages sit under ncdot.gov/dmv and the NCDOT staff directory lists it as a unit ([NCDOT directory](https://apps.ncdot.gov/dot/directory/authenticated/UnitPage.aspx?id=197), [ncdot.gov/dmv](https://www.ncdot.gov/dmv/contact/Pages/default.aspx)); I did not open the statute for DMV [unverified].
I reran 20, 21, 22, 24, 25 and 26 offline. `backtest_result.csv` (the pre-set v1 test) is unchanged, so fact rows 15, 16 and f18 to f22 still hold. Changed outputs: `backtest_v2_result.csv`, `backtest_tune_result.csv`, `backtest_misses.csv`, `backtest_v2_intime.csv` and the three `backtest_v2_*.png` figures.

### Kent: numbers to update (check_facts shows 33 of 39 until `facts.csv` is edited)
| Where | Old | New |
|---|---|---|
| facts.csv f33, fact sheet row 26 (won programs, 12 agencies) | 157 | 159 |
| f34, row 26 (Top 10) | 57 (36%) | 58 (36%) |
| f35, row 27 (Top 50) | 95 (61%) | 97 (61%) |
| f37 (tuning, current setting) | 57 | 58 |
| f38 (no centering) | 40 | 41 |
| f39 (best setting, z centering) | 61 | 63 |
| row 29, pooled baselines at Top 10 | 17%, 13% | 17%, 13.5% (random is 0.135, so say "about 13 or 14%") |
| Unchanged | | f32 (12 agencies), f36 / row 28 (4 of 12 at or above 50%), rows 15 and 16 |
Row 30 text: "57 of 157 / best 61 / none 40" becomes "58 of 159 / best 63 / none 41". Anything quoting 57 of 157 elsewhere (slide brief slide 4, `qa_cheatsheet_draft.md`, `backtest_framing.md`, tool text) needs the same change. My E-drafts in this folder are already updated. E6 in-time: 42 of 58 (DHHS still 0 of 4); E2 split: 58 / 39 / 62.
