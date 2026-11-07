# Independent check of the judge snapshot (E12, Everett's Claude)

> Historical note (Sat Nov 7, ~5:30 pm): this file records an earlier change and is kept as written. After the overseas-embassy filter the current values are in `src/docs/fact_sheet.md` (Top 10 59 of 159, Top 50 100, baselines 19.5% and 14.0%, in-time 4-week 42 of 59, hidden pairs 4,758).

Ran `Finalists/app/make_snapshot.sh` (Marco's T2) from `main` at d43a9c5 into a scratch folder outside the repo, then ran the repo's own checks inside the copy with no API keys. Read-only for the repo; nothing published. Unverified by a human.

## Result
- Script reported OK: 23,057 files, 455 MB, zip 193 MB.
- No `.git`, `api_keys.env`, `.Renviron`, `.RData` or `comms/` in the copy (found with `find`). The only key-named file is `Finalists/api_keys.env.example`. I did not print or read key values; I relied on the script's own value scan for that and did not repeat it.
- With no keys, from `Finalists/src`: `R/10_run_ranking.R` ran (32 agencies, 50,432 pairs, 3,030 dropped, 47,402 ranked), `R/check_facts.R` **42 of 42**, `tests/run_tests.R` **83 of 83**.
- So the snapshot's own banner line "rerunning from cache without keys is untested" is now tested for these three commands. Rerunning scripts that call Grants.gov or SAM.gov (01a, 02a to 02e) was not tried, on purpose.

## Notes for Kent and Marco
1. **Size:** 455 MB folder, 193 MB zip. If the submission form or a judge's download has a limit, check it; cached API data and drafts account for most of it [not broken down by me].
2. **"NOTE: using TOY EXAMPLE data" line:** it prints when a script loads before `items.csv` exists (a fresh clone, since `items.csv` is not in git). It appeared on my first command in the snapshot, and the numbers that matter match the fact sheet. My earlier backtest runs printed it too; those scripts build their own ranking, so I think it is harmless there, but that is inferred, not traced.
3. **Banner wording:** the banner could say "ranking, fact check and tests were run from cache without keys (Everett's Claude, Sat Nov 7)". Your call.
4. **Not checked:** opening the snapshot's HTML tool in a browser, the Quarto notebook render, and the 455 MB's top contributors.
