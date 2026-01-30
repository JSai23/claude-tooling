#!/usr/bin/env python3
"""Block pip install commands. Use uv instead."""
import json
import re
import sys

try:
    data = json.load(sys.stdin)
    command = data.get("tool_input", {}).get("command", "")

    # Match "pip install" or "pip3 install" but not "uv pip install"
    if re.search(r"\bpip3?\s+install\b", command) and not re.search(r"\buv\s+pip\s+install\b", command):
        print(json.dumps({
            "decision": "block",
            "reason": "pip install is not allowed. Use uv instead: uv pip install, uv add, or uv run."
        }))
    else:
        print(json.dumps({}))
except Exception:
    print(json.dumps({}))
