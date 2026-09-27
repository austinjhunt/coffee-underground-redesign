#!/usr/bin/env python3
"""Builds assets/data/events.json from the public CU Google Calendar.

The Events page reads that file and shows the next 7 days. CI runs this on every
deploy and once a day (.github/workflows/pages.yml), so the list stays current
without anyone editing HTML. The owner only maintains the Google Calendar.

Needs: pip install icalendar recurring-ical-events
Usage: python3 scripts/build-events.py [output-path]   (default: assets/data/events.json)
"""
import html, json, re, sys, urllib.request
from datetime import date, datetime, timedelta, timezone
from pathlib import Path
from zoneinfo import ZoneInfo

import icalendar
import recurring_ical_events

ICS = ("https://calendar.google.com/calendar/ical/"
       "ld5h58h5s0tarj5c1eccgn0mdo%40group.calendar.google.com/public/basic.ics")
TZ = ZoneInfo("America/New_York")
DAYS = 60  # the page only shows 7, but a longer window keeps it correct if the daily run stops for a while

out = Path(sys.argv[1] if len(sys.argv) > 1 else Path(__file__).parent.parent / "assets/data/events.json")
with urllib.request.urlopen(ICS, timeout=30) as r:
    cal = icalendar.Calendar.from_ical(r.read())

today = datetime.now(TZ).date()

def plain(value):
    """Google Calendar descriptions are HTML. Reduce to plain text; links become their URL."""
    t = str(value or "")
    t = re.sub(r'(?is)<a\b[^>]*href="([^"]+)"[^>]*>.*?</a>', r" \1 ", t)
    t = re.sub(r"(?i)<br\s*/?>|</(p|div|li)>", "\n", t)
    t = html.unescape(re.sub(r"<[^>]+>", "", t)).replace("\xa0", " ")
    t = re.sub(r"<\s*(https?://\S+?)\s*>", r"\1", t)          # "<url>" -> "url"
    t = re.sub(r"[ \t]+", " ", t)
    t = re.sub(r" *\n *", "\n", t)
    return re.sub(r"\n{3,}", "\n\n", t).strip()


events = []
for ev in recurring_ical_events.of(cal).between(today, today + timedelta(days=DAYS)):
    if str(ev.get("STATUS", "")).upper() == "CANCELLED":
        continue
    start = ev["DTSTART"].dt
    all_day = not isinstance(start, datetime)
    if all_day:
        start_iso = start.isoformat()
    else:
        start = (start if start.tzinfo else start.replace(tzinfo=TZ)).astimezone(TZ)
        start_iso = start.isoformat()
    events.append({
        "title": str(ev.get("SUMMARY", "")).strip(),
        "start": start_iso,
        "allDay": all_day,
        "note": plain(ev.get("LOCATION")),         # the owner uses Location for a short line: price, doors, etc.
        "details": plain(ev.get("DESCRIPTION")),
    })

events.sort(key=lambda e: (e["start"][:10], not e["allDay"], e["start"]))
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(json.dumps({
    "generated": datetime.now(timezone.utc).isoformat(timespec="seconds"),
    "calendar": "calendar/",
    "events": events,
}, indent=1))
print(f"{len(events)} events, {today} to {today + timedelta(days=DAYS)} -> {out}")
