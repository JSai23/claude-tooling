# My Claude Code Setup

## Plugins

| Plugin | Source | Skills/Purpose |
|--------|--------|----------------|
| **wf** | claude-tooling | `/wf:1-plan` → `/wf:2-implement` → `/wf:3-align` → `/wf:4-quality` → `/wf:5-test` → `/wf:6-larp` → `/wf:7.1-deslop` → `/wf:8-review` → `/wf:0-fix` |
| **util** | claude-tooling | `/util:ask`, `/util:doc`, `/util:create-handoff`, `/util:resume-handoff`, `/util:tldr` |
| **plugin-dev** | claude-plugins-official | `/skill`, `/hook`, `/command` |
| **pyright-lsp** | claude-plugins-official | Python LSP |
| **typescript-lsp** | claude-plugins-official | TypeScript LSP |
| **rust-analyzer-lsp** | claude-plugins-official | Rust LSP |

## MCP Servers

| Server | Purpose |
|--------|---------|
| **docs-mcp-server** | Documentation scraping/search ([arabold/docs-mcp-server](https://github.com/arabold/docs-mcp-server)) |

## Config Files

| File | Purpose |
|------|---------|
| `~/.claude.json` | MCP servers, conversation history |
| `~/.claude/CLAUDE.md` | Global coding rules |
| `~/.claude/settings.json` | StatusLine, plugins |

## Install

```bash
# claude-tooling (wf, util) + plugin-dev
git clone https://github.com/jsai/claude-tooling.git && cd claude-tooling && ./install.sh

# LSP plugins
claude plugin install pyright-lsp@claude-plugins-official
claude plugin install typescript-lsp@claude-plugins-official
claude plugin install rust-analyzer-lsp@claude-plugins-official

# docs-mcp-server (Docker)
docker run -d --name docs-mcp-server \
  -v docs-mcp-data:/data -v docs-mcp-config:/config \
  -e OPENAI_API_KEY="${OPENAI_API_KEY}" \
  -p 6280:6280 ghcr.io/arabold/docs-mcp-server:latest \
  --protocol http --host 0.0.0.0 --port 6280

# Register MCP server
claude mcp add --transport sse docs-mcp-server --scope user http://localhost:6280/sse
```
