# Skills guide (Kent's Claude Code)

Which installed skill to load, when, and what it costs. Built from the skill descriptions installed on Kent's machine on 10.23.26. Teammates do not have these skills; they use the agents and commands in `.claude/`.

## Rules for using skills efficiently
- Load a skill only when its trigger below applies. One or two per task. A loaded skill costs input tokens on every later turn.
- When two skills overlap, use the one in the **Default** column. Do not stack them.
- Heavy = multi-agent or long pipelines (costly). Do not start a heavy skill without telling Kent the cost first.
- Skills that edit code, files or settings need Kent's OK in this project (see `CLAUDE.md`). Never use a skill to commit or push in Kent's session unless Kent says so.
- If the finals problem is not a bio, Python or paper-writing problem, ignore the "Not for this project" list entirely.

## By phase

### Discover (Fri 6:00 to 9:15 PM)
| Need | Default | Why / notes |
|---|---|---|
| Stress-test the user, decision and criteria | `grilling` | Interviews Kent until the framing holds. Use at the start of the design sprint, before opening data. Also available: `mattpocock-skills:grilling` (same idea; skip). |
| Explore intent before building a tool or feature | `superpowers:brainstorming` | Its description says to use it before any creative work. Use once at the design sprint. Skip it for small edits. |
| Pin down terms, record decisions | `domain-modeling` | Builds a glossary and decision records, including context about the people a non-code project serves. Use to write the client's words and the decisions into `src/docs/`. |
| Turn observations into testable questions and rival explanations | `hypothesis-generation` | Only when the problem is analytic (estimate, evaluate) rather than a ranking. |
| Look up context on the agency, policy or a dataset | `research` (claude-plugins-official) | Investigates one question against high-trust primary sources and writes a Markdown file in the repo. Good to delegate to a cheap background agent. |
| Large multi-source synthesis | `deep-research` (user skill) | Heavy. Only for a big context question, not for quick lookups. Not `academic-research-skills:deep-research` (13-agent academic pipeline; heavier). |
| Find a public data source with endpoints and provenance | `database-lookup` | Queries documented public database APIs reproducibly, with the source named. Description confirmed only in summary; check output before use. |
| Convert PDFs or Office files to text | `markitdown` | Agency plans and PDFs into Markdown for reading. Alternative: `pdf` skill. |
| First look at a data file | `exploratory-data-analysis` | Bounded local profile, missingness and leakage audits. Written for Python-style workflows; our R `R/01_profile.R` does the basics. Use for the audit ideas only. |
| Judge evidence quality of a claim | `scientific-critical-thinking` | Biases, confounders, statistical interpretation. Use for context claims we plan to repeat. |
| Study design or sample size | `experimental-design`, `statistical-power` | Only if the client wants to evaluate something. Rare here. |

### Build (Fri night to Sat 8 PM)
| Need | Default | Why / notes |
|---|---|---|
| Edit the skeleton without overbuilding | `karpathy-skills:karpathy-guidelines` | Surgical changes, surface assumptions, verifiable success criteria. Keep in mind on every code task. |
| New behavior with strict scope and a stop condition | `caveman:lean-build` | For new slices or integrations where reuse and scope matter. |
| Bug fix at the narrowest layer | `caveman:surgical-patch` | Plus `superpowers:systematic-debugging` when the cause is unknown (default for any bug or test failure). Skip `mattpocock-skills:diagnosing-bugs` and `caveman:investigate-first` (same job). |
| Smallest-change mode | `ponytail:ponytail` | Overlaps with lean-build and karpathy-guidelines. Use one of the three, not all. |
| Multi-step plan and execution | `superpowers:writing-plans` then `superpowers:subagent-driven-development` | Use when a task touches more than about three files. Alternative: `thedotmack:make-plan` then `thedotmack:do`. Pick one family. |
| Two or more independent tasks at once | `superpowers:dispatching-parallel-agents` | E.g. ingest three datasets at the same time. Parallel agents multiply token cost. |
| Test-first | `superpowers:test-driven-development` | Matches the Deloitte rule (expected result before looking). In this project that means test cases in `data/manual/test_cases.csv` first. Skip `mattpocock-skills:tdd` (same). |
| Throwaway prototype to answer a design question | `prototype` | For deciding the tool's layout or a state model. Do not use for the real pipeline. |
| Any chart that goes on a slide or into the report | `dataviz` | Load before writing chart code. Follows one palette and layout system. |
| Polish the interactive tool UI | `impeccable` | Heavy and aesthetic. Use once, near the end, only if there is time. The skeleton's tool is plain on purpose. |
| Statistical test choice and assumptions | `statistical-analysis` | Guided test selection, effect sizes, reporting. Use when the problem needs a comparison or a model. |
| Cheap code search and orientation | `caveman:cavecrew-investigator` (agent) or `thedotmack:smart-explore` | Returns `path:line` hits without reading whole files. |
| Cheap small edits | `caveman:cavecrew-builder` (agent) | Only for 1 to 2 file edits. |
| Python libraries (polars, geopandas, matplotlib, seaborn, scikit-learn, statsmodels, networkx) | skip by default | The project is R. Use only if Kent decides the problem needs Python. |

### Test (Sat 2:00 to 6:00 PM)
| Need | Default | Why / notes |
|---|---|---|
| Never say "passes" without proof | `superpowers:verification-before-completion` | Run `tests/run_tests.R` and `R/check_facts.R` and read the output first. Use on every completion claim. |
| Validation-only check of finished work | `caveman:verify-and-stop` | When no new work is wanted. |
| Attack the method, pitch and test cases | the agents in `.claude/agents/` (`hostile-judge`, `data-critic`, `test-breaker`) and `/persona_*` commands | Built for this project. Use these first. |
| Review a code diff cheaply | `caveman:cavecrew-reviewer` (agent) | One line per finding. Alternative: `code-review` at low or medium effort. Do not use the ultra level (billed, cloud). |
| Constructive critique of the written method | `peer-review` | Evidence-bounded and constructive, so softer than the hostile judge. Use for the write-up only. |
| Receiving review feedback | `superpowers:receiving-code-review` | Verify feedback before acting on it. Use when a teammate or agent returns review comments. |

### Present (Sat evening to Sun 10:00 AM)
| Need | Default | Why / notes |
|---|---|---|
| Write the prompt for the teammate's slide AI | `prompt-master` | Only when Kent asks for a prompt for another AI. The slide brief template is `deliverables/slide_brief_TEMPLATE.md`. |
| Prose Kent will submit (Devpost text, written pitch) | `voice-match` | Uses Kent's real writing samples. Required for anything under his name. |
| Shared document for the team | `docs` | For editable documents people share and comment on. For a Google Doc or Drive file use `google-workspace`. |
| Slides Kent builds himself | `pptx` | Only if the teammate's agent route fails. |
| Plan the weekend on Google Calendar | `scheduling` | Uses Kent's commitments and rules. Offer events and wait for a yes. |

### Session and cost control
| Need | Default | Why / notes |
|---|---|---|
| Session getting long or looping | `kal-handoff` | Kent's handoff skill. Offer once. Other handoff skills (`thedotmack:handoff`, `claude-plugins-official:handoff`) overlap; skip. |
| Search past sessions | `thedotmack:mem-search` | Only to find earlier decisions across sessions. |
| Cut output tokens | `caveman:caveman` | Terse mode; stays on until told to stop. Use when credits run low. |
| See token use | `caveman:caveman-stats` | Shows this session's usage. |
| Shrink a long memory file | `caveman:caveman-compress` | Compresses CLAUDE.md-style files and keeps a backup. It sends the text to the model provider. Ask Kent first. |
| Fewer permission prompts | `fewer-permission-prompts` | Run once before the weekend, then review what it adds. |
| Write a PR description | `mattpocock-skills:pr` | Only when Kent asks for a PR. |
| Git commits | `commit-push` | Do not use in Kent's session unless Kent says to commit. Teammates' Claude sessions follow `CLAUDE.md`. |

## Not for this project (do not load)
- **Bio and lab:** `bio-research:*`, `anndata`, `scanpy`, `scvi-tools`, `scvelo`, `biopython`, `pydeseq2`, `bulk-rnaseq`, `cellxgene-census`, `gget`, `pathway-enrichment`, `nextflow`. Only if the finals problem is genuinely a biology data problem.
- **Paper writing:** `academic-research-skills:*`, `scientific-writing`, `literature-review`, `citation-management`, `paper-lookup`, `research-lookup`, `scientific-slides`. Not a paper.
- **Vault notes:** `kalnotes-*`, `obsidian:*`, `lit-search`, `anthropic-skills:kalnotes-*`. Use after the weekend for notes.
- **App cloning:** `replica-skill:*`.
- **Codebase mapping:** `understand-anything:*`, `thedotmack:learn-codebase`, `thedotmack:pathfinder`, `graphify`. The skeleton is small; reading it directly is cheaper.
- **Claude Code and tool setup:** `skins:skin-designer`, `caveman-setup`, `caveman-discover`, `caveman-manage`, `caveman-optimize`, `caveman-evidence-review`, `plugin-authoring`, `update-config`, `claude-api` (the pipeline uses Ollama, not the Claude API), `create-cli`.
- **Study aids:** `concept-quiz`, `learn`. Use `learn` only if a teammate needs a concept explained fast.
- **Unclear and skipped:** `humanscope`, `anthropic-skills:setup-claude`, `consolidate-memory`, `import-memory`, `resume-review` (not enough information to place them).

## Verified versus inferred
Descriptions above come from each skill's installed description text. Where I wrote "Use once" or "Heavy" for cost, that is my judgment, not a measurement. I have not run most of these skills in this project.
