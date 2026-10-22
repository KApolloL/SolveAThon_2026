# Contributing

Team: Kent Lee, Everett Foo, Marco Gullotto, Matthew Martin, Noah Goldblatt.

## One-time setup

1. Install [Git](https://git-scm.com/downloads), [R 4.5](https://cran.r-project.org/), [RStudio](https://posit.co/download/rstudio-desktop/) and [Quarto](https://quarto.org/docs/get-started/). Python 3 is needed only for `build_site.py` and `export_slide_figures.py`.
2. Accept the GitHub invite to `KApolloL/SolveAThon_2026` (check your email).
3. Clone (about 350 MB, give it a minute):
   ```bash
   git clone https://github.com/KApolloL/SolveAThon_2026.git
   cd SolveAThon_2026
   git config user.name "Your Name"
   git config user.email "you@example.com"
   ```
   If GitHub asks for a password, use a [personal access token](https://github.com/settings/tokens) or install [GitHub Desktop](https://desktop.github.com/), which handles login.
4. Open `QualifierChallenge/SolveAThon_2026.Rproj` in RStudio.
5. Install packages: `Rscript QualifierChallenge/src/install_packages.R` (or run it in the RStudio console).
6. Check it works:
   ```bash
   cd QualifierChallenge/src
   Rscript R/check_facts.R     # must print "24 of 24 rows pass"
   ```
   No Census key or Ollama is needed. Caches are committed. Only if you must re-run the ACS pull: copy `QualifierChallenge/.Renviron.example` to `.Renviron` and add your key. Never commit it.

Read `QualifierChallenge/README.md` first, then `GUIDE.md`. Current status is in `handoff.md`.

## Daily workflow

Never push straight to `main`. Use a branch and a pull request.

```bash
git checkout main && git pull          # start from latest
git checkout -b yourname/short-topic   # e.g. marco/fix-deadline-parsing
# ...edit, run, test...
git add <files you changed>
git commit -m "Short description of the change"
git push -u origin yourname/short-topic
```

Then open a pull request on GitHub. One teammate reviews and merges. Pull `main` again before starting the next task.

## Rules that keep the project from breaking

- Run commands from `QualifierChallenge/src/`.
- Every threshold and default lives in `src/R/00_config.R`. Tier rules live only in `src/tool/tiering.js`. Do not copy them elsewhere.
- Do not edit `data/raw/`. Hand-authored tables go in `data/manual/`.
- `outs/` and `docs/` are generated. Do not hand-edit them. Rebuild with the commands in the README, and say in the PR if you regenerated them (they are large and conflict easily).
- Do not re-run `01a`, `03_llm_label.R` or the ACS pull casually. They call outside services for uncached items.
- Presentation numbers must come from `src/docs/presentation_brief.md`. Do not invent figures.
- No API keys, `.Renviron`, `.RData` or `.Rproj.user/` in commits. Do not commit files over 50 MB.
- Before opening a PR, `Rscript R/check_facts.R` must still print "24 of 24 rows pass".
- Two people editing the same file (especially `solveathon_project.qmd`) causes conflicts. Say in the team chat which file you are taking.
