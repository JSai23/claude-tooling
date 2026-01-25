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
echo "Installed status line"

echo ""
echo "Add to ~/.claude/settings.json:"
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
