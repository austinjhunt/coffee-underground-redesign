#!/usr/bin/env python3
"""Fails if any page links to a local file that doesn't exist.

Usage: python3 scripts/check-links.py [site-dir]   (default: project root)
CI runs it against the built _site folder before deploying.
"""
import re, sys
from pathlib import Path
from urllib.parse import unquote

root = Path(sys.argv[1] if len(sys.argv) > 1 else Path(__file__).parent.parent).resolve()
skip = ("http:", "https:", "mailto:", "tel:", "webcal:", "data:", "#", "//")
bad = []
for page in sorted(root.rglob("*.html")):
    html = re.sub(r"<!--.*?-->", "", page.read_text(encoding="utf-8"), flags=re.S)
    for url in re.findall(r'(?:href|src)="([^"]*)"', html):
        if not url or url.startswith(skip):
            continue
        path = unquote(url.split("#")[0].split("?")[0])
        target = (root / path.lstrip("/")) if path.startswith("/") else (page.parent / path)
        if target.is_dir():
            target = target / "index.html"
        if not target.exists():
            bad.append(f"{page.relative_to(root)}: {url}")
print("\n".join(bad) or f"All local links OK ({root.name})")
sys.exit(1 if bad else 0)
