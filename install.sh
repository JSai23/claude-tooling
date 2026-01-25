#!/bin/bash
# install.sh - Set up claude-tooling

set -e
TOOLING_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Installing claude-tooling..."

# Create directories
mkdir -p "$CLAUDE_DIR/skills"
mkdir -p "$CLAUDE_DIR/rules"
mkdir -p "$CLAUDE_DIR/hooks"
mkdir -p "$CLAUDE_DIR/agents"

# Link skills (flat structure - each skill gets its own directory)
for skill in "$TOOLING_DIR/skills/"*.md; do
    name=$(basename "$skill" .md)
    mkdir -p "$CLAUDE_DIR/skills/$name"
    ln -sf "$skill" "$CLAUDE_DIR/skills/$name/SKILL.md"
done
echo "Linked $(ls "$TOOLING_DIR/skills/"*.md 2>/dev/null | wc -l) skills"

# Link agents
for agent in "$TOOLING_DIR/agents/"*.md; do
    ln -sf "$agent" "$CLAUDE_DIR/agents/$(basename "$agent")"
done
echo "Linked $(ls "$TOOLING_DIR/agents/"*.md 2>/dev/null | wc -l) agents"

# Link rules
for rule in "$TOOLING_DIR/rules/"*.md; do
    ln -sf "$rule" "$CLAUDE_DIR/rules/$(basename "$rule")"
done
echo "Linked rules"

# Copy status line script and make executable
cp "$TOOLING_DIR/hooks/statusline.py" "$CLAUDE_DIR/hooks/"
chmod +x "$CLAUDE_DIR/hooks/statusline.py"
echo "Installed status line"

# Configure status line in settings.json
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
if [ ! -f "$SETTINGS_FILE" ]; then
    echo '{}' > "$SETTINGS_FILE"
fi
echo ""
echo "Add to $SETTINGS_FILE:"
echo '  "statusLine": { "type": "command", "command": "~/.claude/hooks/statusline.py" }'

# Install LSP binaries for code intelligence
echo ""
echo "Installing LSP binaries (requires sudo)..."

if command -v npm &> /dev/null; then
    sudo npm install -g pyright typescript-language-server 2>/dev/null && \
        echo "LSP binaries installed" || echo "LSP install failed (try: sudo npm install -g pyright typescript-language-server)"
else
    echo "npm not found - install Node.js for LSP support"
fi

echo ""
echo "Installation complete!"
echo ""
echo "Skills available:"
echo "  /create-handoff, /resume-handoff  (user-only)"
echo "  /tldr-code                        (model can invoke)"
echo "  /auto-add-skill, /auto-add-hook, /auto-add-rule, /auto-add-agent"
echo "  /1-plan through /0-fix            (Shaw workflow, user-only)"
echo ""
echo "Agents: planner, auditor, validator, automation-designer"
echo ""
echo "To enable code intelligence, run in Claude Code:"
echo "  /plugin marketplace add anthropics/claude-plugins-official"
echo "  /plugin install pyright-lsp@claude-plugins-official"
echo "  /plugin install typescript-lsp@claude-plugins-official"
