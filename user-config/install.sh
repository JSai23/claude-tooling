#!/bin/bash
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"

# Install user CLAUDE.md
mkdir -p "$HOME/.claude"
ln -sf "$DIR/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

# Configure statusLine in settings.json
SETTINGS="$HOME/.claude/settings.json"
if command -v jq &> /dev/null; then
    if [ -f "$SETTINGS" ]; then
        jq '. + {"statusLine": {"type": "command", "command": "~/.claude/hooks/statusline.py"}}' \
            "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
    else
        echo '{"statusLine": {"type": "command", "command": "~/.claude/hooks/statusline.py"}}' | jq . > "$SETTINGS"
    fi
fi

# Copy statusline hook
mkdir -p "$HOME/.claude/hooks"
cp "$DIR/../plugins/wf/hooks/statusline.py" "$HOME/.claude/hooks/"
chmod +x "$HOME/.claude/hooks/statusline.py"

echo "User config installed."
