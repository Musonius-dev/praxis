# Go Quality — Generation Constraints
# Scope: **/*.go
# Active during code generation, not post-hoc review

## Invariants — BLOCK on violation

- Every error return checked immediately — no `_` for error values.
- No `panic` in library code — return errors. Reserve `panic` for truly unrecoverable states in `main`.
- No `interface{}` or `any` without a comment explaining why a concrete type won't work.
- Context (`context.Context`) as the first parameter of any function that does I/O or may be cancelled.
- No goroutine without a clear ownership and shutdown path — leaked goroutines are memory leaks.

## Conventions — WARN on violation

- Table-driven tests for any function with more than 2 test cases.
- `errors.Is` / `errors.As` for error comparison — never string matching on `err.Error()`.
- `fmt.Errorf("context: %w", err)` to wrap errors with context — never lose the original.
- Named return values only when they clarify the function signature — not as a substitute for declarations.
- `sync.Mutex` fields placed immediately above the fields they protect, with a comment.
- `defer` for cleanup — but never defer in a loop body.
- Prefer `io.Reader` / `io.Writer` interfaces over concrete types in function signatures.
- Struct field tags (`json`, `db`) on every field of a struct used for serialization.

## Removal Condition
Remove when golangci-lint rules replace generation-time constraints entirely.
