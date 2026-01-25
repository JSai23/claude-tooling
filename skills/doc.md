---
name: doc
description: Generate or update project documentation
argument-hint: "[type: api|readme|changelog|design]"
disable-model-invocation: true
---
## Documentation Type
$ARGUMENTS

---

# Documentation Generator

Generate or update project documentation based on the codebase.

## Documentation Types

| Type | Description |
|------|-------------|
| `api` | API reference from code (endpoints, functions, classes) |
| `readme` | Project README with setup, usage, and examples |
| `changelog` | Generate changelog from git history or summarize changes |
| `design` | Architecture and design decisions |
| *(none)* | Analyze what's missing and suggest |

## Process

### 1. Check for DOCS.md
Look for `DOCS.md` in project root or subdirectories for project-specific guidelines.

```bash
find . -name "DOCS.md" -type f 2>/dev/null | head -5
```

If found, follow those conventions. If not, use sensible defaults.

### 2. Analyze the Codebase
- Understand project structure
- Identify public interfaces
- Find existing documentation
- Note what's missing or stale

### 3. Generate Documentation

#### If no type specified:
1. List existing docs and their status (current/stale/missing)
2. Recommend which docs to create or update
3. Ask user which to proceed with

#### If type specified:
Generate the requested documentation type:

**api**: Extract from code
- Public functions/methods with signatures
- Endpoints with request/response shapes
- Classes with key methods
- Types/interfaces

**readme**: Project overview
- What it does (one paragraph)
- Installation
- Quick start / usage examples
- Configuration (if any)
- Contributing (if open source)

**changelog**: From git or code
- Group changes by version/date
- Categorize: Added, Changed, Fixed, Removed
- Link to relevant commits/PRs

**design**: Architecture docs
- High-level architecture
- Key design decisions and rationale
- Data flow diagrams (as text/mermaid)
- Trade-offs made

## Guidelines

- **Match project style** - Follow existing doc conventions
- **Be concise** - Only document what needs documenting
- **Stay current** - Don't add docs that will immediately be stale
- **Code is truth** - Derive from actual code, not assumptions

## No DOCS.md?

If no project guidelines exist, suggest creating one:

```markdown
# Documentation Guidelines

## Style
- [language/framework conventions]

## Required Docs
- README.md - always current
- API.md - for public interfaces

## Changelog
- Keep CHANGELOG.md updated
- Follow keepachangelog.com format
```

Offer to create `DOCS.md` if the project would benefit from consistent doc standards.
