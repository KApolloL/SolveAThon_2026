# Handoff: model-label the full pool on two machines

Goal: label every open grant (1,576 rows: posted, forecasted, notice) against each of the 34 agency plans with the local Ollama model, then merge. Machine A (Kent's) takes 17 agencies, machine B takes the other 17. Plan: `model_labels/agency_plan.csv` (columns agency, machine, order). Agencies run in `order`; each finished agency writes its own CSV, so partial results are usable.

## Status (2026-11-07, machine A stopped)
Machine A finished 7 of its 17 agencies (Public Schools, Environmental Quality, DHHS, Administration, Agriculture and Consumer Services, Information Technology, Justice) and was stopped during Military and Veterans Affairs. Those CSVs are in `model_labels/by_agency/`. Rerunning the machine A command resumes from the next agency. Machine B has not reported. Remaining agencies: 27 of 34.

## Read first
- The validation gate FAILED (kappa 0.44, needs 0.60; recall of the 3 hand-"relevant" items 3 of 3). Runs use `force=1`. Every number built on these labels must say "model labels, unvalidated". Hand labels are the only validated labels.
- Prompt is fixed at `evalpool-v3` in `model_label.R`. Do NOT edit the prompt, `MAX_TEXT_CHARS` or the model on either machine; labels from different prompts cannot be mixed.
- Keyword/embedding prefilters were tested and rejected: embedding rank put hand-positive items as low as 1456 of 1576, so skipping low-ranked items would drop real hits.
- "Guiding Principles" and "State Board of Education Plan" are in the plan file; they are cross-cutting or plan-level, not agencies. Labels for them are low value; they are on machine B at the end of its order. [Kent to confirm]

## Time (measured, not promised)
About 3.3 s per item on Kent's machine (qwen2.5:14b, one process). 17 agencies x 1,576 items = 26,792 calls, roughly 24 hours per machine at that speed. It will NOT finish by Sunday 9:00 AM on either machine. The order puts the most useful agencies first. Stop whenever the deadline forces it and use the agencies that are done.
Parallel processing was tested and does NOT help: one process took 4.2 s/item on a server with OLLAMA_NUM_PARALLEL=2, and two concurrent processes took 167 s for 40 items (also 4.2 s/item). The GPU is the limit. Run one process per machine.
So expect about 3.3 to 4.2 s per item: roughly 600 to 800 items per hour, about 0.4 to 0.5 agencies per hour per machine. Whatever agencies finish by the cutoff are the result.

## Machine B setup
1. Get the repo and the branch Kent names (he pushed it; it contains `model_label.R` and `agency_plan.csv`): `git fetch origin` then `git switch <branch>`. Run everything from the `Finalists` folder.
2. Install R 4.5 packages: data.table, openxlsx, httr2, jsonlite, digest, dplyr, stringr, purrr, tibble, here.
3. Install Ollama, then pull the same model: `ollama pull qwen2.5:14b`. Needs about 10 GB and roughly 16 GB RAM free. Keep the laptop awake and plugged in.
4. Check it runs: `ollama list` shows `qwen2.5:14b`.

## Run on machine B (from the Finalists folder)
```bash
Rscript drafts/claude/eval/model_label.R stage=full force=1 machine=B
```
Log progress to a file if you like: add `> drafts/claude/eval/model_labels/run_B.log 2>&1`. If it stops, run the same command again; finished agencies are skipped and the LLM cache resumes the rest.

## Machine A (Kent), already started
```bash
Rscript drafts/claude/eval/model_label.R stage=full force=1 machine=A
```

## Bring results back
- Copy `drafts/claude/eval/model_labels/by_agency/*.csv` from machine B into the same folder on machine A. File names are the agency slug, so nothing collides.
- Optional: copy `src/data/cache/llm/` too (lets either machine reuse every label).
- Only copy complete files. A file named `*.csv.tmp` is an unfinished agency; ignore it.

## Merge (any machine, from Finalists)
```bash
Rscript -e 'library(data.table); f <- list.files("drafts/claude/eval/model_labels/by_agency", "\\.csv$", full.names=TRUE); d <- rbindlist(lapply(f, fread, colClasses=list(character=c("opp_id","opp_number")))); fwrite(d, "drafts/claude/eval/model_labels/full_pool_labels.csv"); print(d[, .N, by=.(agency, model_label)][order(agency, model_label)])'
```

## Output columns
agency, opp_id, opp_number, title, model_label (relevant | maybe | not relevant), evidence (an exact quote from the notice, or NA), evidence_ok (the quote was found in the text; labels without a verifiable quote are forced to "not relevant"), cached.

## Do not
- Edit the prompt, the model or `MAX_TEXT_CHARS`.
- Commit `src/data/cache/llm/` or push to `main` without Kent.
- Use these labels as ground truth or quote them as validated.
- Add AI-use entries to `AI_USAGE_LOG.md` by hand on machine B; tell Kent so one entry covers both machines.
