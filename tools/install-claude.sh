#!/usr/bin/env bash
# Install compiled agent prompts for Claude Code sessions.
#
# Copies flat prompts to ~/.claude/user-systemprompts/ and prints
# shell aliases for spawning agent sessions via --append-system-prompt-file.
#
# Usage:
#   ./tools/install-claude.sh              # install all
#   ./tools/install-claude.sh wf           # install one plugin
#   ./tools/install-claude.sh wf planner   # install one agent

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
COMPILED_DIR="$SCRIPT_DIR/../compiled"
INSTALL_DIR="$HOME/.claude/user-systemprompts"

TARGET_PLUGIN="${1:-}"
TARGET_AGENT="${2:-}"

if [[ ! -d "$COMPILED_DIR" ]]; then
    echo "Error: compiled/ not found. Run 'uv run tools/compile-prompts.py' first."
    exit 1
fi

mkdir -p "$INSTALL_DIR"

installed=0
aliases=()

for plugin_dir in "$COMPILED_DIR"/*/; do
    plugin=$(basename "$plugin_dir")
    agents_dir="$plugin_dir/agents"
    [[ -d "$agents_dir" ]] || continue

    if [[ -n "$TARGET_PLUGIN" && "$plugin" != "$TARGET_PLUGIN" ]]; then
        continue
    fi

    mkdir -p "$INSTALL_DIR/$plugin"

    for prompt in "$agents_dir"/*.md; do
        [[ -f "$prompt" ]] || continue
        agent=$(basename "$prompt" .md)

        if [[ -n "$TARGET_AGENT" && "$agent" != "$TARGET_AGENT" ]]; then
            continue
        fi

        cp "$prompt" "$INSTALL_DIR/$plugin/$agent.md"
        installed=$((installed + 1))

        alias_name="claude-${plugin}-${agent}"
        alias_cmd="alias ${alias_name}='claude --append-system-prompt-file ${INSTALL_DIR}/${plugin}/${agent}.md'"
        aliases+=("$alias_cmd")
    done
done

echo "Installed $installed prompt(s) to $INSTALL_DIR/"
echo ""

if [[ ${#aliases[@]} -gt 0 ]]; then
    echo "Add these aliases to your shell config (~/.zshrc or ~/.bashrc):"
    echo ""
    for a in "${aliases[@]}"; do
        echo "  $a"
    done
    echo ""
    echo "Then: source ~/.zshrc"
fi
