# Handoff: NC Grant Triage, final state
Written Tuesday Sept 29, 2026, evening. Due Wednesday Sept 30, 11:59 p.m.
Read time: about 6 minutes. Section 7 is for a coding agent; everyone else can stop at section 6.

---

## 1. The 30-second version

**The build is finished.** All three written deliverables exist and render. The tool, the
notebook and the top results list agree with each other, because they all run the same tier-rule file.

What is left:

- **Record the 5-minute video.** The script has not been written yet (on purpose, per Kent).
- **Commit and push.** Nothing has been committed. That waits for Kent's go.
- **Optional:** double-click `outs/grant-triage-tool.html` on another laptop to confirm it opens offline.

What we decided **not** to do, and say so openly in the notebook:

- **Tiers 1-3 were not hand spot-checked.** The team reviewed the research awards but ran out of time
  for the rest. The 60 blind hand labels are the evidence for those tiers.

---

## 2. Deliverables (competition items)

| Competition item | File | Notes |
|---|---|---|
| 1. Top results list with a one-line rationale | `outs/top_results.xlsx` (and `.csv`); also notebook section 14 | 51 rows: DHHS 23 Tier 1, 23 Tier 2, 3 Tier 3; DMVA 2 Tier 3. Each rationale covers the five criteria. |
| 2. Notebook: notes, AI tools, key prompts, where the AI was wrong | `outs/solveathon_project.html` (source `src/solveathon_project.qmd`) | 19 sections, 18 figures plus a process diagram, the full prompt and schema, validation, limitations, AI disclosure. The tool is embedded. About 16 MB, opens offline. |
| 3. 5-minute video to leadership | not started | Outline in the team brief, section 8 |
| Supporting: interactive tool | `outs/grant-triage-tool.html` | 3.3 MB, one file, offline |
| Supporting: team brief | `outs/team_brief_v2.docx` (source `src/docs/team_brief.md`) | Updated with final numbers and a new "How confident are we?" section |

---

## 3. Final numbers (use these, they match the notebook)

**The haystack**
- 1,662 opportunities in the file.
- 296 are open and state-eligible; 272 of those (92%) are NIH research.
- Only 6 posted, non-NIH opportunities are genuine DHHS candidates.

**Opening scenario for DHHS**
- 23 in Tier 1, 23 in Tier 2, 3 in Tier 3, and 365 in Tier 4 (partner-led research).
- 88 are "not this cycle", 4 are screened, and 1,156 are outside DHHS's scope.
- Total: 1,662. Every opportunity is accounted for.

**Data quality**
- The match percentage appears in only 6 rows, against 117 that require cost share.
- 355 "posted" opportunities had closed or been archived six weeks after the pull.

**AI vs. 60 blind hand labels**
| Label | Agreement |
|---|---|
| Match required | 93% |
| Capital project | 94% |
| Designation | 94% |
| DMVA alignment | 95% |
| Administrable by a state agency | 67% |
| DHHS alignment | 59% |
| Domain | 46% |

- Capabilities: 53% precision, 27% recall.
- Target population is not comparable, because the hand labels were free text.

**Where the AI was wrong** (these appear in the notebook and the brief):
- Prompt v2 was over-generous: wildfire and Sierra Leone programs were labeled DHHS-aligned.
- v3 over-corrected and rejected Title X.
- v3.1 got 13 of 14 dev cases right, and was then frozen.
- The model once wrote its own rule ("work happens outside the United States") into an evidence field.

**The research review**
- The team read 27 flagged research awards.
- They recommended a separate research tier for 23, marked 1 not relevant, and judged none to be DHHS-led.
- This became Tier 4.

---

## 4. Decisions made (all can be revisited)

| Decision | Choice | Where |
|---|---|---|
| Strategic plan | DHHS 2023-25 as provided by the competition (OSBM); DMVA 2025-29 | `data/manual/*_priorities.csv` |
| Domains | 8 (D01-D08); **no veterans domain** (d09 declined) | `00_config.R`, `src/docs/domain_taxonomy.md` |
| Prompt | Frozen at **v3.1** | `LLM_PROMPT_VERSION` in `00_config.R` |
| Hand labels | Left as the team wrote them, including 4 match slips | `data/manual/handlabels_60.csv` |
| Default match authority | "With approval" | `MATCH_AUTHORITY_DEFAULT` |
| Forecasts | Included in the opening scenario | `PRESETS` |
| Research awards | Tier 4 "partner-led", shown by default, can be hidden | tool toggle; `SHOW_SCREENED_DEFAULT` |
| Impact score | Five parts, user weights 0-3, "what matters most" selector; orders within a pile only | `IMPACT_WEIGHTS_DEFAULT` |
| Appropriation line | $1M, a labeled placeholder with no published NC rule | `APPROPRIATION_THRESHOLD_USD` |
| Spot-check | Tiers 1-3 not done; stated as a limitation | notebook section 15 |

---

## 5. What the team should do before submitting

1. **Write and record the video** (outline in the brief, section 8). The strongest moments are:
   - the NIH funnel;
   - typing a scenario into the tool;
   - DMVA's Veterans Home grant landing in Tier 3;
   - the Title X match that the data file missed;
   - the confidence table.
2. Open the notebook and the tool once each and skim them.
3. Tell Kent when to commit and push.
4. Kent: rotate the Census API key when convenient. It was pasted in chat; it is not in any file
   except the gitignored `.Renviron`.

---

## 6. Five things every one of us must be able to explain

1. **Our user** is a mid-level grant writer inside DHHS who cannot commit match without a supervisor.
2. **Piles sorted by whose signature is needed**, plus Tier 4 for research a university would lead.
3. **The haystack:** of 296 open, state-eligible opportunities, 272 are NIH research. Only 6 posted
   non-NIH opportunities are DHHS business.
4. **Confidence:** the AI is strong on stated facts (match, construction, designation, 93-94%) and weaker
   on judgment (67% on "could a state lead it"). Every label is shown with its evidence, and the AI never
   assigns a tier.
5. **No single score** across piles: the impact score only orders within a pile.

---

## 7. For a coding agent picking this up

### Environment
- Project root: `/Users/kentalee/Documents/KALProjects/UNCProjects/SolveAThon_2026`.
- Software: R 4.5; Quarto 1.9.37; Ollama 0.34.4 with `qwen2.5:14b` and `nomic-embed-text`.
  Ollama is needed only to re-label.
- Every entry point calls `here::i_am(...)`, because `src/_quarto.yml` otherwise roots `here()` at `src/`.
- `00_config.R` forces a UTF-8 `LC_CTYPE`, because the text is hashed for the LLM cache. Do not remove it.
- The Census key lives only in the root `.Renviron`. Never write it into code or output.

### Rebuild (from `src/`, no key or model needed; everything is cached)
```bash
cd src
Rscript R/check_facts.R            # 24 of 24
Rscript R/05_export_tool_data.R    # data/processed/payload.json
Rscript tool/build_tool.R          # 32 tests (28 rule cases + ordering), then outs/grant-triage-tool.html
Rscript R/07_top_results.R         # outs/top_results.csv/.xlsx
quarto render solveathon_project.qmd
```

A clean-copy rebuild was verified:
- 24/24 facts pass;
- all 32 tests pass;
- all 1,662 opportunities are placed;
- the payload is byte-identical apart from its timestamp.

### Invariants
- **Tier rules exist only in `src/tool/tiering.js`.** R runs the same file through V8
  (`run_tiering_js`, `run_tiering_piles_js(payload, settings)`).
- The `payload.json` schema `1.0.0` must equal `Tiering.SCHEMA`.
- Payload format:
  - dates are integer days since the epoch;
  - lists are wrapped in `I(as.character(...))`;
  - it is written with `digits = NA`.
- LLM cache key = sha256(model + digest + prompt version + prompt + schema). Changing the prompt re-labels
  all 210 opportunities.
- `06_spotcheck_sheet.R` never overwrites a template that already holds verdicts.
- The team's research-review verdicts are in `data/manual/spotcheck_template.csv` and `spotcheck.csv`.

### Not done / optional
- The video script (only when Kent asks).
- Commit and push (only on Kent's explicit go; see `.gitignore` for which `outs/` files are tracked).
- The notebook is about 16 MB because of embedded figures. Lowering `fig-dpi` would shrink it if needed.
- Orphans that are harmless to leave:
  - legacy `src/diagnostic.qmd`, `src/extra.Rmd` and `src/solveathon_project.Rmd`;
  - old files in `data/processed/`;
  - unused cache files from before the UTF-8 fix.
- Ask Kent before cutting anything. Section 13 questions (capability levels, domains, hand-label
  correctness, how real agencies are characterized) are his to decide.
