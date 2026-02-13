#!/bin/bash
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"

# Install user CLAUDE.md
mkdir -p "$HOME/.claude"
ln -sf "$DIR/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

echo "User config installed."
