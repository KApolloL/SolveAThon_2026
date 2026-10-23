# Finalists: Solve-A-Thon 2026 Final Quest

**When:** Friday Nov 6, 5:30 pm, to Sunday Nov 8, 2 pm (awards). Presentation submission due **Sunday 9:00 am**. Presentations 10:00 am to 12:30 pm: **6 minutes plus 2 minute Q&A**, in person. Manning Hall. Full schedule: vault `Projects/Competitions/Solveathon/NCHiddenTreasure.md`.
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
| `testing/` | Persona role-play testing: personas, scenarios, paste-ready prompts, transcripts, results log. |
| `tasks/` | One brief per teammate task. Finished briefs move to `tasks/done/`. |
| `deliverables/` | Final files teammates produce (slides, disclosure, handouts). |

`deliverables/slide_brief.md` is the handoff to the teammate whose AI agent builds the slides. `src/docs/qa_cheatsheet.md` holds likely judge questions.

Top-level files: `CLAUDE.md` (rules and context for the AI agent), `handoff.md` (current status), `AI_USAGE_LOG.md` (running log for the disclosure).

## Working rules

- Kent commits code. Teammates deliver files into `deliverables/` or the shared Drive and send Kent the path.
- Work in a branch, never on `main` (see `../QualifierChallenge/TEAM_SETUP.md`).
- Every number on a slide comes from `src/docs/fact_sheet.md`.
- Keep `AI_USAGE_LOG.md` updated as you go. The disclosure is written from it.
- Freeze code at Saturday's 7:00 to 8:00 pm wrap up. The rest is slides and rehearsal.
