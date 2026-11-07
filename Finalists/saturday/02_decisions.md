# Decisions (Kent, Sat Nov 7 about 1 am, grilling session)

| # | Decision | Why |
|---|---|---|
| 1 | Prototype at 1:00 = Azure URL with agency picker and keyword top 10, plus the award-history backtest number for DPI, DEQ, DHHS. Fallback: URL by 1:00, number by 2:00 | Only option that passes the gate as defined and gives the 2:00 mentor test a clickable build |
| 2 | 09 proposals 1 to 8 are the source of truth. Award history is the main evidence. DERA replaces Clean School Bus as the named case | 09 is the most recent plan; Clean School Bus (CFDA 66.045) has 0 rows in the data |
| 3 | Overnight model labels get a held-out check only, after 10:00. They stay out of the 1:00 payload. A fail goes in the field notes | The in-sample gate failed (kappa 0.44); labels can't be defended without a held-out check |
| 4 | Lanes: Kent pipeline, Marco Azure and UI, Everett evidence, Noah data and labels and docs, Matthew human checks and mentor slots. One owner per file | Four Claudes collide on shared files; ownership plus a schema contract lets lanes run in parallel |
| 5 | Noah pulls (A) the qualifier's county need caches and (B) SAM.gov Assistance Listings, after a 10-minute check that a bulk file exists. Everett pulls (C) Federal Audit Clearinghouse data after lunch | B is the only source for statutory authority, which the brief names. Kent's lane stays on the critical path |
| 6 | Kickoff 8:30. Merge windows 9:30, 11:00, 12:15, 5:30. Nothing merged between them. Building stops 6:00. Matthew asks mentor questions, with the lane owner beside him for technical and faculty slots | Kent does every merge and is also on the critical path |
| 7 | Backtest pass bar: 50% of won programs in top 10, 4-week windows, 2 of 3 agencies, with counts, intervals and two baselines | A bar fixed before looking is what the Evaluate criterion rewards |
| 8 | State Board of Education goals fold into DPI. Guiding Principles is dropped as a duplicate. Picker shows 32 agencies | Users pick "Public Schools", not a document; the duplicate is a data-quality fix to name |
| 9 | Notice reader (Azure OpenAI) is advisory only: label plus checked quote, never hides. Moves ahead of chat reasons in the cut order. Noah spot-checks 30 | No one has time for a 100-item accuracy gate; advisory keeps "AI labels, human decides" true |
| 10 | Judges get a clean snapshot repo: main's files, no git history, no `api_keys.env`. Marco builds it at 7:00 pm | Keys are in git history; this is the only option with no leak and no key rotation |
