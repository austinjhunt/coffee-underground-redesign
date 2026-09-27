#!/usr/bin/env bash
# Downloads every image and PDF from the current Wix site into assets/.
# Run once from the project root:  bash scripts/fetch-assets.sh
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p assets/img/originals assets/files
W="https://static.wixstatic.com/media"
img() { # local-name  wix-file-id
  local out="assets/img/$1" id="$2"
  # Untouched upload, kept for the owner's records. Not linked from any page.
  local orig="assets/img/originals/${1%.*}.${id##*.}"
  if [ ! -f "$orig" ]; then curl -fsSL "$W/$id" -o "$orig" && echo "ok  $orig"; fi
  [ -f "$out" ] && return
  # Wix "fit" transform caps the long edge at 1600px without cropping; falls back to the original.
  # scripts/optimize-images.sh then shrinks these for the web.
  curl -fsSL "$W/$id/v1/fit/w_1600,h_1600,q_85/$id" -o "$out" || cp "$orig" "$out"
  echo "ok  $out"
}
# shared
img logo.png                 c21ed1_513e0c5e83a3446795e5b68d461434a1.png
# home
img home-tall.png            c21ed1_92cdf6a9723d424db3ca1bfb8cc26d29.png
img home-alley.jpeg          c21ed1_40a8d763d3e24882a062dbe12d735ee4~mv2.jpeg
img home-alchemy.jpg         c21ed1_c70a74f0605944ec8b23edcbdca707ea~mv2.jpg
img latte-heart.png          c21ed1_899e072a16304cd1ae776c3dc9c95477~mv2.png
img home-turtle.jpg          c21ed1_16560542042942ac9282f0c8905b3848.jpg
img home-img0001.jpg         c21ed1_dd9801c3068a4a6ebb88c3a46b720353~mv2.jpg
img home-fullsize.jpg        c21ed1_44bd6a7335e844ed9a43450d70e2ebb6~mv2_d_2921_3162_s_4_2.jpg
img home-miley-mouse.jpg     c21ed1_fca3c621c43f4950b7d33249c2792e46.jpg
img home-img1455.jpg         c21ed1_f50e68472036421283642dac6a1b39b5~mv2.jpg
# events
img events-alchemy.jpg       c21ed1_8c4133623afd46668e31169de8e92cda~mv2.jpg
img events-presents.jpg      c21ed1_1f12fe999e754225a40a48b2da2f96e3.jpg
img events-saywhat.jpeg      c21ed1_7281a8c604584f1cb85f642f077ed5fb~mv2.jpeg
img events-noexp.jpeg        c21ed1_e1811714f1134380b5d00a7c19fd0957~mv2.jpeg
# menus
img menu-coffees.jpg         c21ed1_c32a53fe759640b790b408286dccca0f.png
img menu-nobuzz.jpg          c21ed1_9aae8de759244facb890259bd624a19e~mv2_d_2307_3515_s_2.jpg
img menu-indulge.jpg         c21ed1_b47aaade2b404a6b819851c096090de3~mv2_d_3467_2599_s_4_2.jpg
img menu-sweetness.jpg       c21ed1_acbb71d9dac24c95a024b0bc8e6b3654~mv2.jpg
img menu-nourish.jpg         c21ed1_20ab1cb15e094236a92cd7c6f6c655f7~mv2.jpg
# about
img about-pony.jpg           c21ed1_4a63dfe3ceba4d76b01ae73605be0309.jpg
img about-daisy.jpg          c21ed1_43c59d47741d431a87c2745da99fff8a.jpg
img about-dana-steve.jpg     c21ed1_228f50389193476c90fbf6c592bbd20c.jpg
img about-jocassee.jpg       c21ed1_ce611ad8da244e38b26b79a125dc9953.jpg
img about-mice.jpg           c21ed1_91afd0b0016c44509874f9d30832313b~mv2_d_3344_2062_s_2.jpg
img about-desserts.jpg       c21ed1_3a321a4d4c7145fdad5b79dee61b27c9~mv2_d_3240_2393_s_2.jpg
img about-cozy.jpg           c21ed1_599e384b83d44fa8881a7a99a43ab532~mv2_d_3165_1945_s_2.jpg
img about-breakfast.jpg      c21ed1_74f9cfffe65741d7af56240aa199218a~mv2_d_2592_3872_s_4_2.jpg
img about-roasted.jpg        c21ed1_972e5917a9fb45c7affbb4ec507d84d6~mv2_d_2592_3872_s_4_2.jpg
# coffee facts
img facts-1.jpg              c21ed1_9961110f98c943c8af82885e34529d8b.png
img facts-2.jpg              c21ed1_63f43d2aa57c4d1096a68b7d2be5d72a.jpg
img facts-3.jpg              c21ed1_e57ec98fa6434b1a97b834960c5f34a3.png
# contact
img contact-stairs-night.jpg c21ed1_71b8f715a60d4d298be7302c2fc8e575~mv2.jpg
img contact-2.jpg            c21ed1_e71925a6cd5f4c5e805af5787359cbfc~mv2_d_2239_2984_s_2.jpg
img contact-crew.jpg         c21ed1_075703d06b874948854a6913b19ac850~mv2.jpg
# PDFs. The menu is the 7/10/25 version the live Menus page links to.
F="https://www.coffeeunderground.info/_files/ugd"
[ -f assets/files/cu-menu.pdf ] || { curl -fsSL "$F/c21ed1_967350e341ce4691a24deca7d27888da.pdf" -o assets/files/cu-menu.pdf && echo "ok  assets/files/cu-menu.pdf"; }
[ -f assets/files/cu-crew-application.pdf ] || { curl -fsSL "$F/c21ed1_50bf133f96c3406c9c4cbdb6f0496b68.pdf" -o assets/files/cu-crew-application.pdf && echo "ok  assets/files/cu-crew-application.pdf"; }
echo "Done."
