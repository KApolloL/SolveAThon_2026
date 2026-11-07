# Fact sheet

Every number used on a slide or in a handout is listed here with the script that reproduces it. If it is not here, it does not go on a slide.

| # | Fact (exact wording) | Value | Script / file that produces it | Verified by | Date |
|---|---|---|---|---|---|
| 1 | NC agency strategic plans from OSBM, as downloaded | 34 | `data/raw/agency_plans/MANIFEST.csv` (row count) | Claude, checked against `data/manual/agency_map.csv` | 2026-11-07 |
| 2 | Agencies the tool ranks for, after folding the State Board of Education plan into DPI and dropping Guiding Principles as a duplicate | 32 | `data/manual/agency_map.csv` (rows with empty `fold_into` and `drop_reason`); asserted in `src/R/09_stub_payload.R` | Claude; Kent to confirm at Merge 1 | 2026-11-07 |
| 3 | Open opportunities ranked (posted, forecasted or notice; closed items go to the backtest) | 1,576 | `data/manual/facts.csv` f2, checked by `src/R/check_facts.R` | Claude; Kent to confirm | 2026-11-07 |
| 4 | Agency by opportunity pairs scored (32 x 1,576; 3,030 of them are then hidden as not eligible, see row 7) | 50,432 | `data/manual/facts.csv` f3, `src/R/10_run_ranking.R` | Claude; Kent to confirm | 2026-11-07 |
| 5 | Open opportunities with no usable close date (rolling date listed, or a forecast whose date has passed) | 488 | `data/manual/facts.csv` f4 | Claude; Kent to confirm | 2026-11-07 |
| 6 | Open opportunities with no usable award ceiling (blank or 0) | 887 | `data/manual/facts.csv` f5 | Claude; Kent to confirm | 2026-11-07 |
| 7 | Agency by opportunity pairs hidden as clearly not eligible (applicant code, then fixed text rules; a text "no" carries the exact quote) | 3,030 | `data/manual/facts.csv` f6, `src/R/helpers_rank.R` `assign_eligibility()` | Claude; Kent to confirm | 2026-11-07 |
| 8 | Agency by opportunity pairs marked check eligibility (shown, not hidden) | 16,924 | `data/manual/facts.csv` f7 | Claude; Kent to confirm | 2026-11-07 |
| 9 | Agencies in `payload.json` | 32 | `data/manual/facts.csv` f10, `src/R/11_build_payload.R` | Claude; Kent to confirm | 2026-11-07 |
| 10 | Most Top 10 rows for one agency (open items only; forecasts go to Coming up, hidden-ineligible examples are kept apart) | 10 | `data/manual/facts.csv` f11 | Claude; Kent to confirm | 2026-11-07 |
| 11 | Rows in `payload.json` (320 Top 10, 320 Coming up, 320 hidden examples) | 960 | `data/manual/facts.csv` f12 | Claude; Kent to confirm | 2026-11-07 |
| 12 | Rows in `rankings_backtest.csv` (top 50 per agency and window, 95 windows of 2, 4 and 6 weeks from 2024-11-06 to 2026-11-06) | 152,000 | `data/manual/facts.csv` f13 and f14, `src/R/12_backtest.R` | Claude; Kent to confirm | 2026-11-07 |
| 13 | Open opportunities whose title names another state or region, so fit is halved (`GEO_PENALTY`, [assumed] 0.5) | 40 | `data/manual/facts.csv` f15, `src/R/helpers_rank.R` `geo_other()` | Claude; Kent to confirm | 2026-11-07 |
| 14 | DERA national program (opp 363936) is in the Top 10 for DEQ (rank 1) and DPI (rank 3) because `data/manual/program_map.csv` lifts Assistance Listing 66.039 for both agencies. The program-to-agency link is [uncertain]; Kent to confirm | in Top 10 for both | `data/manual/facts.csv` f16 and f17, `src/R/helpers_rank.R` `apply_program_map()` | Claude; Kent to confirm | 2026-11-07 |
| 15 | Award-history backtest, 4-week windows: agencies at or above the 50% bar (team judgment, not derived). DPI 2 of 3 programs (67%), DEQ 3 of 7 (43%), DHHS 4 of 11 (36%). Bar fails (1 of 3; pass needs 2 of 3). Rerun of Everett's `20_backtest_awards.R` on the current rankings gives an identical `backtest_result.csv`. Counts are programs, not notices; program-level match favors repeat funding; intervals are wide (see CSV) | 1 of 3 agencies | `data/manual/facts.csv` f18 to f21, `src/R/20_backtest_awards.R` | Claude; Everett and Kent to confirm | 2026-11-07 |
| 16 | Soonest-deadline baseline beats the model on 4-week windows in all 3 agencies | 3 of 3 agencies | `data/manual/facts.csv` f22 | Claude; Everett and Kent to confirm | 2026-11-07 |
| 17 | Top 10 rows closing within 14 days (`CLOSING_SOON_DAYS`, [assumed] 14) across all agencies | 73 | `data/manual/facts.csv` f23, `src/R/11_build_payload.R` | Claude; Kent to confirm | 2026-11-07 |
| 18 | Agencies with at least one Top 10 row closing within 14 days | 26 | `data/manual/facts.csv` f24 | Claude; Kent to confirm | 2026-11-07 |
| 19 | Plan goals carried in `payload.json` for the match board (goal text cut to 240 characters) | 153 | `data/manual/facts.csv` f25, `src/R/11_build_payload.R` | Claude; Kent to confirm | 2026-11-07 |
| 20 | Agencies with at least one plan goal in `payload.json` | 32 | `data/manual/facts.csv` f26 | Claude; Kent to confirm | 2026-11-07 |
| 21 | NC counties drawn on the County map tab, each with 18 measures | 100 | `data/manual/facts.csv` f27, `src/R/05c_county_shapes.R`, `src/R/05a_county_need.R` | Claude; Kent to confirm | 2026-11-07 |
| 22 | County measures carried in `payload.json` (CDC PLACES, ACS 2023, HRSA, NCHS, OpenFEMA; all from the qualifier caches) | 18 | `data/manual/facts.csv` f28 | Claude; Kent to confirm | 2026-11-07 |
| 23 | Capability rows (who controls what) for DHHS and DMVA, hand-built in the qualifier; other agencies have none | 28 | `data/manual/facts.csv` f29, `src/R/11_build_payload.R` | Claude; Kent to confirm | 2026-11-07 |
