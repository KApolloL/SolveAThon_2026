# 36. Persona run: non-grants staffer, "dead weight" review (Nov 7, 2026)

**Simulated persona, not user evidence.** Claude played an NC agency program staffer who has never written a federal grant, checks once a month, has 5 minutes, reads at a plain level. Do not quote it as what users said.

- Site: http://localhost:8765/ (local preview), desktop viewport (1440x900 set; the pane rendered it scaled, so the screenshots are about 800 px wide and the right-hand detail panel was not visible for most of the run).
- Agencies tried: Public Schools (`?agency=dpi`), Environmental Quality (`?agency=deq`), Health and Human Services (`?agency=dhhs`).
- No first-visit tour appeared (the browser already had state from earlier runs).
- **State caveat:** the browser already had **11 grants in the cart and 2 feedback items** from earlier sessions, so several cards already read "In my cart". I added one grant (Brownfield, DEQ) to test Pursue, then removed it. The Pursue click may still show in "My decisions".

---

## 1. First reaction (in character)

Dark green screen, a big "choose your agency" line, and then a chart box asking "Does the ranking work?" with percentages. I don't care whether it works in general; I want my grants. My agency, Public Schools, isn't in the "closing soon" shortcut list, so I use the dropdown. After that the page turns gold and gets very long. The top three cards are fine and the big "days left" number really helps. But each card has about 8 colored chips and then a second row of five "Is this match right?" buttons, and the same three cards show up again further down. Lots to read, and I'm still not sure which one I'm allowed to apply for.

---

## 2. Path to a grant

| Step | What I did | Clicks / scrolls | Where I hesitated |
|---|---|---|---|
| Home | Read the headline and skipped the "Does the ranking work?" chart panel | 0 | My agency is not in the 5 "closing soon" shortcuts, so I looked for the dropdown. "choose your agency" in green looks more like a heading than a control. |
| Pick Public Schools | Opened the dropdown and picked from 32 names | 2 clicks | Long list in A–Z order, fine. The page color changed to gold, which threw me for a second. |
| Plain-words box | Typed "school buses or reading help for kids, no matching money" | 1 click + typing + Enter | It showed "Looking for: school, bus, reading, child" and "2 filters on: showing 5 grants". Good feedback. **But the school-bus grant (DERA) disappeared** because it needs matching money. Nothing told me it was hidden for that reason. |
| Read top 3 | Read "Start here: your 3 best open matches" | 1 scroll | The #1 grant (S-STEM, scholarships) sounds like it's for colleges. "Tier 1: you can start" sits next to "Check eligibility" on almost every card. So can I or can't I? |
| Why it fits | Opened "Why it fits, odds and details" on S-STEM | 1 click, 3 scrolls | 20 rows. I read the first one ("Goal III-Increase educator preparedness…") and "Effort: Hard". The Effort row says it "usually needs a university or research partner" and then "You can start it yourself", which seemed to contradict itself. I stopped reading after Money. |
| Plan | Pressed "See my plan" (it was already in the cart) | 1 click, 2 scrolls | **The best screen in the tool.** Dates, steps, checkboxes. No hesitation. |
| Cart | Opened "My grants 11" | 1 click | The cart mixes agencies (Adult Correction, SBI, Public Schools) and the colors follow whatever agency I'm on now. Every row has about 10 lines. I could not find "my 2 for Public Schools" at a glance. |
| Switch to DEQ | Picked DEQ from the dropdown | 2 clicks | **My Public Schools search text and filters carried over** ("school buses…" was still in the box and only 3 grants were shown). I almost thought DEQ had only 3 grants. |
| DEQ search | Clear filters, typed "clean water and air quality, 6 weeks" | 3 clicks + typing | It pulled out "clean, water, quality" and dropped "air". 2 results. Brownfield (★★★ Won this before, Easy, $500K, 75 days) was a clear pick. |
| Pursue | "Pursue: add to cart" on Brownfield | 1 click | The plan opened right away. Good. Under 5 minutes for DEQ. |
| Switch to HHS | Dropdown, then the "Easy ones I can start myself" chip | 3 clicks | **The "Easy" chip gave me 3 "Hard · ~8 wks · Long shot" NIH research grants** with "Amount not listed". The chip it adds is "Only ones I can start myself", which is about who signs, not how easy it is. |
| HHS unfiltered | Cleared filters and scrolled the list | 1 click, ~6 scrolls | The grants I would actually go for (Preschool Development Grant B-5: ★★★, Good odds, $15M; OJJDP: Good odds) sit at #5 to #7, below four NIH research long shots. PDG says "Tight: needs ~8 wks" with 13 days left, and I don't know if that means give up. Ran out of my 5 minutes. |
| Swipe mode | Tried "Start swiping" | 1 click | Very clean (4 facts), but there's no "why it fits" line, so I can't decide from it. It says "1 of 20" when the list said 10. |

Rough total: Public Schools about 9 clicks and 9 scrolls, and I still wasn't confident. DEQ about 7 clicks and 2 scrolls, confident. HHS about 5 clicks and 6+ scrolls, and I didn't finish.

---

## 3. Dead-weight table

| # | Element (exact UI text) | Why it slows me down or adds noise | Verdict | Severity |
|---|---|---|---|---|
| 1 | "Is this match right? Good match / Wrong agency / We can't apply / Not useful / Something else" | 5 extra buttons on every card, repeated 13 times. It doubles the button count and competes with Pursue / Maybe / Pass. | Hide behind a link (one small "Feedback" link per card, or only after Pass) | High |
| 2 | "Start here: your 3 best open matches" followed by the same 3 cards again under "All matches" | I read the same three grants twice and thought the list was repeating. | Simplify (show the top 3 once, then start the list at #4, or drop the "Start here" copy) | High |
| 3 | Home panel "Does the ranking work?" / "Finding it early matters" / "Where it falls short" | Charts and percentages about the method before I've picked an agency. That's for judges and bosses, not me. | Hide behind a link ("How well does this work?") | High |
| 4 | Chip "Federal budget shrinking" | Sounds alarming, and I don't know what to do with it. It's on almost every NSF card. | Cut from the card (keep it in the details) | Medium |
| 5 | Chip "≈ Impact 86" | A number out of 100 with no scale on the card. "Plan fit 98 of 100 (60%) and award size 67 of 100 (40%)" is too technical. | Simplify or cut from the card | Medium |
| 6 | "Tier 1: you can start" next to "Check eligibility" | Two chips that seem to disagree. "Tier" is jargon for me. | Simplify (say "You can sign" and put eligibility first) | High |
| 7 | "New to NC" chip | Reads like a warning, but the details say "it is just new to us". | Cut from the card | Low |
| 8 | Chart "Where each grant lands: impact vs. work" | The quadrants are neat, but it says "9 grants are quick wins" while the top 3 cards say Hard. I didn't trust it. | Hide behind a link | Medium |
| 9 | "At a glance": "When they close" / "What the money is for" / "Who has to sign" / "Past wins" | 4 bar charts, 20 bars, all of it already on the cards. "Other $50M" and "Community develo…" are cut off. | Hide behind a link (keep "When they close" at most) | Medium |
| 10 | Chart "Money vs. time left" | A second scatter plot with a log scale ($100K / $1M / $10M). I skipped it completely. | Cut | Medium |
| 11 | Tabs "9 Best matches · open now / 0 Closing soon / 5 New / 8 Check eligibility / 10 Coming up" | Five tabs plus "Save this list…" and "What do these words mean?" sit below the charts, too far down to find. | Simplify (move above the cards, keep 3) | Medium |
| 12 | "Showing 9 best matches of 15 open grants loaded… Not shown: 118 grants your agency cannot apply for" | It says 118 for all three agencies, and the tab below says "Hidden as not eligible: 10". The numbers don't match, and the identical 118 looks like a bug. | Simplify, and check the number | Medium |
| 13 | Header buttons "Larger text / Projector view / Tour / Light mode / Give feedback" | 5 header buttons wrap onto a second line and push the content down. | Hide behind one "View" menu | Low |
| 14 | "State General Fund budget: $11.9B (FY 2025-26 base, OSBM)" | Not something I'd act on. | Cut, or move to the OSBM overview | Low |
| 15 | Card intro "Big number on the left: days left… Chips marked ≈ … are our own estimates." | A paragraph explaining the card. If a card needs a legend, it's too busy. | Simplify (one line, or a "?" icon) | Low |
| 16 | Details rows "Award ceiling", "Opportunity number", "Federal program number", "Keyword fit", "Automatic check of the announcement: unclear" | These repeat Money and "Why it is ranked here", or they're IDs I don't need. 20 rows in all. | Hide behind "More details" (keep 6 rows) | Medium |
| 17 | Cart rows "Federal budget" / "Vs. agency budget" | Each cart row is about 10 lines, so 11 grants means endless scrolling. | Simplify (title, days, $, who signs, Plan) | Medium |
| 18 | Preset chip "Clinical, 4 weeks" (HHS) | "Clinical" isn't my word. It sounds like hospital research. | Simplify (use the agency's own plan words) | Low |
| 19 | Per-agency color theme (gold, teal, pink) | It changes the whole page when I switch, and the cart takes on the current agency's color even when the grants inside belong to other agencies. | Simplify (one accent color; agency color on the icon only) | Low |
| 20 | "≈ $662K per week of work" chip | A clever idea, but it shows up on some cards and not others. I couldn't tell if more is better. | Cut from the card | Low |

---

## 4. The 5 things that helped me most (keep these)

1. **The big "days left" number** on the left of each card. It's the first thing I read every time.
2. **The step-by-step plan** ("Your timeline", then "What you will need" with checkboxes, then "Add deadline to my calendar"). It answers "what do I do next" in plain words.
3. **The plain-words box with echo chips** ("Looking for: clean, water, quality", "2 filters on: showing 2 grants", "Clear filters"). I could see what it understood.
4. **"★★★ Won this before"** plus the money on the right ("$500K max per award"). That's what made Brownfield an easy yes.
5. **"Pursue: add to cart"** going straight to the plan. One click from "I like this" to "here's what to do".

(A close sixth: the swipe card. Four facts and nothing else is the right density. It just needs one "why it fits" line.)

---

## 5. If I could keep only 8 things on the agency page (top to bottom)

1. Agency picker ("Show federal funding for ___").
2. Plain-words box with Apply, the echo chips and "Clear filters" (the 4 preset chips go behind "Examples").
3. A one-line count: "Showing N grants you can apply for · N closing in 2 weeks".
4. Three tabs: Best matches / Closing soon / Not sure we can apply.
5. Grant cards: days left, title, funder, money, **one** "why it fits" line quoting the plan, at most 3 chips (who signs, past wins, effort), and Pursue / Maybe / Pass.
6. "Why it fits and details" expander with about 6 rows.
7. The "My grants" cart button with its count (top right).
8. A small "How well does this work?" link to the method charts and the "Where it falls short" note.

Everything else (the 5 charts, the per-card feedback row, the duplicated top 3, the budget line, extra header buttons) goes behind a link or gets cut.

---

## 6. Specific notes

**Home screen.** I looked at "Show federal funding for / choose your agency" first, then the closing-soon shortcuts. I ignored the right-hand chart panel. "61 · 39%" and "Newest-posted alert" mean nothing to me before I've picked an agency. The shortcuts only list 5 agencies, none of them mine (all three test agencies were missing), so they felt like a dead end. The green "choose your agency" text doesn't look clickable until you notice the chevron at the far right. Competing items: about 9 (header buttons, tabs, picker, intro, 5 shortcuts, 3 chart blocks).

**Ticket-stub card.** What I actually read, in order: the days-left number, the title, the money on the right, "Tier 1: you can start" (and I got confused by "Tier"), "★★★ Won this before" when it was there, and "≈ Easy · ~2 wks". I skimmed "≈ Fair odds". I ignored "≈ Impact NN", "New to NC", "Federal budget shrinking", "New", and "≈ $NNNK per week of work". "Check eligibility" worried me, but it's on nearly every card, so it stopped meaning anything. The dashed versus solid chip borders (estimate versus fact) went right past me. The "$120M total · ~60 awards" line under the money was useful for odds. The "Is this match right?" row is visually as loud as the action buttons and made each card about twice as tall.

**Charts.** I used none of them to pick a grant. "Where each grant lands" looked friendly ("Quick wins" box) but disagreed with the cards ("9 quick wins" while the top 3 were Hard). "At a glance" repeats what the cards already show, and the labels are truncated ("Community develo…", "Science and techn…", "★★★ Won this b…"). I skipped "Money vs. time left": log scale, odds colors in four nearly identical greens. The home "Finding it early matters" line chart is for a boss, not for me. If one chart stays, keep "When they close", because time is my constraint.

**Cart.** The top summary ("$26M up to, if every one is won", "~48 wks of work", "9 days until the next deadline") is nice. "~48 wks of work" scared me but is useful. Problems: it mixes agencies with no grouping, each row has 10 detail lines, the "Plan" button is the only thing I want, and "Compare the ones I ticked (2 to 4)" needs checkboxes I didn't notice. "Saved in this browser only" is good to know. Suggest grouping by agency, collapsing each row to one line, and keeping "Save my cart…".

**Colors and background.** The dark navy/charcoal background with one accent color per agency is readable, but the page feels heavy and "techy" for a state staffer. The theme switch (green on home, gold for Public Schools, teal for DEQ, pink for HHS) made me think I'd gone to a different page. The cart and swipe screens pick up the current agency color even when the grants inside belong to other agencies. Red/orange is used for "Hard · ~8 wks", "Tier 3: leadership signs", "days" in the cart and the "Closing soon" chart band, so red doesn't mean one thing. Suggestion: default to light mode for this audience, keep one accent color, and save red for "closing within 14 days".

---

## Content issues noticed in passing (not layout, but they hit trust)

- Public Schools #1 is "NSF Scholarships in STEM (S-STEM)" with keyword fit 98/100. It's a college program. "REAP for Health Professional Schools" also shows up for Public Schools.
- Typing "school buses" removed the one school-bus grant (DERA) because of "no matching money", and nothing said so.
- In HHS, NIH research long shots with "Amount not listed" rank above Preschool Development Grant B-5 (★★★, Good odds, $15M).
- "rank 1 of 925 open eligible items" in the details versus "14 open grants loaded" in the list summary. "118 grants your agency cannot apply for" appears for all three agencies.
- Filters and the search text carry over when you switch agencies.
