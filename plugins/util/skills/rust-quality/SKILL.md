---
name: rust-quality
description: Rust code quality audit based on Apollo best practices
argument-hint: "[path or files]"
---
## Target
$ARGUMENTS

---

Audit Rust code quality. Report issues in organized format, then offer to fix.

## Audit Categories

### 1. Clippy Violations
- All clippy warnings must be addressed, not silenced
- Use `#[expect(...)]` with comment if truly necessary, never bare `#[allow(...)]`
- Check for missing workspace lint config in Cargo.toml

### 2. Borrowing & Cloning
**Red flags:**
- `.clone()` inside loops - use `.cloned()` or `.copied()` on iterator
- `.clone()` on large types (`Vec<T>`, `HashMap<K,V>`)
- Clone when borrow would work - `fn process(s: String)` vs `fn process(s: &str)`
- `&Vec<T>` instead of `&[T]`
- `&String` instead of `&str`
- Cloning reference args when caller should pass ownership

**Prefer:**
- Borrow over clone
- `&str` over `String` in params
- `&[T]` over `&Vec<T>` in params
- `impl AsRef<T>` for flexible APIs

### 3. Option/Result Handling
**Red flags:**
- `.unwrap()` or `.expect()` in non-test code
- `match` for simple Ok/Err -> Some/None conversions (use `.ok()`, `.ok_or()`)
- Manual match that could be `let Ok(x) = expr else { return }`
- `if let Some(x) = ... { x } else { default }` instead of `.unwrap_or()`

**Prefer:**
- `?` for error propagation
- `let Ok(x) = expr else { return Err(...) }` for early returns
- `.ok_or_else()` / `.map_or_else()` when allocation needed
- `thiserror` for library errors, `anyhow` only for binaries

### 4. Iterator Patterns
**Red flags:**
- Collecting just to iterate again - `.collect::<Vec<_>>()` then `for x in vec`
- Manual loops that could be `.filter().map().collect()`
- `.fold()` for simple sums (use `.sum()`)
- Missing `.iter()` vs `.into_iter()` awareness (prefer `.iter()` for `Copy` types)

**Prefer:**
- Pass iterators directly when possible
- Lazy evaluation - don't collect until needed
- `.enumerate()` over manual index tracking

### 5. Error Handling
**Red flags:**
- `panic!` in library code (use `Result`)
- `Box<dyn Error>` in library APIs (use `thiserror`)
- Missing `# Errors` doc section on fallible functions
- `anyhow` in library code

**Prefer:**
- `thiserror` with descriptive error variants
- Error hierarchies with `#[from]` for wrapping
- `?` over verbose match chains
- `inspect_err()` for logging

### 6. Performance Anti-patterns
**Red flags:**
- Unnecessary heap allocation (`Box` when stack works)
- `#[inline]` without benchmark proof
- Large stack allocations (arrays > 64KB)
- `Box<dyn Trait>` when `impl Trait` works
- Early allocation in `or`, `map_or`, `unwrap_or` (use `_else` variants)

**Prefer:**
- `impl Trait` (static dispatch) over `dyn Trait` when possible
- `Cow<'_, str>` for maybe-owned data
- Benchmark before optimizing

### 7. Comments & Documentation
**Red flags:**
- Comments explaining "what" not "why"
- `// TODO` without issue link
- Stale/misleading comments
- Missing `///` docs on public items
- Missing `# Examples`, `# Errors`, `# Panics` sections

**Prefer:**
- Let code speak - extract functions over comments
- Link to ADRs/issues for context
- Doc tests as living examples

### 8. Type System
**Red flags:**
- Runtime state checks that could be compile-time (type state pattern)
- `Option<T>` fields for required builder params
- Missing `#[non_exhaustive]` on public enums
- `dyn Trait` without `Send + Sync` in async contexts

**Prefer:**
- Type state pattern for state machines
- Compile-time guarantees over runtime checks
- `PhantomData` for zero-cost type markers

### 9. Rust Slop (AI/verbose cruft)
**Red flags:**
- Defensive code for impossible cases
- Over-engineered abstractions for one-time use
- Verbose intermediate variables adding nothing
- Interfaces with single implementations
- Factory patterns for simple construction

## Output Format

```
# Rust Quality Audit: [path]

## Critical (must fix)
- [file:line] Category: Description

## Warnings (should fix)
- [file:line] Category: Description

## Suggestions (consider)
- [file:line] Category: Description

## Summary
- X critical, Y warnings, Z suggestions
- Key patterns to address: ...
```

After reporting, ask: "Fix issues? (all / critical only / skip)"
