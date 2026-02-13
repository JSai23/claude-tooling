#!/bin/bash
set -e
TOOLING_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
CACHE_DIR="$CLAUDE_DIR/plugins/cache/claude-tooling"

echo "Installing claude-tooling..."

# Add marketplace (remove first if exists)
claude plugin marketplace remove claude-tooling 2>/dev/null || true
claude plugin marketplace add "$TOOLING_DIR"

# Install claude-tooling plugins
claude plugin install wf --scope user
claude plugin install util --scope user
claude plugin install vault --scope user

# Install plugin-dev from official marketplace (for creating skills, agents, hooks)
claude plugin install plugin-dev@claude-plugins-official --scope user

# Install user config (CLAUDE.md)
"$TOOLING_DIR/user-config/install.sh"

echo ""
echo "Installation complete!"
echo ""
echo "Workflow:    /wf:1-plan, /wf:2-implement, /wf:3-align, etc."
echo "Utilities:   /util:ask, /util:doc, /util:create-handoff, etc."
echo "Vault:       /vault:auto-process, /vault:sem-search, /vault:backlinks, etc."
echo "Agents:      claude --agent vault:writer, vault:librarian, vault:thinker"
echo "Plugin Dev:  /skill, /hook, /command (from plugin-dev@claude-plugins-official)"
echo ""
echo "To update: claude plugin update wf util vault --scope user"
