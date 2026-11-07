# Check of the new rows in `data/manual/agency_award_map.csv` (Noah's Claude, Sat Nov 7)

Kent's Claude asked for confirmation of the exact-name agency rows added in commit `9749003` ("Backtest v2"). That commit added 27 rows: 22 marked `confirmed` for 15 agencies, and 5 marked `uncertain` with no agency (excluded from the won set). This is read-only: I changed no map or backtest file.

Tags: **[verified]** = checked by script against repo files. **[sourced]** = from the web, link given, still `[uncertain]` until Kent confirms. **[not checked]** = I could not check it from the repo.

## What I verified in the repo [verified]
- All 27 recipient names exist exactly in `data/processed/nc_awards_recipients.csv`, and every one has class `state_agency`.
- All 15 `agency_id` values used (commerce, ncdot, dps, wrc, dncr, dacs, doj, ncccs, doa, dol, shp, doi, sbi, sos, ncsbe) exist in `data/manual/agency_map.csv`.
- No recipient name is listed twice in the map, and no name maps to two agencies.
- Award counts for the new confirmed rows are small for most agencies (for example DNCR old names 1 award each, State Highway Patrol 3, Secretary of State 3, State Board of Elections 3), so one row can swing a "won programs" count. The big ones are NCDOT (5,661 awards under one name variant) and DACS (302).

## The row Kent was least sure of [sourced]
`STATE OF NORTH CAROLINA DEPARTMENT OF CULTURAL RESOURCES` and `CULTURAL RESOURCES, NORTH CAROLINA DEPARTMENT OF` are mapped to `dncr`. NCpedia says the Department of Cultural Resources was renamed the Department of Natural and Cultural Resources on September 18, 2015, so the older name is the same department. [uncertain until Kent confirms] Sources: [NCpedia, Natural and Cultural Resources, Department of](https://ncpedia.org/node/2298); [NCpedia, natural cultural resources department](https://www.ncpedia.org/natural-cultural-resources-department).
Not checked: whether the awards under the old-name recipient string belong to the parts of the department that DNCR still runs. Since 2015 DNCR also took in the zoo, museum of natural sciences, aquariums and state parks, so some awards could be to units that the DNCR plan may not cover. [not checked]

## Rows I cannot confirm from the repo [not checked]
- **The five `uncertain` rows** (Information Technology, Adult Correction, Division of Veterans Affairs, Division of Employment Security, Division of Motor Vehicles) are correctly left out of the won set. Two notes in the map say the divisions sit inside Commerce and NCDOT; I did not verify that. Leaving them out is the safe choice, but it means those agencies have fewer won programs than they may really have.
- **"Exact state agency name" for each row** is Claude's assignment from the name (the Commerce row says so itself). The names match the agency; I did not check the awards themselves. A few word-order variants (for example `NC DEPARTMENT TRANSPORTATION`) are the same string family as the main NCDOT name.

## State-agency recipients still not in the map [verified]
15 recipients with class `state_agency` have no map row. The ones that could matter to a ranked agency:
| Recipient | Awards | Obligated | Note |
|---|---|---|---|
| NC COMMISSION ON VOLUNTEERISM & COMMUNITY SERVICE | 19 | $79.2M | Parent agency not checked here [not checked] |
| GOVERNORS OFFICE | 3 | $281.0M | No agency plan for the Governor's Office among the 32 |
| NORTH CAROLINA STATE UNIVERSITY | 14 | $11.3M | UNC System campus |
| NORTH CAROLINA AGRICULTURAL AND TECHNICAL STATE UNIVERSITY | 4 | $25.3M | UNC System campus |
| NORTH CAROLINA CENTRAL UNIVERSITY | 2 | $1.7M | UNC System campus |
The other 10 are small: local commissions and councils of government, fire associations, and a science museum.

**Decision for Kent:** `University of North Carolina System` is one of the 32 ranked agencies, but no UNC campus is mapped to it, so it has zero award history in the backtest. If that is deliberate (campuses apply for themselves, and research is not agency-led work), say so on the limits slide; if not, those 3 campuses (20 awards) are candidates. I did not add them.

## Bottom line
The mechanical parts are clean. The one judgment Kent flagged (DNCR older names) holds up on the NCpedia source. The open items are the UNC campuses, the Commission on Volunteerism, and whether DNCR's old-name awards belong to parts of the department its plan covers.
