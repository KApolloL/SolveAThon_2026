# Evaluating answers for `src/docs/qa_cheatsheet.md` (draft by Everett's Claude, for Kent to paste)

Numbers only from `src/docs/fact_sheet.md` (row given). Unverified by a human. Say "would not have flagged", never "missed".

| Criterion | Likely question | Short answer (2 sentences max) | Fact # | Who answers |
|---|---|---|---|---|
| Evaluating | What is the biggest weakness? | We can only test the tool against programs agencies already won, and the test we set in advance failed: 1 of 3 agencies reached 50%, and a deadline sort beat us in all 3. We have no evidence yet that it finds new good-fit grants; embeddings are the untested fix. | 15, 16 | Kent |
| Evaluating | What is the tradeoff? | Keyword fit leaves most won programs out of the Top 10 (58 of 159 reach it). Widening to the Top 50 reaches 97 of 159 (61%), but a part-time coordinator then reads five times as many items. | 26, 27 | Kent |
| Evaluating | Why trust the second test if you built it after the first failed? | Do not trust it as a pass: it is exploratory and the first failure stands. It fixes a flaw in the first test (the denominator depended on the ranking being tested) and includes more agencies. | 15, 26 | Everett |
| Evaluating | Does it just reward grants agencies win every year? | Yes, matching is by program, not notice, so repeat funding helps it. We cannot score a brand-new good fit and have no number for one. | 15 | Everett |
| Evaluating | Did tuning fix the misses? | No. Nine settings, checked on held-out agencies, found nothing that beat the current one in both directions, so we changed nothing. | 30 | Kent |
| Evaluating | Why were some won programs not in the Top 10? | Of 159 won programs, 39 rank 11 to 50 and 62 rank below 50; none was hidden by an eligibility rule. Their notices score well under the Top 10 on keyword fit, which is consistent with a keyword gap but does not prove it. | 26 (the split and the fit comparison are from `backtest_misses.csv`, `backtest_keyword_gap.csv`; not yet fact rows) | Everett |
| Evaluating | How many catches left time to apply? | 42 of the 58 Top 10 catches had 21 or more days left; 21 days is our assumption, not the sponsor's. DHHS had none. | not a fact row yet (`backtest_v2_intime.csv`) | Everett |
| Evaluating | DHHS is the biggest agency; why does it do worst? | It is our weakest case: 4 of its 30 won programs reach the Top 10. We think many DHHS programs use words the plan lacks, but we have not tested why. | not a fact row yet (`backtest_v2_result.csv`) | Kent |

Update to `backtest_framing.md` "Named weakness" (optional, for Kent): add "Tested once (Everett, `backtest_keyword_gap.md`): the 62 won programs ranked below 50 all score under their agency's Top-10 median fit and 11 score zero. That is consistent with a keyword gap, not proof; a hand check of 10 notices is provisional."
