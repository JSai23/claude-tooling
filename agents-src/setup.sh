#!/bin/bash
set -euo pipefail

# =============================================================================
# Agent Loop Setup
# Creates the agents/ directory structure in a target project repo.
# Uses symlinks to claude-tooling when available, falls back to copy.
#
# Usage (from target project root):
#   ~/claude-tooling/agents-src/setup.sh
#   ~/claude-tooling/agents-src/setup.sh --copy   # force copy mode
#
# What it creates:
#   agents/
#   ├── prompts -> ~/claude-tooling/agents-src/prompts   (symlink)
#   ├── run.sh  -> ~/claude-tooling/agents-src/run.sh    (symlink)
#   ├── stream-filter.jq -> ~/claude-tooling/agents-src/stream-filter.jq
#   ├── loop-log.sh -> ~/claude-tooling/agents-src/loop-log.sh
#   ├── loops/              (loop workspaces)
#   ├── overrides/          (per-repo prompt additions)
#   ├── archive/            (completed loop workspaces)
#   └── READ_BEFORE_RESET.md
# =============================================================================

FORCE_COPY=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --copy) FORCE_COPY=true; shift ;;
    *) echo "Unknown arg: $1"; exit 1 ;;
  esac
done

# Resolve the tooling source directory
SCRIPT_SOURCE="${BASH_SOURCE[0]}"
while [[ -L "$SCRIPT_SOURCE" ]]; do
  SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" && pwd)"
  SCRIPT_SOURCE="$(readlink "$SCRIPT_SOURCE")"
  [[ "$SCRIPT_SOURCE" != /* ]] && SCRIPT_SOURCE="$SCRIPT_DIR/$SCRIPT_SOURCE"
done
TOOLING_DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" && pwd)"

echo "Tooling source: $TOOLING_DIR"
echo "Target project: $(pwd)"

# Verify we're in a git repo
if ! git rev-parse --show-toplevel &>/dev/null; then
  echo "ERROR: Not inside a git repository. Run this from your project root."
  exit 1
fi

# Verify tooling directory has expected files
for f in "run.sh" "loop-log.sh" "stream-filter.jq" "prompts/session.md" "prompts/worker.md" "prompts/reviewer.md"; do
  if [[ ! -f "$TOOLING_DIR/$f" ]]; then
    echo "ERROR: Missing $TOOLING_DIR/$f — tooling source appears incomplete."
    exit 1
  fi
done

# Create directory structure
mkdir -p agents/loops agents/overrides agents/archive

# Decide: symlink or copy
use_symlinks=true
if [[ "$FORCE_COPY" == "true" ]]; then
  use_symlinks=false
  echo "Mode: copy (forced)"
else
  echo "Mode: symlink"
fi

link_or_copy() {
  local src="$1"
  local dest="$2"

  # Remove existing (whether symlink, file, or dir)
  if [[ -e "$dest" || -L "$dest" ]]; then
    rm -rf "$dest"
  fi

  if [[ "$use_symlinks" == "true" ]]; then
    ln -s "$src" "$dest"
    echo "  symlink: $dest -> $src"
  else
    if [[ -d "$src" ]]; then
      cp -r "$src" "$dest"
    else
      cp "$src" "$dest"
    fi
    echo "  copied: $dest"
  fi
}

# Link/copy core files
link_or_copy "$TOOLING_DIR/prompts" "agents/prompts"
link_or_copy "$TOOLING_DIR/run.sh" "agents/run.sh"
link_or_copy "$TOOLING_DIR/stream-filter.jq" "agents/stream-filter.jq"
link_or_copy "$TOOLING_DIR/loop-log.sh" "agents/loop-log.sh"

# Copy READ_BEFORE_RESET.md (always copy — it's a reference doc, not code)
cp "$TOOLING_DIR/READ_BEFORE_RESET.md" "agents/READ_BEFORE_RESET.md"
echo "  copied: agents/READ_BEFORE_RESET.md"

# Ensure agents/ is gitignored
if ! grep -q '^agents/$' .gitignore 2>/dev/null; then
  echo "agents/" >> .gitignore
  echo "Added agents/ to .gitignore"
fi

# Ensure .agent-loops/ is NOT gitignored (it's version-controlled)
if grep -q '\.agent-loops' .gitignore 2>/dev/null; then
  echo "WARNING: .agent-loops/ is in .gitignore but should be version-controlled."
  echo "         Remove the .agent-loops entry from .gitignore manually."
fi

echo ""
echo "Setup complete. Directory structure:"
echo ""
ls -la agents/
echo ""
echo "Next steps:"
echo "  1. Write session prompts in agents/loops/{loop-id}/session/"
echo "  2. Or use: ./agents/run.sh --loop-id my-task"
echo "  3. Per-repo overrides go in agents/overrides/"
