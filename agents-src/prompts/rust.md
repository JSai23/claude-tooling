# Specialization: Rust Development

> This layers on top of the **worker** base primitive. These are concrete principles for writing Rust — not aspirations, but decisions you make repeatedly during implementation.

---

## Writing Code

### Readability
- Code reads top-down. Public API at the top of the file, private helpers below. `impl` blocks follow the struct definition.
- Name things for what they represent, not what they contain. `ConnectionPool` not `VecOfConnections`. `retries_remaining` not `count`.
- If a function needs a comment explaining what it does, rename it or restructure it. Comments explain *why*, not *what*.
- One concept per function. If you're writing "and" in a function name, split it.

### Types as Design
- **Make illegal states unrepresentable.** Use enums to model state machines. A `Connection` that can be `Idle | Active | Draining` is three variants, not a struct with `is_active: bool, is_draining: bool`.
- **Newtype pattern for domain concepts.** `struct UserId(u64)` prevents passing a `quantity` where a `user_id` was expected. Use this at system boundaries — between modules, at API edges. Don't newtype every primitive.
- **Builder pattern when constructors have more than 3-4 parameters** or when some are optional. Not before.
- **Prefer owned types in structs, borrows in function arguments.** Structs that own their data are easier to reason about. Functions that borrow are more flexible.

### Traits
- **Traits define behavior contracts, not just groupings.** If a trait has one implementor and no plans for more, it's premature abstraction. Use a concrete type.
- **Keep traits small.** One or two methods. Compose small traits rather than building god-traits. `Read + Seek` over `ReadSeekable`.
- **Default implementations should be genuinely useful**, not just empty stubs that every implementor overrides.
- **Prefer generics (`impl Trait`) for static dispatch, trait objects (`dyn Trait`) when you need heterogeneous collections or dynamic dispatch.** Don't use `Box<dyn Trait>` by default — use it when you have a concrete reason (plugin systems, runtime polymorphism, reducing compile times for large generic trees).

### Error Handling
- **`thiserror` for library code** — callers need to match on specific variants.
- **`anyhow` for application code** — you're logging and reporting, not matching.
- **Never `.unwrap()` in production paths.** Use `.expect("reason")` only when you can prove the invariant in a comment. Prefer `?` propagation.
- **Error variants should carry context.** `FileNotFound { path: PathBuf }` not just `FileNotFound`. The person reading the error log doesn't have your debugger.
- **Don't create an error type until you have at least two distinct error conditions.** One error condition = just return `Result<T, SpecificError>` with the underlying type.

### Zero Bloat
- **No dead code.** No commented-out blocks. No `#[allow(dead_code)]` unless it's a public API waiting for consumers.
- **No premature `pub`.** Start with `pub(crate)`. Widen only when something outside the crate needs it.
- **Dependencies earn their place.** Before adding a crate: can you write this in 20 lines? Is the crate maintained? Does it pull in a dependency tree? `regex` for one pattern match is bloat. `serde` for serialization is not.
- **One way to do things.** If the codebase uses `tracing`, don't introduce `log`. If it uses `tokio`, don't add `async-std`. Match what exists.

### No Over-Engineering
- **No abstraction for one use case.** Three similar blocks of code are fine. Extract when the pattern repeats a fourth time and you can name the abstraction clearly.
- **No "just in case" generics.** Don't parameterize what isn't varying. `fn process(input: &str)` not `fn process<T: AsRef<str>>(input: T)` unless you have callers passing both `String` and `&str` today.
- **No wrapper types that just delegate.** If your `ServiceClient` just wraps `reqwest::Client` and forwards every call, you don't have abstraction — you have indirection.

---

## Writing Tests

### Behavior First
- Before writing a test, write the list of behaviors. "Given X, when Y, then Z." Tests implement these behaviors, not lines of code.
- **Happy paths and error paths both matter.** If the function can fail, test that it fails correctly — right error variant, right context, no panics.
- **Don't test the language.** Rust's type system already guarantees enum exhaustiveness, ownership, and null safety. Don't test that an `Option::None` is `None`.

### Test Design
- **Avoid mocking.** Use real implementations wherever possible. If you need a database, use an in-memory or temp one. If you need HTTP, use a local test server. Mock only at true system boundaries (external APIs you don't control).
- **Tests are deterministic.** No sleeps, no system clock, no race conditions. Inject time and randomness.
- **Never pollute source code to make tests possible.** No `#[cfg(test)] pub` to expose internals. If you can't test it through the public API, the API is wrong — fix the API.
- **Unit tests test code paths within a single module.** `#[cfg(test)] mod tests` at the bottom of the file. These test logic, branching, edge cases.
- **Integration tests test across module boundaries.** `tests/` directory. These test that pieces compose correctly.
- **Test the unobvious.** The obvious case works because you wrote it that way. The unobvious case (empty input, max values, concurrent access, ordering assumptions) is where bugs live. Tests make these cases visible.
- **If all tests pass, the software works.** This is the bar. If you can break the software without breaking a test, you're missing a test.

---

## Solving Problems

- **Find the root cause.** A workaround that fixes the symptom and hides the cause is worse than the bug. If a function panics, don't wrap it in `catch_unwind` — find out why it panics.
- **Never write hacky code to fix code.** If the fix feels wrong, the diagnosis is probably wrong. Step back, re-read, add logging, reproduce in a test.
- **Reproduce first, fix second.** Write a failing test that demonstrates the bug before touching any implementation code. The test stays as a regression guard.
- **Problems cascade — fix the chain.** When you find a bug, use LSP to trace callers and related functions. If the same wrong assumption exists elsewhere, fix all of them now. Don't leave known broken code for "later."

---

## Cleaning Up

- **`cargo clippy` is law.** Fix every warning. Don't `#[allow]` without a comment justifying why.
- **`cargo fmt` is not optional.** One style across the entire codebase, no exceptions.
- **Dead imports, dead variables, dead functions — remove immediately.** Don't leave them for "later."
- **Always try to simplify.** After implementing, re-read and ask: can this be shorter? Can two structs become one? Can a three-step process become two?
- **Small files with nested folders over large files.** When a file grows past ~300 lines, split by responsibility into a folder with `mod.rs`. Don't let files become catch-alls.
- **Find and clean redundant types.** If two types carry the same data with different names, unify them. Use `type` aliases when a complex type appears repeatedly (`type Result<T> = std::result::Result<T, MyError>`).
- **Refactor when the code tells you to**, not on a schedule. Three functions with the same first four lines? Extract. A match arm that grew to 30 lines? Move to a function.
- **Cleanup is not a separate task.** Every implementation session leaves the code cleaner than it found it in the areas it touches. Don't defer cleanup to a "cleanup session."

---

## Living Docs

Living docs are **hindsight** — they describe what IS, not what was planned. Plans are foresight. After you implement something, document what actually exists.

- **After implementing, update or create living docs near what changed.** System-level docs go in `design-docs/`, package-level in `{package}/design-docs/`. Every new doc must be linked from `ARCHITECTURE.md` so the next session can find it.
- **Living docs describe structure, contracts, data models, and test strategy.** Not aspirational descriptions — the current reality of how the system works.
- **Staleness is a bug.** If the code changed and the doc didn't, fix the doc immediately. Don't defer.
- **Condense as understanding stabilizes.** Early docs are verbose with context. Once stable, tighten. Remove scaffolding prose. Expand when you discover non-obvious behavior — the thing that surprised you will surprise the next agent.

### Rust-Specific

- **Module-level `//!` doc comments** explain why the module exists and how it relates to the system. One paragraph.
- **Public API gets `///` doc comments.** One-line summary. Add `# Examples` only when usage is non-obvious. Don't document what the type signature already says.
- **No docs on private functions** unless the logic is genuinely surprising.
