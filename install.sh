#!/bin/bash
set -e
TOOLING_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing claude-tooling..."

# Add marketplace
claude plugin marketplace add "$TOOLING_DIR"

# Install all plugins
claude plugin install wf --scope user
claude plugin install cc --scope user
claude plugin install util --scope user

# Install user config
"$TOOLING_DIR/user-config/install.sh"

echo ""
echo "Installation complete!"
echo ""
echo "Workflow:    /wf:1-plan, /wf:2-implement, /wf:3-align, etc."
echo "Automation:  /cc:skill, /cc:agent, /cc:hook, /cc:rule"
echo "Utilities:   /util:ask, /util:doc, /util:create-handoff, etc."
echo ""
echo "To update: claude plugin update wf cc util --scope user"
