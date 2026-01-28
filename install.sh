#!/bin/bash
set -e
TOOLING_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Installing claude-tooling..."

mkdir -p "$CLAUDE_DIR"/{skills,rules,hooks,agents}

# Link skills (each skill gets its own directory with SKILL.md)
for skill in "$TOOLING_DIR/skills/"*.md; do
    name=$(basename "$skill" .md)
    mkdir -p "$CLAUDE_DIR/skills/$name"
    ln -sf "$skill" "$CLAUDE_DIR/skills/$name/SKILL.md"
done
echo "Linked $(ls "$TOOLING_DIR/skills/"*.md 2>/dev/null | wc -l) skills"

# Link agents and rules
for f in "$TOOLING_DIR/agents/"*.md; do ln -sf "$f" "$CLAUDE_DIR/agents/"; done
for f in "$TOOLING_DIR/rules/"*.md; do ln -sf "$f" "$CLAUDE_DIR/rules/"; done
echo "Linked $(ls "$TOOLING_DIR/agents/"*.md 2>/dev/null | wc -l) agents"

# Install status line hook
cp "$TOOLING_DIR/hooks/statusline.py" "$CLAUDE_DIR/hooks/"
chmod +x "$CLAUDE_DIR/hooks/statusline.py"

# Update settings.json with statusLine config
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
if command -v jq &> /dev/null; then
    if [ -f "$SETTINGS_FILE" ]; then
        # Merge statusLine into existing settings
        jq '. + {"statusLine": {"type": "command", "command": "~/.claude/hooks/statusline.py"}}' \
            "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
        echo "Updated settings.json with statusLine config"
    else
        # Create new settings.json
        echo '{"statusLine": {"type": "command", "command": "~/.claude/hooks/statusline.py"}}' | jq . > "$SETTINGS_FILE"
        echo "Created settings.json with statusLine config"
    fi
else
    echo "Warning: jq not found. Manually add to $SETTINGS_FILE:"
    echo '  "statusLine": { "type": "command", "command": "~/.claude/hooks/statusline.py" }'
fi

echo ""
echo "Installation complete!"
echo ""
echo "Skills: /1-plan through /0-fix, /create-handoff, /resume-handoff, /tldr-code, /doc, /auto-add-*"
echo "Agents: planner, auditor, validator, automation-designer"
echo ""
echo "Post-install (optional):"
echo "  1. LSP binaries:  sudo npm install -g pyright typescript-language-server"
echo "  2. LSP plugins in Claude Code:"
echo "     /plugin marketplace add anthropics/claude-plugins-official"
echo "     /plugin install pyright-lsp@claude-plugins-official"
echo "     /plugin install typescript-lsp@claude-plugins-official"
