# Coffee Underground site: problems and fixes

## Layout and mobile
- The site is a desktop Wix layout squeezed onto phones. Text runs in a narrow column between purple bars, and a chat bubble sits on top of content. Fix: one responsive column, no chat widget.
- "More..." in the nav hides pages. Fix: six plain links, with a toggle on small screens.
- The black footer fills a whole phone screen and ends in a broken image icon. Fix: compact footer, hours as a table, tap-to-call and tap-to-email, broken image removed.
- The Google Map is a full JS widget with a popup covering the pin. Fix: a lazy-loaded map in a card with Directions, Apple Maps and Call buttons, and the "getting UNDERGROUND" directions as two steps next to it.
- Photos are Wix crops about 200px wide. Fix: larger images that scale with the screen and load lazily.
- The whole "Something for everyone" paragraph is an H1. Fix: a short heading and a normal paragraph.

## Menu
- The menu only exists as a PDF; the Menus page is five photos with no items. Fix: the full menu as text under the site's five categories, a jump bar, and a "Download Menu PDF" button.
- The PDF link you sent is the 3/29/24 menu. The live Menus page links a 7/10/25 menu. Fix: built from 7/10/25. The old file should be removed so it stops circulating.
- Menu typos, fixed in the HTML (the PDF still has them): affogatto > affogato, piñot noir > pinot noir, ménage a' trois > ménage à trois, marakesh > marrakesh, "vodka,cran" > "vodka, cran".

## Missing or broken content
- The page About links to as "EXTRAS" (old URL `/blank`) is an unfinished template: tab title "BLANKKKKKK", heading "I'm a title. Click here to edit me", and a blank "_________ Furniture store" name. Its only content is one paragraph. Fix (2026-09-27): page removed from the redesign, along with About's "(Cauble building history on "EXTRAS" page.)" line. `/blank` now redirects to `/about-cu/`. See the client issue under "For the owner to confirm".
- The contact form only works on Wix. Fix: "Send a message" opens an email to cugreenville@gmail.com.
- The events calendar is a Google Calendar embed wrapped in a Wix HTML iframe with a fixed 403px width, black background and `scrolling=no`, which doesn't work on phones. Fix (2026-09-27): the calendar ID was read from the Wix embed. It now has its own page, `events/calendar/`, with the site header and footer, a full-width agenda view sized to the screen, and Open full screen / Add to Google Calendar / Subscribe (Apple, Outlook) buttons below it. The Events page links to it from a "Full calendar" card. The owner keeps editing the same Google Calendar; nothing else to maintain.
- The footer shows an Instagram icon but no link to it exists in the page source. Fix: Instagram link (instagram.com/coffee.underground, from the user) added to the footer on every page.
- "Created with Wix.com" is dropped from the footer. The copyright stays.

## Typos and grammar (fixed)
- Contact: Risorante > Ristorante. "(like Cheers.)" > "(like Cheers)." Phone "(864)-298-0494" > "(864) 298-0494".
- About: rennovated > renovated. hurricane Helene > Hurricane Helene. "I purchased the 5200 SF where CU still sits" was missing a noun > "I purchased the 5200 square feet of property where CU still sits" (wording from the user, 2026-09-27).
- Events: "Open Mic The longest running" > title "No Expectations Comedy Open Mic", then "The longest-running comedy show..."
- Coffee Facts: Mocca > Mocha; hundred of years > hundreds; it's way > its way; alledgedly > allegedly; annonymously > anonymously; "Martinique to the by means of" > "Martinique by means of"; Ethiopis > Ethiopia; "integral part life" > "integral part of life"; hearty evergreens > hardy; "which coffee species used" and "which method used" > "is used"; pop corn > popcorn; In a Nut Shell > In a Nutshell; i.e. > e.g. (the lists are examples); Frangrance > Fragrance; "Spicy. Caramel" > "Spicy, Caramel"; chains stores > chain stores; ozygen > oxygen.

## Site review, 2026-09-27 (Lighthouse on all 7 pages + browser QA)
Mobile Lighthouse before > after: Home 81 > 82, Events 80 > 81, Menus 90 > 91, About 99 > 99 (a11y 98 > 100), Coffee Facts 79 > 86, Contact 100 > 99, Extras 100 > 100. Page weight roughly halved on every page.

Fixed:
- Images were full-size Wix exports (up to 1600px, 560 KB each); `assets/img` was 7.8 MB. Fix: new `scripts/optimize-images.sh` caps photos at 1200px, strips metadata, progressive JPEG q80. Now 3.7 MB. Same photos, no crops.
- The optimization overwrote the fetched images, and even those were Wix's 1600px recompressed copies, not the uploads. Fix: `fetch-assets.sh` now also saves every untouched Wix upload to `assets/img/originals/` (34 files, 28 MB, up to 3648×2736). Nothing links to them. `originals/logo.png` is Wix's 291px logo; the higher-res `assets/img/logo.png` from the user is still the master.
- `facts-1`, `facts-3` and `menu-coffees` were opaque photos saved as PNG (facts-1 was 315 KB). Fix: converted to `.jpg`; HTML and `fetch-assets.sh` updated.
- The header logo was the 390px, 142 KB master shown at 44px on every page, and the favicon too. Fix: `logo-sm.png` (88px, made by the optimize script) in the header and favicon. `logo.png` stays as the master.
- The main image on Coffee Facts (`facts-1`), Menus (the category tiles) and Contact (`contact-stairs-night`) was lazy-loaded, delaying LCP (Coffee Facts 5.6s on mobile). Fix: removed `loading="lazy"`; added `fetchpriority="high"` to the home hero, Events "Presents" banner and `facts-1`. Coffee Facts LCP 5.6s > 3.4s.
- `home-tall.png` (scroll art beside "Mice on Main") was declared 127×482 but is 144×376, so it rendered stretched. It also had an 18px white strip on its left edge. Fix: trimmed the strip (now 126×368), correct size in the HTML. Later removed from the page entirely (see below).
- More wrong declared sizes: home hero (said 800×1000, is 480×480), `home-alchemy` (652×557 vs 652×817), `events-presents`, `latte-heart`. 32 other images had no width/height, so the page jumped as they loaded (Events CLS 0.117). Fix: every `<img>` now carries its real width and height. Correction: Events CLS was first logged as 0.117 > 0, but that was one lucky run; repeat runs still show 0.117. The remaining shift comes from the web font swap (Libre Baskerville replacing the fallback in "THEATER underground"), not from images. See "Not changed" below.
- About: the story headings were `h3` right under the `h1` (skipped level, only a11y point lost). Fix: changed to `h2`, with `.story h2` keeping the old size.

Checked and fine: no console errors, no broken images or links, all in-page menu anchors resolve, mobile nav toggle opens/closes and updates `aria-expanded`, visible focus outline on every link and button, skip link and landmarks present, no touch target under 24px, no sideways scroll.

Not changed:
- Home first paint was about 1s later than other pages on a phone because the 3.7s intro covered the page, and it replayed in every new tab (it used `sessionStorage`), so visitors arriving from links saw it again and again. Fix (2026-09-27): it now shows at most once every 30 days per browser (`localStorage` with a timestamp), and it plays at double speed. Every step is kept, only faster: one factor `--k: .5` on `#intro` scales every duration and delay in the CSS, and the script reads it for the total. It runs about 1.85s plus a 0.3s fade. Checked with timed headless frames: pouring at 0.7s, complete at 1.5s, gone by 2.4s.
- In the intro, the milk stream was a nearly straight diagonal from the spout to the cup, which didn't read as liquid. Fix (2026-09-27): the stream path (`.stream` in index.html) now follows a pour arc. It leaves the spout sideways, then gravity bends it into a near-vertical fall into the cup. Timing unchanged.
- Follow-up (2026-09-27): at the user's request the intro was slowed by 75% (`--k` .5 > .875). It runs about 3.2s plus a 0.5s fade, still shorter than the original 3.7s plus 0.6s.
- Web font swap still shifts the Events page (CLS 0.117 on mobile). Fix would be a size-matched fallback font or self-hosted fonts.
- Google Fonts and `styles.css` block rendering (about 300ms). This is now most of the remaining LCP time on every page. Possible fix: self-host the two fonts and preload them.
- Lighthouse still says small photos are larger than their slots (e.g. 1200px photos in ~180px grid cells on phones). Fix would need `srcset` with a second, smaller copy of each photo.
- Pressing Escape doesn't close the mobile nav.
- No Expectations Comedy's time conflicted: the Events page said Mondays 7:30pm, the Google Calendar's weekly entry said 7pm. Fix: confirmed 7:30pm with an independent listing (visitgreenvillesc.com/event/no-expectations-open-mic-comedy/45024/: weekly on Mondays, doors 7:15pm, show 7:30pm, sign up by 6:30pm). The page text is unchanged and the TODO is removed. Still to do: the owner should change the Google Calendar entry to 7:30pm, since `events/calendar/` shows whatever that calendar says.
- Found later: Extras marked "Home" as the current page in the nav. Fixed, then moot: the Extras page was removed.
- The home page's "Located at the corner of Coffee & Main" section paired two short paragraphs with the tall purple scroll graphic (`home-tall.png`). The graphic is decoration, not a photo, and read as a random texture standing in for a main picture. Fix (2026-09-27, the user's call): graphic removed and the section is now a single text block. Turning it sideways as a banner was considered and dropped, since stretching a 126×368 image would look blurry. The file is still fetched to `assets/img/` and `originals/`, just unused.
- The "Mice on Main" link near the top of the home page points to www.miceonmain.com, which has a broken HTTPS certificate: it's issued for `*.hostingplatform.com`, not miceonmain.com, and expired Jul 3, 2026. The `http://` address returns 403. Visitors who click get a browser security warning. Fix (2026-09-27): the sentence moved down to the end of "Something for everyone" (after "Plenty of comfy seating..."), so the first thing visitors see isn't a link that warns. Text and link unchanged.
- The Events page's "Upcoming events" were two hand-written cards (Say What?! Poetry Slam, No Expectations Comedy) copied from Wix. They never changed, so cancellations, one-off shows, holiday hours and other regulars (Alchemy, Greenville Jazz Collective) never showed. Fix (2026-09-27): cards removed. The section now lists the next 7 days from the CU Google Calendar. `scripts/build-events.py` reads the calendar's public ICS feed, expands repeating events, and writes `assets/data/events.json`. The Pages workflow runs it on every deploy and daily at 09:00 UTC, and a small script on the page renders it in Greenville time. If the file is missing or JS is off, the section shows a link to the full calendar. The old card text and photos (`events-saywhat.jpeg`, `events-noexp.jpeg`, still in assets) are in the first commit, 71eb5be. Because the page now shows the calendar as-is, the calendar's 7pm time for No Expectations (the correct time is 7:30pm) is now visible on the Events page too.
- Found later: the new "Full calendar" card on Events inherited the dark section's light text on its white background (contrast 1.18). Fixed: `.pdf-callout` sets its own text color.
- No text compression or long cache headers. That's the local dev server; check the real host.

## For the owner to confirm (left as-is)
- Mice on Main (miceonmain.com) has a broken certificate (wrong domain, expired Jul 3, 2026). Worth telling them.
- The "EXTRAS" page (`/blank`) on the live site is unfinished: placeholder title and heading, and the furniture store name is a blank line. It's removed from the redesign. If the owner wants the Cauble Building history back, it needs the store name. The full text, for reference: "The Cauble building, which was built in 1901, transitioned from storage space for the _________ Furniture store, to the first Greenville Library, then into a barber shop. After that, it was empty and creepy for around 30 years, until the CU transformation began."
- Events: "check out their classes page" has no link.
- Most photos have no captions or alt text on Wix, so several use generic alt text.

## Out of scope: content accuracy
This is a redesign, not a content rewrite. Factual accuracy of the existing copy isn't reviewed or changed. Noted once and dropped from the TODOs (2026-09-27):
- Coffee Facts: "Coffea Typica (Robusta)" mixes up species; Press Pot and Cone Drip both point to the "electric perc setting"; the industry numbers ($12 billion, 23,000 coffeehouses) look dated.
