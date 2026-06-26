#!/usr/bin/env python3
"""Build script: reads src/template.html and writes index.html at repo root.

Usage: python3 src/build_site.py
Run from anywhere — paths are resolved relative to this file.
"""
import os
import sys

ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), ".."))
TEMPLATE = os.path.join(ROOT, "src", "template.html")
OUTPUT = os.path.join(ROOT, "index.html")

try:
    with open(TEMPLATE, encoding="utf-8") as f:
        html = f.read()
except FileNotFoundError:
    print(f"ERROR: template not found at {TEMPLATE}", file=sys.stderr)
    sys.exit(1)

with open(OUTPUT, "w", encoding="utf-8") as f:
    f.write(html)

print(f"Built: {OUTPUT}")
