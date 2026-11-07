# 37 Design critic: feature audit of the Matchmaker tool (Sat Nov 7, 2026)

Reviewer: Claude (Opus 5.5) acting as a senior product designer. This is a simulated expert review, not user evidence. Site: http://localhost:8765/ (source `Finalists/src/tool/matchmaker.html`). Checked at 1440x900 and at the 375x812 mobile preset, in light and dark mode, with Department of Health and Human Services (DHHS) as the test agency. The tour was skipped. I opened every dialog without submitting anything. I made no Pursue/Pass marks and restored the theme to dark, as I found it.

Measured on DHHS at 1440 wide: the "All matches" heading sits **3,746 px** down the page, about 4.2 screens. The 3 "Start here" cards take 1,368 px, and the same 3 grants appear again at the top of All matches. The 390 px desk panel on the right stays empty ("Select a grant...") for the whole 8,656 px page until someone clicks a card body, and nothing tells them to. On mobile the list starts at **5,343 px**, about 6.6 screens down, and one card is about 790 px tall.

---

## 1. Verdict

The engine works, but the interface makes people dig for it. A staffer picks an agency and gets a hero picker, a plain-words box with 12 hidden dropdowns, a swipe banner, three cards about 450 px tall, a scatter, four bar charts, a second scatter, and only then the list. That same list starts with the three cards they already saw. Each card carries about 7 colored chips (up to 8), 8 buttons and a feedback row, in 6 to 8 hues and 3 border styles. The agency color theme also gets mixed up with what the colors mean: for DHHS, "Fair odds" is pink like a warning, and for Public Schools the main color is the exact amber used for "warning" and "Tier 2". On wide screens the best real estate goes to an empty side panel while the scatter is squeezed into the middle column. The scatter is mostly empty space: one axis has only four possible values, the bottom 40% of the chart has no dots, half the dots are grants that aren't open yet, and clicking those does nothing. Lots of these features are good ideas (Pursue plan, compare, save, past wins). They are just all shown at once, at the same volume. Cut about a third, push another third behind a "details" or "more" link, and get the page to show grant #1 within the first screen.

---

## 2. Feature inventory

Evidence column = how much the feature helps a staffer *find and pick* grants (high / med / low / none). Recommendation: keep / simplify / move / hide behind link / cut.

| # | Feature / element (exact UI text) | Where | Job for the user | Evidence | Rec. | Reason |
|---|---|---|---|---|---|---|
| 1 | "Federal Funds Matchmaker" + "Federal grants ranked against each NC agency's own plan" | Top bar | Identity | low | simplify | Drop the subtitle once an agency is picked; the bar takes 2 rows at 1440 and 3 rows (260 px) on mobile. |
| 2 | Agency icon in the bar and the 58 px icon next to the picker | Bar, picker | Decoration | none | cut (picker icon) | It looks like a button but isn't, and it changes color with every agency. |
| 3 | "My grants" cart button with count | Top bar | Open your shortlist | high | keep | This is the main way back to your shortlist. Make it the only filled button in the bar. |
| 4 | "Data updated Nov 7, 11:00 AM" with green dot | Top bar | Trust and freshness | med | simplify | It looks like a pill button but isn't. Make it plain text with no outline. |
| 5 | "Give feedback" with count badge | Top bar | Collect feedback | none (for finding) | move | Move to the footer or the How tab. The yellow badge competes with the cart badge. |
| 6 | "Dark mode" / "Light mode" | Top bar | Theme | none | move | Follow the OS setting by default; keep a small icon button. |
| 7 | "Larger text" | Top bar | Accessibility | low | move | Put it in one "View" menu with theme and projector. |
| 8 | "Projector view" | Top bar | Demo/meeting mode | low | hide behind link | Only for the presentation; keep the `p` shortcut. |
| 9 | "Tour" | Top bar | Onboarding | low | move | A "?" icon is enough. |
| 10 | Tabs: "Opportunities", "OSBM overview", "My decisions", "More ▾" | Under bar | Navigation | med | simplify | "More ▾" doesn't open a menu; it adds three more tabs to the row. "My decisions" and the cart overlap. |
| 11 | Hero picker "Show federal funding for / choose your agency" | Top | Pick agency | high | keep, shrink | Keep it as the first step. After an agency is picked, shrink it to a 1-line header (it is 181 px now). |
| 12 | "State General Fund budget: $7.9B (FY 2025-26 base, OSBM)..." | Under picker | Context | low | hide behind link | Doesn't help find a grant; budget directors can see it in details. |
| 13 | Home lede "This scores 1,576 open federal opportunities..." | Home | Explain the tool | med | keep | Clear. |
| 14 | "Or start with an agency that has grants closing soon" quick buttons | Home | Fast start | med | keep | Good shortcut; make the buttons the same size, since one wraps to 2 lines. |
| 15 | "Does the ranking work?" evidence bars (This tool 61 · 39% ...) | Home, right | Build trust | low (for users), high (for judges) | move | Move to the How tab with a one-line link from home. Users came to find grants, not to audit the ranking. |
| 16 | "Finding it early matters" in-time curve | Home, right | Argue for refresh | none | move | Belongs in How this works / the pitch. |
| 17 | "Tell us your situation in plain words" + "Apply" | Finder | Set filters from a sentence | med | keep, simplify | Good idea for non-experts. Combine it with keyword search into one search box. |
| 18 | Example buttons "Clinical, 4 weeks", "Easy ones I can start myself", ... | Finder | Show what to type | med | keep | The dashed outline makes them look like placeholders. Make them solid pills. |
| 19 | Parsed chips (`#chips`) | Finder | Show what the sentence set | med | keep | Needed so people can see why the list changed. |
| 20 | "More options: keyword search, sort, who signs, money, time, odds, funder" (12 controls) | Finder | Power filtering | med | simplify | 12 dropdowns, and at 1440 the values are cut off ("Best match to", "We might hav", "$ amount, bla"). Keep Sort, Who signs, Minimum award and Weeks; put the rest in a drawer. |
| 21 | "Clear filters" + count line (`#f-count`) | Finder | Reset | high | keep | |
| 22 | "Start swiping" banner | Above Start here | Triage one card at a time | med (mobile), low (desktop) | move | Turn it into a small button beside the list heading. Right now it is a filled CTA in a full-width tinted band and pulls the eye first. |
| 23 | Swipe mode (cards, ✕ / ? / ♥, Undo, keys) | Overlay | Quick triage | med | keep | Says "1 of 20" when only 10 grants are open, so it mixes in grants that aren't open yet. The card has a lot of dead space. |
| 24 | "Start here: your 3 best open matches" + 3-line note | Main column | Short answer first | high | simplify | Good intent, but these are the same 3 grants that open All matches. Make them the first 3 rows of the list with a "Top 3" divider. |
| 25 | "Where each grant lands: impact vs. work" scatter | Main column | See tradeoffs | med (could be high) | move + redesign | See section 4. |
| 26 | "At a glance" (4 small bar charts: When they close, What the money is for, Who has to sign, Past wins) | Main column | Facet counts and filters | med | simplify | These are filters dressed up as charts. Turn them into a row of count chips above the list. With 10 to 20 grants, 4 charts is overkill. "Past wins" labels are cut off ("★★★ Won this b..."). |
| 27 | "Money vs. time left" scatter + "Table view" | Main column | Money vs. deadline | low | cut | Draws 4 of 10 grants ("6 grants ... are not drawn"). The deadline is already the big number on every card. |
| 28 | "All matches for this agency" heading | List | Start of the list | high | move up | Should be within the first screen. |
| 29 | View tiles "10 Best matches · open now", "3 Closing soon", "0 New", "0 Check eligibility", "10 Coming up" | List | Switch list views | high | keep, simplify | Good. Disable or hide tiles showing 0. They are the same pill shape as the chips you can't click. |
| 30 | "Save this list…" | Toolbar | Export | med | keep | It sits apart from the cart's "Save my cart…". Have one Save. |
| 31 | "What do these words mean?" | Toolbar | Glossary | med | keep as link | Make it a text link, not a pill. |
| 32 | Count line "Showing 10 best matches of 13 open grants loaded... Not shown: 118..." | List | Explain what's hidden | med | simplify | Contradicts itself: 118 hidden here, "Hidden as not eligible: 10" at the bottom, and "rank 5 of 925" in a card's details. |
| 33 | Ticket-stub card (`li.row`) | List | One grant | high | simplify | See section 3. |
| 34 | Title link to Grants.gov (↗) | Card | Open the source | high | keep | Fine, but on desktop clicking the title leaves the app while clicking the card body opens the side panel. Make the card open the panel and use one clear "Open on Grants.gov" button inside it. |
| 35 | "Why it fits, odds and details" drawer (about 25 fields) | Card | Evidence | high | move | On desktop it should live only in the side panel. Today the panel copies the entire drawer *and* every chip. |
| 36 | "Pursue: add to cart" / "Maybe" / "Pass" | Card | Decide | high | keep | When Pass is pressed it turns solid black and becomes the loudest thing on the card. Pursue is only an outline. Flip that. |
| 37 | "See my plan" (after Pursue) | Card | Open plan | high | keep | |
| 38 | "Is this match right?" + 5 buttons (Good match, Wrong agency, We can't apply, Not useful, Something else) | Every card | Ranking feedback | none for the user | hide behind link | Five extra buttons × 10 cards = 50 buttons. Make it one "Flag this match" link that opens the choices. |
| 39 | "Copy one-page brief" | My decisions cards | Brief for the boss | med | keep | Tiny, unstyled; move into the plan dialog. |
| 40 | Desk side panel "Select a grant to see the full record" | Right column ≥1100 px | Details | high | keep, redesign | Stays empty until a card body is clicked, and nothing hints that you should. Auto-select row 1, and show the chart here before anything is selected (section 5). |
| 41 | Pursue plan dialog (4 fact boxes, buttons, timeline, "What you will need") | Dialog | Plan the application | high | keep | Strongest feature. The timeline puts "Read the whole announcement" on day 34 and "Check your logins" on day 68 of a 342-day window. Those should come in week 1. |
| 42 | "Add deadline to my calendar", "Save or print my plan…" | Plan dialog | Act | high | keep | |
| 43 | Cart side sheet ($26M, ~48 wks, 9 days summary; 11 detail fields per item; Plan/Remove) | Dialog | Shortlist | high | simplify | Adds grants from other agencies together (Adult Correction items while viewing DHHS). Each item is an 11-field mini dossier. Show title, days and amount; put the rest behind "details". |
| 44 | "Compare the ones I ticked (2 to 4)", "Compare my 5 maybes" | Cart | Compare | med | keep | |
| 45 | Compare table | Dialog | Side by side | med | simplify | Highlight the best value in each row. 14+ rows with no emphasis right now. |
| 46 | Save menu: PDF / Word (.docx) / Excel (.csv) / Calendar (.ics) / Plain text | Dialog | Export | med | simplify | The "XLS" icon is shown for a .csv file. Five formats is too many; keep PDF, Excel and Calendar. |
| 47 | Feedback dialog (Yes/Somewhat/No, 2 fields, "Open the team feedback form", "Download all") | Dialog | Pilot feedback | none for finding | keep (moved) | Fine for the pilot; take it out of the top bar. |
| 48 | Feedback toast after Pursue | Toast | Quick question | none | cut | Interrupts the main success moment. |
| 49 | "Words used here" glossary panel | Bottom | Definitions | med | keep | No disclosure arrow (`summary{display:flex}` hides it), so it doesn't look like it opens. |
| 50 | "Refine (optional)": 3 checkboxes, 4 presets, date/runway/min award, research hide, goal weight sliders, assumptions | Bottom | Power-user tuning | low | hide behind link | Repeats what More options does. Slider labels show the prefix twice: "PRIORITY 3: PRIORITY 3: ...". |
| 51 | "Who controls what here: 14 capabilities" | Bottom | Agency capability table | low | move | Move to the How tab or the agency profile. |
| 52 | "Coming up (not open yet): 10" with search | Bottom | Forecasts | med | keep | It's already a tile (#29). Drop the duplicate panel. |
| 53 | "Hidden as not eligible: 10" with search | Bottom | Transparency | med | keep | Cards here still show "Pursue: add to cart" and "Tier 1: you can start" next to "Can't apply". |
| 54 | Agency color themes (13 palettes) | Global | Show which agency you're in | low | cut | Clashes with the colors that carry meaning (see section 6). Keep one accent color; the agency name already says where you are. |
| 55 | OSBM overview tab (5 stat tiles, "Who should apply together?", agency table) | Tab | Statewide view for the sponsor | low (for a staffer), med (for OSBM) | keep | Fine for the sponsor. The stat tiles look like cards you can click but aren't. |
| 56 | My decisions tab (exports, "Clear all", agreement note, list) | Tab | Review marks | med | simplify (merge with cart) | Two places hold your decisions. "Clear all" is styled like the export buttons next to it. |
| 57 | "Export decisions CSV", "Copy briefs for all Pursue items", "Download deadlines (.ics)" | My decisions | Export | med | merge | These repeat the Save menu. |
| 58 | Match board tab (goals ↔ grants, "Add project") | More | Explore by goal | low | hide behind link | Defaults to "All NC" while showing Public Schools goals. Confusing. |
| 59 | County map tab (18 measures, ten highest counties) | More | Need context | none (for finding) | hide behind link | No legend and no link to grants; it says itself it "does not say a grant reaches that county". |
| 60 | How this works tab | More | Method and limits | low (users), high (judges) | keep | Good home for the evidence bars and the in-time curve. |
| 61 | Print sheet for a supervisor | Print | Paper brief | med | keep | |

---

## 3. The ticket stub card

### Everything on one card today (DHHS, row 5: "OJJDP FY 2026 Juvenile Justice System Enhancements")

Colors are the light-theme computed values with the DHHS palette.

| # | Element | Text | Color |
|---|---|---|---|
| 1 | Stub background | — | peach `--stub-urgent #fbe9e3` (urgent) / grey `#f1f4f1` |
| 2 | Dashed tear line + 2 punched notches | — | `--border #d8ddd8`, notches show the page color |
| 3 | Days number | "9" | brick `--bad #a93a22` (urgent) or agency maroon `#8f2c4f` |
| 4 | "days left" | — | muted `#66717a` |
| 5 | Title link + ↗ icon, 2 px underline | "OJJDP FY 2026 ..." | maroon `#8f2c4f` |
| 6 | Funder | "Office of Juvenile Justice ..." | slate `#46525c` |
| 7 | Money big number | "$1.3M" | ink `#16232e` |
| 8 | "max per award" | — | muted |
| 9 | "$4M total · ~3 awards" | — | slate |
| 10 | Chip: Impact | "≈ Impact 53" | solid maroon, white text, dashed border |
| 11 | Chip: Tier | "Tier 1: you can start" | green on mint (`#1f6b2a` / `#dcefdf`), square dot |
| 12 | Chip: Odds | "≈ Good odds" | solid dark teal `#14594a`, white text (Fair = pink accent-soft, Long = grey with ring dot) |
| 13 | Chip: Effort | "≈ Easy · ~2 wks" | green text on grey, dashed (Hard = brick) |
| 14 | Chip: Payoff | "≈ $662K per week of work" | ink on transparent, dashed outline |
| 15 | Chip: Past wins | "★★☆ NC has won it" | maroon on pink (s2) / green (s3+) / grey |
| 16 | Chip: Eligibility | "Can apply" | green on grey (Check = amber, Can't = brick) |
| 17 | Chip: Warning | "Tight: needs ~2 wks" | brick on salmon `#f8e1da` |
| 18 | Drawer summary | "Why it fits, odds and details" | maroon, chevron |
| 19 | Button | "Pursue: add to cart" | maroon outline |
| 20 | Button | "Maybe" | grey outline |
| 21 | Button | "Pass" | grey outline (solid black `#16232e` when pressed) |
| 22 | Dashed divider | — | `--rule` |
| 23 | Label | "Is this match right?" | muted |
| 24-28 | 5 feedback buttons | Good match / Wrong agency / We can't apply / Not useful / Something else | grey outline |

Totals: about **28 visible pieces**, 8 chips (6.7 on average across the 10 rows), 8 buttons, **8 distinct hues** (maroon, brick, green, dark teal, pink, amber, slate, ink) plus peach and grey fills, and **3 border styles** (solid, dashed "≈ estimate", dashed tear line). Card height is 368 to 456 px on desktop and about 790 to 850 px on mobile, where every chip gets its own line.

Also broken in what the card says: "Tight: needs ~2 wks" shows on a grant with 9 days left, and on another with 13 days left vs. ~8 weeks of work. That second one is impossible, not "tight", yet it still shows a payoff per week. The ≈ dashed border means "estimate", which nobody will work out. In the DHHS palette "Fair odds" is pink like the warning chip, so it reads as bad.

### Proposed card (5 pieces of information, 2 colors plus 1 alert color)

```
┌──────────────────────────────────────────────────────────────────────┐
│  9 days      OJJDP FY 2026 Juvenile Justice System Enhancements       │
│  Nov 16      Office of Juvenile Justice · up to $1.3M per award       │
│  (red ≤14)   ✓ You can apply  ·  You can start it (no sign-off)       │
│              Fits: "Strengthen Behavioral Health Crisis Care..."      │
│                                        [ Pursue ]  Maybe   Pass       │
└──────────────────────────────────────────────────────────────────────┘
```

1. **Days left** (big number + date). Ink color; brick only when ≤14 days. No punched notches and no tinted stub; a thin left rule is enough.
2. **Title** (ink, semibold, not underlined; underline on hover) + **funder · amount** on one muted line.
3. **One status line** joining eligibility and who signs, written as words. Green tick only for "You can apply", amber "Check eligibility", no chip shapes.
4. **The plan goal it matches**, as one quoted line. This is the "why" a non-expert needs, and it's buried in the drawer today.
5. **Actions:** Pursue (solid accent), Maybe and Pass (text buttons). A pressed Pass should dim the whole card, not fill the button black.

**Goes to the side panel (desktop) or a "Details" dropdown (mobile):** Impact score, odds, effort weeks, payoff per week, past-wins stars, federal budget trend, size vs. agency budget, total funding / number of awards, opportunity number, program number, keyword fit and rank, summary, the "Tight" warning (shown as one sentence in the panel: "Needs about 2 weeks of work; 9 days left"), and the "Is this match right?" feedback (one "Flag this match" link in the panel).

Optional 6th piece, only if the team insists: a single word "Past winner" when NC has won this program (★★★/★★), because that is the one estimate staffers in discovery said they care about.

---

## 4. Charts

### Critique of each

| Chart | What's wrong | Verdict |
|---|---|---|
| **Impact vs. work scatter** ("Where each grant lands") | See the detailed critique below. | Keep one scatter, redesigned |
| **At a glance** (4 bar charts) | These are facet counts (closing time, need type, who signs, past wins). Bars for counts of 0 to 9 add nothing over the number. Labels get cut off ("★★★ Won this b..."). "What the money is for" mixes sums with "amount not listed · 5". The bars use the agency color, so for DHHS the "Next week" bar is brick and everything else maroon. Clicking a bar filters, but nothing says so beyond small note text. | Replace with a row of count chips that filter the list |
| **Money vs. time left** scatter | Draws 4 of 10 grants. The x axis runs 0 to 150 days with 3 dots crowded at the left edge. Log y axis from $100K to $100M with no gridline labels in between. Duplicates the days and money already printed large on every card. Has its own odds color legend that differs from the other scatter's encoding. | Cut |
| **Evidence bars** ("Does the ranking work?") | Clean and honest; a gray vs. accent comparison is the right form. But it sits in the space reserved for the first action on the home screen, and mixes "61 · 39%" with "19.7%" formats. | Keep, move to How this works |
| **In-time curve** ("Finding it early matters") | Only 3 x-points (2, 4, 6 weeks), end labels clip at the right edge at 800 px, and it argues a point for judges, not a staffer. | Move to How / slides |
| **County map** | No legend or scale, single-hue maroon (DHHS color) so it changes per agency, can't be connected to any grant, and "Ten highest counties" is a bare list. The map itself says it doesn't show reach. | Hide behind "More"; add a legend if kept |

### The one chart that best helps finding grants

**The impact vs. work scatter**, redesigned as a "payoff vs. effort" map of the open list. That's the sponsor's own framing ("rank by payoff versus effort, not fit alone"), and it's the only chart that answers "which of these should I do first?" faster than reading the list. Every other chart either repeats card fields or counts things.

### Why the current scatter reads badly (concrete)

- **The x axis is 4 buckets, not a scale.** Easy / Medium / Hard / Not known come from just two inputs (who signs, matching money), so all dots fall into vertical strips with random sideways jitter. On DHHS: 10 dots in the Easy column, 2 in Medium, 8 in Hard, 0 in "Not known". A quarter of the plot is an empty "Not known" column.
- **The y scale wastes 40% of the height.** Impact runs 0 to 100 but every DHHS dot is between about 40 and 100. The "Small extras" and "Probably skip" corner labels sit in empty space.
- **Half the dots aren't actionable.** 10 of the 20 dots are forecasts (dashed "Not open yet"). They count toward "9 grants are quick wins" and are drawn in the Quick wins box. **Clicking them does nothing**, because the jump handler only looks in `#top`, which holds no forecasts. I confirmed this: the scroll position didn't change.
- **Overplotting.** 4 overlapping pairs inside the Easy column; dashed hollow circles on top of each other read as a smudge.
- **Size barely encodes anything.** Radius is 5 / 7 / 9 px for <$100K / ≥$100K / ≥$1M. That 3-step difference is hard to see, and "amount not listed" also draws at 5 px, so "unknown" looks like "small".
- **Color carries nothing.** All dots are the agency accent color. Urgency is a 3 px brick outline that disappears at small radius, especially in dark mode where the accent is pink.
- **No labels.** You have to hover each dot to know what it is, and hovering doesn't work on touch.
- **Text is too small and collides.** Axis text is 11 px (about 7 px after SVG scaling at 560 px wide). On mobile the x labels overlap ("Easy (~2 wkMedium (~4 wkHard (~8 wks) Not known").
- **Placement.** It sits under 1,368 px of cards in the 782 px main column, far from the list it's meant to navigate, while the 390 px right column is empty.

### Redesign spec (right-hand column, wide screens)

- **Place:** the right column (about 400 px wide, sticky at `top:16px`). It shows *before* a grant is picked, in the panel's empty state; the panel turns into details when a card is selected, with a "Back to map" link. Height about 340 px. Below 1100 px it collapses to a "Show map" toggle above the list (closed by default on mobile).
- **Data:** open, eligible-or-unclear grants in the current filtered list only. No forecasts (they get their own tile).
- **X axis: days left** (0 to 90, linear, with ">90" stacked at the right edge). Label: "Days left to apply". Shade a brick band from 0 to 14 days labeled "Closing soon". Time is the sponsor's key constraint and it's continuous, so the dots spread out.
- **Y axis: award ceiling**, log scale with $100K / $1M / $10M ticks. "Amount not listed" goes in a separate 24 px strip under the axis, labeled, so unknown never looks small.
- **Mark:** circles 8 px (14 px for the top 3). **Fill = effort**, using 3 steps of one sequential ramp (Easy dark, Medium mid, Hard light). **Ring = eligibility unclear** (amber dashed ring). No size encoding.
- **Labels:** the list's rank number (1 to 10) printed inside or next to each dot, so the chart and the list share an index. Rank numbers also appear on the cards.
- **Interaction:** hovering a dot highlights the matching card (and the reverse); clicking selects the card and opens the details panel; arrow keys move through dots in rank order. Brushing a region filters the list ("Show these 4"), with a visible "Clear" button.
- **Caption (one line):** "Top-left = more money, closing sooner. Numbers match the list." Drop the 4-quadrant labels.
- **Type:** 13 px axis labels, 12 px tick labels, `--text-secondary`; gridlines `--rule` at 1 px; no chart border.
- **Accessibility:** a "Table view" toggle stays; each dot gets an aria-label listing rank, title, days and amount.

---

## 5. Layout proposal

### Wide screens (≥1100 px)

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ▣ Federal Funds Matchmaker   [Agency: Health and Human Services ▾]  Data Nov 7│
│                                                    [My grants 11]  ☰ View  ? │
├──────────────────────────────────────────────────────────────────────────────┤
│ Opportunities   Coming up (10)   My grants   OSBM overview   More ▾          │
├───────────────────────────────────────────────┬──────────────────────────────┤
│ [ Search or describe: "4 weeks, no match..." ]│  Where your grants land       │
│ Sort: Best match ▾  Who signs ▾  Min $ ▾  ⋯   │  $10M ┤      ③               │
│ Closing soon 3 · Can start 9 · Past wins 3    │   $1M ┤ ①  ②     ⑤           │
│ ─────────────────────────────────────────────│ $100K ┤▒▒▒④        ⑦  ⑨      │
│ TOP 3                                         │       └▒▒▒──────────────     │
│ ┌ 9d │ ① OJJDP Juvenile Justice ...  $1.3M ─┐ │        0  14   45   90+ days  │
│ │    │ ✓ Can apply · You can start          │ │  ● easy ◐ medium ○ hard       │
│ │    │ Fits: "Behavioral Health Crisis..."   │ │  n/a: ⑥ ⑧ ⑩                  │
│ └────┴──────────────── [Pursue] Maybe Pass ─┘ │ ───────────────────────────── │
│ ┌ 13d│ ② Preschool Development B-5 ...  $15M┐ │  (click a card → this column  │
│ ...                                           │   becomes the full record:    │
│ ALL MATCHES (10)            [Swipe] [Save…]   │   why it fits, odds, effort,  │
│ ④ ... ⑤ ... ⑩                                 │   past wins, plan, Grants.gov)│
│ ─────────────────────────────────────────────│                               │
│ Not eligible (118) ▸   Words used here ▸      │                               │
└───────────────────────────────────────────────┴──────────────────────────────┘
   left: minmax(0,1fr), max 760 px                right: 400 px, sticky
```

- The picker moves into the header after the first choice (it stays the hero on the home screen only).
- The first card shows at about 260 px from the top, not 790 px.
- At a glance turns into the one row of count chips under the filters; clicking one filters.
- Money vs. time is cut; the evidence charts and county map move to "More".

### Mobile (375 px), in order

1. Compact bar: app icon, agency name (tap to change), cart icon with count. Everything else goes in a ☰ menu.
2. Search / plain-words box (1 line) + "Filters (2)" button that opens a bottom sheet.
3. Count chips, scrolling sideways: Closing soon 3 · Can start 9 · Past wins 3.
4. List: top 3 then the rest, using the 5-piece card (about 200 px tall). "Details" expands in place.
5. "Swipe through these" button, sticky at the bottom, as a mobile-only mode.
6. "Show map" toggle (closed by default).
7. Footer links: Coming up, Not eligible, Words used here, How this works, Feedback.

---

## 6. Visual polish

What makes it feel unpolished:

1. **The background fights the cards.** The page is `#f6f7f5` and cards are `#ffffff` with a `#d8ddd8` border *and* a shadow, and every section (finder, scatter, glance, money chart, five bottom panels) is its own bordered, shadowed card. That gives 9+ stacked boxes with the same weight, no grouping, and gray gutters between them. In dark mode the page `#111a1f` and surface `#18242a` are so close the borders do all the work. The stub tickets add punched holes that show the page color through the card, which looks like a bug at a glance.
2. **Too many colors carry meaning, and they collide with the agency palette.** The base system has ink, slate, muted, accent, good, warn, bad, t1, t2, t3, c-good, c-fair, c-long, star-gold `#b8860b` and cart-yellow `#f2c14e`. Then a per-agency accent replaces `--accent` / `--accent-soft`:
   - Public Schools ("schoolbus") accent `#8a5a00` = **exactly** `--warn` and `--t2`. Every link, the Impact chip and the Pursue button become "warning amber".
   - Fire Marshal accent-soft `#f8e1da` = **exactly** `--bad-soft`.
   - DHHS accent-soft `#f6e1e8` is almost the same as Tier 3 `#f6e1ee`, so "Fair odds" and "Tier 3" look like the same thing as the accent.
   - In dark mode the DHHS accent `#efa2bd` is bubblegum pink on near-black. All links, the swipe CTA and every chart turn pink.
3. **Too many pill shapes.** Tiles, view buttons, toolbar buttons, example buttons, chips you can't click, feedback mini buttons, Pursue/Maybe/Pass, quick-start agencies: they're all `border-radius:999px` pills with a 1 px border. Nothing tells you what's interactive or which button matters most.
4. **The type scale has no rhythm.** I counted font sizes of .62, .72, .76, .78, .8, .82, .84, .85, .86, .88, .9, .92, .93, .95, 1, 1.02, 1.05, 1.06, 1.08, 1.1, 1.12, 1.15, 1.25, 1.3, 1.35, 1.4, 1.75, 2, 2.5 and 3rem, plus weights 300 / 400 / 500 / 600 / 650 / 700 / 750 / 800. Small label sizes sit .02rem apart, so the eye reads them as noise.
5. **Borders are both solid and dashed.** Solid, dashed "≈ estimate", the dashed stub tear line, dashed example buttons, dashed tiles and dashed dividers between actions and feedback all appear at once.

Specific fixes (token values):

```css
:root {
  /* one surface step, no shadow on in-page cards */
  --paper:#ffffff; --surface-2:#ffffff; --surface-3:#f4f6f5;   /* page = card; group with rules, not boxes */
  --border:#e3e7e4; --rule:#eef1ef;
  --shadow:none;                       /* keep shadows only for dialogs and the sticky panel: 0 1px 3px rgba(16,24,32,.08) */
  --radius:12px; --radius-sm:8px; --radius-pill:999px; /* pills ONLY for buttons */

  /* one fixed accent (no per-agency recolor) + 3 status colors */
  --accent:#1d5a4c; --accent-strong:#14443a; --accent-soft:#e7f1ed;
  --ok:#1f6b2a;  --ok-soft:#e3f2e5;
  --warn:#8a5a00; --warn-soft:#fdf3dc;
  --bad:#a93a22; --bad-soft:#fbe7e1;
  /* drop: t1/t2/t3, c-good/c-fair/c-long, star gold, cart yellow → use --ok/--warn/neutral */

  /* type scale: 5 sizes, 3 weights */
  --fs-xs:.8125rem;  /* 13px meta, chips */
  --fs-sm:.9375rem;  /* 15px body small */
  --fs-md:1.0625rem; /* 17px body, card title */
  --fs-lg:1.375rem;  /* 22px section heads */
  --fs-xl:2rem;      /* 32px days number, picker */
  /* weights: 400 / 600 / 750 only */
}
@media (prefers-color-scheme: dark) { :root:not([data-theme="light"]) {
  --paper:#0f1518; --surface-2:#161e22; --surface-3:#1d272c;   /* bigger step between page and card */
  --border:#2a363c; --rule:#20292e;
  --accent:#7cc4ad; --accent-soft:#183029;   /* fixed pine in dark too, never pink */
}}
```

- Show the agency in the header text and the icon only. Don't recolor the app.
- Cut the stub notches and the dashed tear line; use a 4 px left bar in `--bad` only when ≤14 days.
- Use section headings and 32 px spacing to group things instead of a bordered card per section. The list cards are the only boxed things in the left column.
- Replace "≈ dashed border = estimate" with the word "est." in muted text in the side panel, so it never appears on the card.
- Remove `cursor:default` pill styling from info chips; info shows as plain inline text with a middle-dot separator.

---

## 7. Clickability audit

### Looks clickable but isn't (or does nothing)

| Element | Why it looks clickable | Evidence | Fix |
|---|---|---|---|
| All card chips (`.c2`: Impact, Tier, Odds, Effort, Payoff, Past wins, Can apply, Tight) | Same pill shape, fill and size as the view tiles and filter buttons; colored dots read as toggles | computed `cursor: default`, no handler | Make them plain text (section 3), or make each a filter (click "Tier 1" → filter Tier 1) |
| "Not open yet" dots in the impact-vs-work scatter | `cursor:pointer`, `tabindex=0`, hover grows the dot, the note says "Click a dot to jump to it" | jump looks only in `#top`; forecasts aren't there, so the scroll didn't move | Drop forecasts from the chart, or route to the Coming up list |
| "Data updated Nov 7, 11:00 AM" | Sits in the bar between two outlined pill buttons, with a status dot | plain span | Make it plain text, no pill neighbors, or a link to "How fresh is this?" |
| Agency icon tile next to the picker (58 px rounded square) | Looks like an app or icon button | `role="img"` | Cut |
| Chart legends ("A grant", "Bigger award", "Closing soon", "Not open yet"; "Good odds", "Fair odds"...) | Swatches with labels in a row look like toggle filters | static spans | Leave as a muted caption under the chart, or make them toggles |
| Quadrant labels "Quick wins", "Big bets" | Bold green or gray text in a tinted box, like a button | SVG text | Cut (see redesign) |
| OSBM overview stat tiles (32 agencies, 251 open, 64 closing, 50 shared, 41 decisions) | Bordered cards with big numbers, the dashboard pattern for drill-down | no handler | Make "64 closing in 14 days" and "50 shared" links to filtered views |
| Money / days stub on cards | Large bold numbers in their own column | no handler | Fine once the whole card opens the side panel; make the card clickable on mobile too |
| "Ten highest counties" list (County map) | County names look like they should link | plain `<li>` | Link to highlight on the map |
| The "Start here" note text "Press Pursue to add a grant to your cart" | Instruction text that suggests the first card is already selected | — | Cut the note; the button explains itself |

### Clickable but doesn't look it

| Element | What it does | Why it's missed | Fix |
|---|---|---|---|
| Card body on desktop (≥1100 px) | Opens the full record in the side panel | No hover cue beyond a faint border change; the title link goes elsewhere (Grants.gov); the empty panel says "Select a grant" but doesn't say how | Make the whole card a button with a hover background `--surface-3`, auto-select row 1, and show "Click a grant" with an arrow |
| Bottom panels "Words used here", "Refine (optional)", "Who controls what here", "Coming up", "Hidden as not eligible" | Expand | `summary{display:flex}` removes the disclosure triangle, so they look like static headings in boxes | Add the same chevron the drawer uses (`details.drawer summary::before`) |
| "At a glance" bars | Filter the list to that bucket | Look like a static report; only small note text says "Click a bar" | Turn them into chips with counts that look like filter buttons |
| "More ▾" tab | Shows 3 more tabs in the same row | Looks like a menu; after clicking, it toggles inline and the ▴ is easy to miss | Use a real dropdown, or just show all 6 tabs (they fit at 1440) |
| Example prompts "Clinical, 4 weeks" etc. | Fill and apply the plain-words box | Dashed outline + muted text reads as placeholder or disabled | Solid outline, accent text on hover |
| "Save this list…", "What do these words mean?" | Open the Save menu / glossary | Same pill as the view tiles right above, so they read as more tiles | "Save…" as an icon-text button aligned right; glossary as a text link |
| Title link ↗ | Opens Grants.gov (leaves the app) | It's the most prominent thing on the card, and people will expect it to open details | Keep the external link only in the panel/plan as "Open on Grants.gov ↗"; the card title opens details |
| Pursue (main action) | Adds to cart and opens the plan | Outline only; when Pass is pressed it's solid black, so the strongest button on the card is the one you rejected | Pursue = solid accent; pressed Pass = dim the card and show "Passed · Undo" |
| Zero-count tiles ("0 New", "0 Check eligibility") | Clickable and show an empty list | Look the same as tiles with results | Disable them (muted, `aria-disabled`), or hide them |
| "Clear all" (My decisions) | Deletes all 41 local marks | Same neutral pill as "Export decisions CSV" next to it | Brick text button, set apart, with a confirm step |
| Cart item checkboxes | Pick grants to compare | Unlabeled 20 px boxes at top-left; "Tick 2 more grants above" is the only hint | Label them "Compare" |

---

### Other bugs and inconsistencies found along the way (for triage)

- Count line says 118 hidden as not eligible; the bottom panel says "Hidden as not eligible: 10"; a card's details say "rank 5 of 925 open eligible items" while the list says "13 open grants loaded". Pick one honest count.
- Cards in the "Hidden as not eligible" list show "Tier 1: you can start" and "Pursue: add to cart" next to "Can't apply".
- "Tight: needs ~8 wks" appears on a grant with 13 days left. That's impossible, not tight, and a payoff per week is still shown.
- The cart totals "$26M up to, if every one is won" across agencies (Adult Correction grants while viewing DHHS).
- Swipe mode says "1 of 20" when the open list has 10 (it includes forecasts).
- The "Start here" top card is a grant already marked Pass (pressed black button) and is still featured as a best match.
- Pursue plan timeline spreads the steps across the whole window: "Check your logins" lands on day 68, even though the plan itself says fixing those "can take weeks".
- Goal weight slider labels repeat the prefix: "PRIORITY 3: PRIORITY 3: ...".
- The Save menu shows an "XLS" icon for a .csv file.
- On mobile the scatter's x-axis labels overlap.
- Match board defaults to "All NC" but lists Public Schools goals.
