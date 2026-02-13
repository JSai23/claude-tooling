---
name: util-tldr
description: >
  Token-efficient code analysis reference. Use when analyzing large codebases or needing structured code intelligence.
metadata:
  source-plugin: util
  source-skill: tldr
---

# TLDR CLI Reference

Token-efficient code analysis tool. Available on PATH as `tldr`.

## Core Commands
```bash
tldr tree [path]                    # File tree
tldr structure [path] --lang <lang> # Code structure (codemaps)
tldr search <pattern> [path]        # Search files
tldr extract <file>                 # Full file info
tldr context <entry> --project .    # LLM-ready context
```

## Flow Analysis
```bash
tldr cfg <file> <function>          # Control flow graph
tldr dfg <file> <function>          # Data flow graph
tldr slice <file> <func> <line>     # Program slice
tldr calls [path]                   # Cross-file call graph
```

## Codebase Analysis
```bash
tldr impact <func> [path]           # Who calls this function?
tldr dead [path]                    # Find dead code
tldr arch [path]                    # Detect architecture layers
tldr imports <file>                 # Parse imports
tldr importers <module> [path]      # Find who imports module
```

## Quality
```bash
tldr diagnostics <path>             # Type check + lint
tldr change-impact [files...]       # Find affected tests
```

Supports: python, typescript, go, rust
