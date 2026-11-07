# Fact sheet

Every number used on a slide or in a handout is listed here with the script that reproduces it. If it is not here, it does not go on a slide.

| # | Fact (exact wording) | Value | Script / file that produces it | Verified by | Date |
|---|---|---|---|---|---|
| 1 | NC agency strategic plans from OSBM, as downloaded | 34 | `data/raw/agency_plans/MANIFEST.csv` (row count) | Claude, checked against `data/manual/agency_map.csv` | 2026-11-07 |
| 2 | Agencies the tool ranks for, after folding the State Board of Education plan into DPI and dropping Guiding Principles as a duplicate | 32 | `data/manual/agency_map.csv` (rows with empty `fold_into` and `drop_reason`); asserted in `src/R/09_stub_payload.R` | Claude; Kent to confirm at Merge 1 | 2026-11-07 |
