# Persona test results log

One row per run. Findings are hypotheses, not evidence.

| Run | Date | Phase | Persona | Scenario | Run by | Transcript | Top finding | Severity | Decision (fix / defer / ignore) | Done? |
|---|---|---|---|---|---|---|---|---|---|---|
| 01 | | | | | | `testing/transcripts/01_...md` | | | | |
| 01 | 2026-11-06 | Test | hostile-judge | Full project | Marco (Claude Code) | `testing/transcripts/01_*_20261106.md` | Almost nothing built; Solve/Evaluate/Impact score 1/5 | High | See `testing/triage_20261106_full_review.md` | No |
| 02 | 2026-11-06 | Test | data-critic | Full project | Marco (Claude Code) | `testing/transcripts/02_*_20261106.md` | Missing-data rule contradicts decision 5; no criteria table | High | See `testing/triage_20261106_full_review.md` | No |
| 03 | 2026-11-06 | Test | osbm-sponsor | Full project | Marco (Claude Code) | `testing/transcripts/03_*_20261106.md` | No baseline for 'missed'; scope too heavy; no owner | High | See `testing/triage_20261106_full_review.md` | No |
| 04 | 2026-11-06 | Test | it-architect | Full project | Marco (Claude Code) | `testing/transcripts/04_*_20261106.md` | Keys committed; $500 is an alert not a cap; handover gaps | High | See `testing/triage_20261106_full_review.md` | No |
| 05 | 2026-11-06 | Test | dhhs-grant-writer | Full project | Marco (Claude Code) | `testing/transcripts/05_*_20261106.md` | Tier 1 is default bucket; wrong-eligibility matches in top 5 | High | See `testing/triage_20261106_full_review.md` | No |
| 06 | 2026-11-06 | Test | nongrants-staffer | Full project | Marco (Claude Code) | `testing/transcripts/06_*_20261106.md` | App unusable for first-time user; jargon; no first step | Medium | See `testing/triage_20261106_full_review.md` | No |
| 07 | 2026-11-06 | Test | test-breaker | Full project | Marco (Claude Code) | `testing/transcripts/07_*_20261106.md` | score.R bugs reproduced; tests pass only on toy data | High | See `testing/triage_20261106_full_review.md` | No |
