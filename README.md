# Coffee Underground redesign

Plain static HTML and one CSS file. No build step, no framework.

## Setup
1. `bash scripts/fetch-assets.sh` downloads the remaining 33 images (the logo is already included, from a higher-res copy) and both PDFs from the current Wix site into `assets/`. It also saves every untouched Wix upload to `assets/img/originals/` (about 28 MB). No page links to them; they're kept for the owner.
2. `bash scripts/optimize-images.sh` (needs ImageMagick) shrinks the served images for the web. It never touches `originals/`.
3. Open `index.html` in a browser, or serve the folder: `python3 -m http.server`.

## Structure
Page folders match the old Wix URLs (`/menus`, `/about-cu`, `/coffee-facts`, `/contact`, `/events`), so existing links keep working. `_redirects` sends `/blank` (the unfinished Wix Extras page, not carried over) to `/about-cu/` on Netlify or Cloudflare Pages.

- `assets/css/styles.css`: all styles
- `docs/what-changed.md`: plain-language summary of every change, for the owner
- `docs/OUTLINE.md`: problems found and fixes (working log, more technical)
- `docs/content-index.md`: old page > new file map

## Needs the owner
Owner questions are listed in `docs/OUTLINE.md` under "For the owner to confirm".

## Updating the menu
Edit `menus/index.html` and drop the new PDF in as `assets/files/cu-menu.pdf`. Update the version date in both places at the top of the page.

## Intro animation (home page)
A ~3.7s line-drawing of a latte pour over a painterly brick-and-pothos stairwell. It's pure SVG and CSS with a few lines of JS, and it lives inline in `index.html` (`#intro`), with styles at the bottom of `styles.css`.
- Runs once per browser tab session. It never shows for visitors with reduced motion turned on or with JS off.
- Tap, click, any key, or the Skip button ends it.
- To remove it: delete the `#intro` block and the small `cu-intro` script in the `<head>` of `index.html`.
- Timing: each stroke has `--t` (start) and `--d` (duration). The overall cutoff is `setTimeout(finish, 3700)`.

## Deploy
Every push to `main` publishes the site to GitHub Pages via `.github/workflows/pages.yml`. There's no build step: the workflow copies the site files (not `docs/`, `scripts/` or these notes) into `_site`, turns `_redirects` into small redirect pages (Pages ignores `_redirects`), builds `assets/data/events.json` from the CU Google Calendar (`scripts/build-events.py`), runs `scripts/check-links.py`, and deploys. It also runs daily at 09:00 UTC so the Events page's upcoming list stays current. GitHub pauses scheduled workflows after 60 days without repo activity; the JSON covers 60 days ahead, and after that the page falls back to a calendar link. Re-enable the workflow in the Actions tab if that happens. All links are relative, so the site works at the `/coffee-underground-redesign/` subpath. The images, PDFs and `assets/img/originals/` are committed, so CI doesn't depend on Wix.
