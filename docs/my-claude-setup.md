# My Claude Code Setup

Personal Claude Code configuration and plugins.

---

## Plugins

### Personal (claude-tooling)

| Plugin | Description | Skills |
|--------|-------------|--------|
| **wf** | Agentic workflow | `/wf:1-plan`, `/wf:2-implement`, `/wf:3-align`, `/wf:4-quality`, `/wf:5-test`, `/wf:6-larp`, `/wf:7.1-deslop`, `/wf:7.2-quality`, `/wf:8-review`, `/wf:0-fix` |
| **cc** | Automation builder | `/cc:skill`, `/cc:agent`, `/cc:hook`, `/cc:rule` |
| **util** | Utilities | `/util:ask`, `/util:doc`, `/util:create-handoff`, `/util:resume-handoff`, `/util:tldr`, `/util:rust-quality` |

### Third-Party

| Plugin | Source | Purpose |
|--------|--------|---------|
| **claude-mem** | [thedotmack/claude-mem](https://github.com/thedotmack/claude-mem) | Session memory - captures what Claude does, compresses it, injects context into future sessions |

### Official (claude-plugins-official)

| Plugin | Purpose |
|--------|---------|
| **pyright-lsp** | Python language server |
| **typescript-lsp** | TypeScript language server |
| **rust-analyzer-lsp** | Rust language server |

---

## User Config

| File | Purpose |
|------|---------|
| `~/.claude/CLAUDE.md` | Coding discipline rules (scope management, simplicity, pushback) |
| `~/.claude/hooks/statusline.py` | Shows model + context % in status line |
| `~/.claude/settings.json` | StatusLine config |

---

## Install Commands

```bash
# Install claude-tooling (wf, cc, util)
git clone https://github.com/jsai/claude-tooling.git
cd claude-tooling && ./install.sh

# Install claude-mem
claude plugin marketplace add thedotmack/claude-mem
claude plugin install claude-mem

# Install LSP plugins
claude plugin marketplace add anthropics/claude-plugins-official
claude plugin install pyright-lsp
claude plugin install typescript-lsp
claude plugin install rust-analyzer-lsp
```

---

## Workflow

```
/wf:1-plan → /wf:2-implement → /wf:3-align → /wf:4-quality
                                                    ↓
/wf:0-fix ← /wf:8-review ← /wf:7-deslop ← /wf:5-test + /wf:6-larp
```

---

## Links

- [claude-tooling](https://github.com/jsai/claude-tooling) - This repo
- [claude-mem](https://github.com/thedotmack/claude-mem) - Session memory
- [claude-plugins-official](https://github.com/anthropics/claude-plugins-official) - Official LSP plugins
