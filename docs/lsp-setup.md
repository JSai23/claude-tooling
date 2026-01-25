# Code Intelligence Setup

LSP plugins give Claude go-to-definition, find-references, and automatic diagnostics.

**Doc:** https://code.claude.com/docs/en/discover-plugins#code-intelligence

## Setup

### 1. Install language server binaries

```bash
# Python + TypeScript (via install.sh)
sudo npm install -g pyright typescript-language-server

# Go
go install golang.org/x/tools/gopls@latest

# Rust
rustup component add rust-analyzer
```

### 2. Add official plugins marketplace

```bash
/plugin marketplace add anthropics/claude-plugins-official
```

### 3. Install LSP plugins in Claude Code

```bash
/plugin install pyright-lsp@claude-plugins-official
/plugin install typescript-lsp@claude-plugins-official
/plugin install gopls-lsp@claude-plugins-official
/plugin install rust-analyzer-lsp@claude-plugins-official
```

## Available Plugins

| Language   | Plugin              | Binary required              |
|------------|---------------------|------------------------------|
| Python     | `pyright-lsp`       | `pyright-langserver`         |
| TypeScript | `typescript-lsp`    | `typescript-language-server` |
| Go         | `gopls-lsp`         | `gopls`                      |
| Rust       | `rust-analyzer-lsp` | `rust-analyzer`              |
| C/C++      | `clangd-lsp`        | `clangd`                     |
| Java       | `jdtls-lsp`         | `jdtls`                      |

## Troubleshooting

**"Executable not found in $PATH"**: Install the binary from the table above.

**High memory usage**: Disable with `/plugin disable <plugin-name>`.

**Check errors**: Run `/plugin` and go to the Errors tab.
