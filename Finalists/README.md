# Finalists: Solve-A-Thon 2026 Final Quest

**When:** Friday Nov 6, 5:30 pm, to Sunday Nov 8, 2 pm (awards). Presentation submission due **Sunday 9:00 am**. Presentations 10:00 am to 12:30 pm: **5 minutes plus 2 minute Q&A**, in person. Manning Hall. Full schedule: vault `Projects/Competitions/Solveathon/Solveathon.md`.
**Prompt (as announced):** Turn real public data into a solution North Carolina can use. Move from understanding the user and framing the problem to building, evaluating, presenting and driving impact.
**Team:** Kent Lee, Everett Foo, Marco Gullotto, Matthew Martin, Noah Goldblatt.

> Problem statement, data sources, agency and user: **TBD at release.** Fill in `CLAUDE.md` first (section "Problem"), then this file.

## Layout

| Folder | What goes there |
|---|---|
| `src/R/` | Numbered R pipeline scripts (`00_config.R`, `01_...`). Written by hand or with AI. |
| `src/docs/` | Briefs, the fact sheet (`fact_sheet.md`), notes. |
| `data/raw/` | Downloaded inputs. Never modified. |
| `data/manual/` | Hand-authored tables (labels, mappings). |
| `data/cache/` | Saved API and model responses so nothing is re-queried. |
| `data/processed/` | Pipeline outputs. |
| `outs/` | Generated files. Safe to delete and rebuild. |
| `planning/` | Friday worksheets: discovery questions, framing worksheet, problem types, data prep. |
| `testing/` | Persona role-play testing: personas, scenarios, paste-ready prompts, transcripts, results log. |
| `tasks/` | One brief per teammate task. Finished briefs move to `tasks/done/`. |
| `deliverables/` | Final files teammates produce (slides, disclosure, handouts). |

`deliverables/slide_brief.md` is the handoff to the teammate whose AI agent builds the slides. `src/docs/qa_cheatsheet.md` holds likely judge questions.

## Pipeline skeleton (reusable; runs on toy data until the real data is in)

Run everything from `Finalists/src`. Toy example files live in `data/example/` and are used only when the real file is missing (the scripts say so). Real files: `data/processed/items.csv`, `data/manual/criteria.csv`, `data/manual/test_cases.csv`, `data/manual/facts.csv`.

```bash
Rscript R/01_profile.R         # first look at every file in data/raw (after the criteria are on paper)
Rscript R/10_run_ranking.R     # filter, score, rank, explain -> data/processed/ranking.csv, payload.json, outs/top_results.*
Rscript tests/run_tests.R      # unit, integration, your test cases, R/JS agreement, LLM guard; must print "N of N tests pass"
Rscript R/check_facts.R        # every slide number reproduced from facts.csv; must print "N of N rows pass"
Rscript tool/build_tool.R      # outs/criteria_tool.html (weights tool, one file, works offline)
quarto render report.qmd       # outs/report.html
```

| File | What it does |
|---|---|
| `R/00_config.R` | Every path, ID/name columns, shown fields, reference date, top N, LLM settings. |
| `R/helpers_io.R` | `read_any` (csv, xlsx, json, rds, geo), `profile_data`, `cached_fetch`, `fetch_paged`, `nc_boundaries` (untested). |
| `R/helpers_llm.R` | Local Ollama labeling with a cache; a label needs a quote found in the text; `shard = c(k, n)` splits work across laptops. |
| `R/score.R` | The ranking engine. The criteria table is the whole method. Column guide at the top of the file. |
| `R/helpers_report.R` | One chart style and `export_figure()` into `outs/figures/` for the slide brief. |
| `tool/` | `ranker.js` (browser copy of the math), `ui.js`, `styles.css`, `index.html`, `build_tool.R`. |
| `tests/` | `run_tests.R` and `agreement.R`. Write test cases before looking at results. |

Not built until needed: ingestion for the real data (`02_*` scripts) and the text-labeling run. Add them after the design sprint.

Top-level files: `SKILLS_GUIDE.md` (which Claude skill to load when), `CLAUDE.md` (rules and context for the AI agent), `handoff.md` (current status), `AI_USAGE_LOG.md` (running log for the disclosure).

## Working rules

- Kent commits code. Teammates deliver files into `deliverables/` or the shared Drive and send Kent the path.
- Work in a branch, never on `main` (see `../QualifierChallenge/TEAM_SETUP.md`).
- Every number on a slide comes from `src/docs/fact_sheet.md`.
- Keep `AI_USAGE_LOG.md` updated as you go. The disclosure is written from it.
- Freeze code at Saturday's 7:00 to 8:00 pm wrap up. The rest is slides and rehearsal.
