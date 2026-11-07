# Finalists: Solve-A-Thon 2026 Final Quest

**When:** Friday Nov 6, 5:30 pm, to Sunday Nov 8, 2 pm (awards). Presentation submission due **Sunday 9:00 am**. Presentations 10:00 am to 12:30 pm: **6 minutes (with brief demo) plus 2 minute Q&A**, in person (earlier organizer email said 5 plus 2; confirm). Manning Hall. Full schedule: vault `Projects/Competitions/Solveathon/Solveathon.md`.
**Prompt:** Build the **Federal Funds Matchmaker** for NC OSBM: scan federal funding opportunities (Grants.gov or SAM.gov), build agency profiles from real NC strategic plans, score and rank opportunities per agency, summarize them, and show results in a simple interface. Must run on Azure. Humans make the final call. Full text: [docs/QUEST_BRIEF.md](docs/QUEST_BRIEF.md).
**Submit before Sun Nov 8, 9:00 am:** slides, Solution Design and GenAI Field Notes, and this repository (README a state developer can pick up), plus a link to the working product, via the Final Submission form (link in `docs/QUEST_BRIEF.md`).
**Team:** Kent Lee, Everett Foo, Marco Gullotto, Matthew Martin, Noah Goldblatt.

> Agency and user: sponsor is OSBM; the primary user is [assumed] an agency grant coordinator, to be confirmed at the discovery workshop. Data sources and Azure setup are in progress; see `handoff.md`. Before submission this README must become a state-developer onboarding guide (what it does, how to run it, how to deploy on Azure, known limits, how to extend).

## Layout

| Folder | What goes there |
|---|---|
| `docs/` | Team and process docs: [QUEST_BRIEF.md](docs/QUEST_BRIEF.md) (organizer text), [RUNBOOK.md](docs/RUNBOOK.md) (day plan), [SKILLS_GUIDE.md](docs/SKILLS_GUIDE.md), [AI_HANDOFF.md](docs/AI_HANDOFF.md) (paste-ready context for chat-only AIs). |
| `app/` | The Azure skeleton: a minimal R Shiny hello page and its Dockerfile (`MODE=app` or `MODE=job`). Built in the cloud with `az acr build`. Setup state and plan: [src/docs/azure_setup.md](src/docs/azure_setup.md). |
| `src/R/` | Numbered R pipeline scripts (`00_config.R`, `01_...`). Written by hand or with AI. |
| `src/docs/` | Briefs, the fact sheet (`fact_sheet.md`), notes. |
| `notes/vault/` | Copies of the Solveathon vault notes (the vault is the source), including the organized discovery session notes. Index: [notes/vault/README.md](notes/vault/README.md). Findings: [planning/07_discovery_findings.md](planning/07_discovery_findings.md). |
| `data/raw/` | Untouched inputs, never modified: organizer files and 34 agency strategic plan PDFs. Intake log: [data/raw/README.md](data/raw/README.md). Notes on the organizer files: [src/docs/organizer_materials_notes.md](src/docs/organizer_materials_notes.md). |
| `data/manual/` | Hand-authored tables (labels, mappings). |
| `data/cache/` | Saved API and model responses so nothing is re-queried. |
| `data/processed/` | Pipeline outputs. |
| `outs/` | Generated files. Safe to delete and rebuild. |
| `planning/` | Friday worksheets: discovery questions, framing worksheet, problem types, data prep, and [tonight's plan with teammate AI prompts](planning/06_tonight_plan.md). |
| `testing/` | Persona role-play testing: personas, scenarios, paste-ready prompts, transcripts, results log. |
| `tasks/` | One brief per teammate task. Finished briefs move to `archive/tasks-done/`. |
| `deliverables/` | Final files teammates produce (slides, disclosure, handouts). |
| `archive/` | Inert history: `stale/`, `graphify-out/`, `tasks-done/`. Nothing reads from here. See [archive/README.md](archive/README.md). Planned later cleanup: [docs/REORG_PLAN.md](docs/REORG_PLAN.md). |

`deliverables/slide_brief.md` is the handoff to the teammate whose AI agent builds the slides. `src/docs/qa_cheatsheet.md` holds likely judge questions.

## Pipeline skeleton (reusable; runs on toy data until the real data is in)

Run everything from `Finalists/src`. Toy example files live in `data/example/` and are used only when the real file is missing (the scripts say so). Real files: `data/processed/items.csv`, `data/manual/criteria.csv`, `data/manual/test_cases.csv`, `data/manual/facts.csv`.

```bash
Rscript R/01_profile.R         # first look at every file in data/raw (after the criteria are on paper)
Rscript R/10_run_ranking.R     # filter, score, rank, explain -> items.csv, ranking.csv, outs/top_results.csv
# items.csv is not in git. On a fresh clone run 10_run_ranking.R BEFORE the two checks below, or they fall back to the toy file and fail ("criteria point at columns that are not in the items").
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

Top-level files: `docs/SKILLS_GUIDE.md` (which Claude skill to load when), `CLAUDE.md` (rules and context for the AI agent), `handoff.md` (current status), `AI_USAGE_LOG.md` (running log for the disclosure).

## Working rules

- Kent commits code. Teammates deliver files into `deliverables/` or the shared Drive and send Kent the path.
- Work in a branch, never on `main` (see `../QualifierChallenge/TEAM_SETUP.md`).
- Every number on a slide comes from `src/docs/fact_sheet.md`.
- Keep `AI_USAGE_LOG.md` updated as you go. The disclosure is written from it.
- Freeze code at Saturday's 7:00 to 8:00 pm wrap up. The rest is slides and rehearsal.
