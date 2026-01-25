# Claude Tooling - Ideas & TODOs

## Future Implementation

### TLDR Read Enforcer Hook
PreToolUse hook that intercepts Read for large code files and returns TLDR AST context instead.

**What it did:**
- Block Read for code files > 3000 bytes
- Return function/class names + docstrings + call graph
- 95% token savings vs raw file

**Requirements to rebuild:**
- TLDR daemon (background server for fast cached responses)
- Hook receives `tool_input.file_path` via stdin JSON
- Returns `permissionDecision: "deny"` with AST summary as reason
- Bypass for: test files, config files, small files, offset/limit specified

**Simpler alternative:**
- Warning-only hook (doesn't block, just suggests TLDR commands)
- No daemon needed, just shell out to `tldr` CLI

---

## Ideas
- [ ] LSP integration for better code intelligence

## Frustrations to Fix
- [ ] ...

## Experiments
- [ ] ...
