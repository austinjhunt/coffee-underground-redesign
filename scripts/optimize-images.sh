#!/usr/bin/env bash
# Shrinks the images pulled by fetch-assets.sh to web sizes. Needs ImageMagick (`magick`).
# Run from the project root after fetching:  bash scripts/optimize-images.sh
# Safe to re-run: JPEGs already at quality <= 80 and <= 1200px are skipped.
set -euo pipefail
cd "$(dirname "$0")/../assets/img"
command -v magick >/dev/null || { echo "ImageMagick not found (brew install imagemagick)"; exit 1; }

size() { stat -f%z "$1" 2>/dev/null || stat -c%s "$1"; }

# Photos: cap the long edge at 1200px (2x the widest slot they fill), strip metadata, progressive q80.
for f in *.jpg *.jpeg; do
  [ -f "$f" ] || continue
  q=$(magick identify -format '%Q' "$f" 2>/dev/null || echo 100)
  long=$(magick identify -format '%[fx:max(w,h)]' "$f" 2>/dev/null)
  if [ "$q" -le 80 ] && [ "$long" -le 1200 ]; then continue; fi
  before=$(size "$f")
  magick "$f" -auto-orient -resize '1200x1200>' -strip -sampling-factor 4:2:0 -interlace JPEG -quality 80 "$f.tmp.jpg"
  mv "$f.tmp.jpg" "$f"
  echo "jpg  $f  $((before / 1024))K -> $(( $(size "$f") / 1024 ))K"
done

# The Events banner has a white frame baked into the Wix image; crop it off (only while it's still there).
if [ -f events-presents.jpg ] && [ "$(magick events-presents.jpg -format '%[fx:p{2,2}.r>0.9&&p{2,2}.g>0.9&&p{2,2}.b>0.9]' info:)" = 1 ]; then
  magick events-presents.jpg -gravity northwest -crop "%[fx:w-53]x%[fx:h-59]+24+16" +repage -strip -interlace JPEG -quality 80 events-presents.jpg
  echo "crop frame off events-presents.jpg"
fi

# Small header/favicon copy of the user-supplied logo (logo.png itself is kept as the master).
if [ -f logo.png ] && [ ! -f logo-sm.png ]; then
  magick logo.png -resize 88x -strip logo-sm.png
  echo "made logo-sm.png"
fi
echo "Done."
