# Rust Quality — Generation Constraints
# Scope: **/*.rs
# Active during code generation, not post-hoc review

## Invariants — BLOCK on violation

- No `.unwrap()` or `.expect()` in library code — propagate errors with `?`.
- No `unsafe` blocks without an inline `// SAFETY:` comment explaining the invariant.
- No `.clone()` to silence the borrow checker — restructure ownership instead.
- All public items have doc comments (`///`) — the API is the documentation.
- Error types implement `std::error::Error` and provide context via `Display`.

## Conventions — WARN on violation

- `thiserror` for library error types, `anyhow` for application error types.
- Prefer `&str` over `String` in function parameters — take ownership only when needed.
- Prefer iterators and combinators over manual loops where they improve readability.
- `#[must_use]` on functions whose return value should not be silently ignored.
- Derive `Debug` on all public structs and enums.
- `#[non_exhaustive]` on public enums that may gain variants.
- Prefer `impl Trait` in argument position over generic type parameters when the type is used once.
- Integration tests in `tests/` directory — unit tests in the same file with `#[cfg(test)]`.

## Removal Condition
Remove when clippy rules replace generation-time constraints entirely.
