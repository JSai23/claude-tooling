# TLDR CLI - Code Analysis Tool

You have `tldr` available on PATH for token-efficient code analysis.

## Commands

```bash
# Core analysis
tldr tree [path]                    # File tree
tldr structure [path] --lang <lang> # Code structure (codemaps)
tldr search <pattern> [path]        # Search files
tldr extract <file>                 # Full file info
tldr context <entry> --project .    # LLM-ready context

# Flow analysis
tldr cfg <file> <function>          # Control flow graph
tldr dfg <file> <function>          # Data flow graph
tldr slice <file> <func> <line>     # Program slice
tldr calls [path]                   # Cross-file call graph

# Codebase analysis
tldr impact <func> [path]           # Who calls this function? (reverse call graph)
tldr dead [path]                    # Find unreachable/dead code
tldr arch [path]                    # Detect architectural layers

# Import analysis
tldr imports <file>                 # Parse imports from a file
tldr importers <module> [path]      # Find all files that import a module

# Quality & testing
tldr diagnostics <file|path>        # Type check + lint (pyright/ruff)
tldr change-impact [files...]       # Find tests affected by changes
```

## When to Use

- **Before reading files**: Run `tldr structure .` to see what exists
- **Finding code**: Use `tldr search "pattern"` instead of grep for structured results
- **Understanding functions**: Use `tldr cfg` for complexity, `tldr dfg` for data flow
- **Debugging**: Use `tldr slice file.py func 42` to find what affects line 42
- **Context for tasks**: Use `tldr context entry_point` to get relevant code
- **Impact analysis**: Use `tldr impact func_name` before refactoring to see what would break
- **Dead code**: Use `tldr dead src/` to find unused functions for cleanup
- **Architecture**: Use `tldr arch src/` to understand layer structure

## Languages

Supports: `python`, `typescript`, `go`, `rust`

## Output

All commands output JSON (except `context` which outputs LLM-ready text).
