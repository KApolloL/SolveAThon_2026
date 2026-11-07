# Kent: pipeline, merges, fact sheet

You are Kent's Claude. Kent does every merge. Read `../README.md` rules first. This brief covers what the critical path needs.

## Goal
By 1:00: real `payload.json` (keyword top 10 per agency for all 32 agencies, eligibility from codes and rules, goal snippets) and `rankings_backtest.csv`, so Marco's tool and Everett's backtest run on real output.

## You own
`src/R/00_config.R`, `score.R`, `10_run_ranking.R`, helpers, `data/manual/criteria.csv`, `data/manual/agency_map.csv`, `payload.json`, `rankings_backtest.csv`, `fact_sheet.md`, `handoff.md`, `CLAUDE.md`, all merges.

## Steps
1. **By 9:30, Merge 1.** Write `data/manual/agency_map.csv` (32 agencies; fold State Board of Education into DPI; drop Guiding Principles as duplicate). Write a stub `payload.json` and `rankings_backtest.csv` that match `03_contract.md`, from a few real rows. Merge and tell everyone to rebase.
2. **9:30 to 11:00.** Write `data/manual/criteria.csv` (3 to 5 measurable rules, each tied to a field, with a plain `why`). Fix `score.R` per `planning/09_tool_plan_update.md` "Must fix before the 1:00 gate": drop-and-rescale missing parts, 2099 dates read "rolling or no date listed", award ceiling 0 as unknown, duplicates, all-zero weights. Make `00_config.R` fail loudly on toy data. Keyword fit (TF-IDF or BM25) behind one swappable scoring function. Per-agency ranking.
3. **Eligibility steps 1 and 2** (codes, then fixed text rules). Codes 25 and 99 must not hide items. Higher-education-only is No for DEQ. Tribal-only is No for all. Unclear stays "ask".
4. **Merge 2 at 11:00:** write `payload.json` for real, plus `rankings_backtest.csv` for closed items since 2024-11-06. Run `Rscript tests/run_tests.R` and `Rscript R/check_facts.R` first.
5. **11:00 to 12:15.** Decide whether county need (A) enters the score. Review Noah's and Everett's branches. Add the rerun check: same input, same `payload.json`.
6. **12:15 Merge 3, 12:15 to 12:45 integration, 12:45 go / no-go** against `01_goals.md`.
7. **Afternoon.** Daily job wiring with Marco, closing-soon data, fact sheet entries as numbers land (each with the script that reproduces it), slide brief `deliverables/slide_brief.md` and figures in `outs/figures/`, field notes review.
8. **5:30 Merge 4. 6:00 stop. 7:00 clean snapshot repo with Marco.**

## Done means
- [ ] Rerun gives an identical `payload.json`.
- [ ] `tests/run_tests.R` and `check_facts.R` pass.
- [ ] DERA appears for DEQ and DPI.
- [ ] Every number in `fact_sheet.md` has a reproducing script.

## Handoffs
- To Marco: the contract and stub (9:30), the real `payload.json` (11:00).
- To Everett: `rankings_backtest.csv` stub (9:30), real (11:00).
- From Noah: label check result, SAM listings, county need. From Everett: backtest result.
