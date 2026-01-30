#!/bin/bash
set -e
TOOLING_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
CACHE_DIR="$CLAUDE_DIR/plugins/cache/claude-tooling"

echo "Installing claude-tooling..."

# Add marketplace (remove first if exists)
claude plugin marketplace remove claude-tooling 2>/dev/null || true
claude plugin marketplace add "$TOOLING_DIR"

# Install all plugins
claude plugin install wf --scope user
claude plugin install cc --scope user
claude plugin install util --scope user

# Create skill symlinks for autocomplete
# Workaround: marketplace plugin skills don't appear in autocomplete
# https://github.com/anthropics/claude-code/issues/18949
echo "Creating skill symlinks for autocomplete..."
mkdir -p "$CLAUDE_DIR/skills"

# Link wf skills
for skill in "$CACHE_DIR/wf/1.0.0/skills/"*/; do
    name=$(basename "$skill")
    ln -sf "$skill" "$CLAUDE_DIR/skills/wf:$name"
done

# Link cc skills
for skill in "$CACHE_DIR/cc/1.0.0/skills/"*/; do
    name=$(basename "$skill")
    ln -sf "$skill" "$CLAUDE_DIR/skills/cc:$name"
done

# Link util skills
for skill in "$CACHE_DIR/util/1.0.0/skills/"*/; do
    name=$(basename "$skill")
    ln -sf "$skill" "$CLAUDE_DIR/skills/util:$name"
done

# Install user config (CLAUDE.md + statusline)
"$TOOLING_DIR/user-config/install.sh"

echo ""
echo "Installation complete!"
echo ""
echo "Workflow:    /wf:1-plan, /wf:2-implement, /wf:3-align, etc."
echo "Automation:  /cc:skill, /cc:agent, /cc:hook, /cc:rule"
echo "Utilities:   /util:ask, /util:doc, /util:create-handoff, etc."
echo ""
echo "To update: claude plugin update wf cc util --scope user"
