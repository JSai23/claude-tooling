#!/usr/bin/env python3
"""Status line for Claude Code - shows model and context percentage."""
import json
import sys

try:
    data = json.load(sys.stdin)
    model = data['model']['display_name']
    pct = data['context_window']['used_percentage']
    print(f"[{model}] {pct:.0f}%")
except Exception:
    print("[?] ?%")
