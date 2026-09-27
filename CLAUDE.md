# Coffee Underground redesign: handoff notes

Free redesign of https://www.coffeeunderground.info, a local Greenville, SC coffee house. The current site is on Wix. Built in a claude.ai chat, continued here.

## Hard constraints
- Static site only. Plain HTML plus `assets/css/styles.css`, and a little inline JS (the nav toggle, the home intro, and the Events page feed). No frameworks, bundlers, or build step for the pages.
- Keep ALL existing text and images from the Wix site. Do not rewrite copy. The only allowed text changes are typo and grammar fixes, and each one gets logged in `docs/OUTLINE.md`. Content accuracy (facts, figures, dated info) is out of scope; don't flag or fix it.
- Page folders mirror the old Wix URLs (`/events`, `/menus`, `/about-cu`, `/coffee-facts`, `/contact`) so existing links keep working. The unfinished Wix "EXTRAS" page (`/blank`) is not carried over; `/blank` redirects to `/about-cu/` via `_redirects`.
- Edit the HTML files directly. They are the source of truth; there is no generator in this repo.

## Key decisions
- The menu is built from the 7/10/25 PDF (the one linked on the live Menus page), not the 3/29/24 PDF.
- The text menu is grouped under the site's five categories (COFFEES, NO BUZZ, INDULGE, SWEETNESS, NOURISH). "Download Menu PDF" is secondary.
- The Google Maps JS widget is replaced by a lazy iframe embed plus Directions, Apple Maps, and Call buttons.
- The Wix contact form is replaced by a mailto button.
- Events "Upcoming events" is fed from the Google Calendar, not written in HTML: CI runs `scripts/build-events.py` (on each deploy and daily) to write `assets/data/events.json`, and the page shows the next 7 days. For local testing run it yourself (needs `pip install icalendar recurring-ical-events`); the JSON is gitignored.
- The Google Calendar (ID `ld5h58h5s0tarj5c1eccgn0mdo@group.calendar.google.com`) lives on its own page, `events/calendar/`, as a full-width agenda embed. The Events page links to it; there is no embed on the Events page itself.
- Palette: plum-ink #2a2540, plum #57507e, copper #9a6844, curtain red #8f2b25, lavender #cfc8ea, paper #f2f0f5. Type: Libre Baskerville + Source Sans 3.
- The home page intro is an SVG line-drawing of a latte pour over a painterly brick and pothos stairwell. It runs about 3.2s plus a 0.5s fade, at most once every 30 days per browser (`localStorage` key `cu-intro` holds the last-shown time). All its timings are scaled by one factor, `--k` on `#intro` in styles.css; the script reads the same value. It is skipped for reduced motion and when JS is off. It lives inline in index.html (`#intro`) and at the bottom of styles.css.
- `assets/img/logo.png` is a higher-res copy supplied by the user. The fetch script skips it.

## Where things stand
- Hosted at github.com/austinjhunt/coffee-underground-redesign; pushes to `main` deploy to GitHub Pages (`.github/workflows/pages.yml`, see README). Keep every link relative: the site lives under a subpath. Run `python3 scripts/check-links.py` before pushing.
- Images and PDFs (including `assets/img/originals/`) are committed. To rebuild them from Wix: `bash scripts/fetch-assets.sh`; it pulls 33 images and 2 PDFs from Wix, plus the untouched Wix uploads into `assets/img/originals/` (34 files, about 28 MB, not linked from any page; kept so the owner has the source photos). Then run `bash scripts/optimize-images.sh` (needs ImageMagick). It resizes the photos and makes `logo-sm.png`. The `width`/`height` in the HTML match the optimized files.
- Layout checked with the real photos on 2026-09-27 (Lighthouse mobile at 412px, desktop at 1280px, plus browser QA). Results and fixes are in `docs/OUTLINE.md` under "Site review".
- The text menu was hand-split from a two-column PDF. Verify it against `assets/files/cu-menu.pdf`, especially the fruit smoothie flavor list.

## Open items (grep `TODO(owner)`)
- Owner to fix in Google Calendar: No Expectations Comedy is Mondays 7:30pm (confirmed), but the calendar entry says 7pm. This now shows on the Events page too, since it lists the calendar as-is.

See `docs/OUTLINE.md` (problems and fixes) and `docs/content-index.md` (old page → new file).
