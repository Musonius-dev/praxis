# Java Quality — Generation Constraints
# Scope: **/*.java
# Active during code generation, not post-hoc review

## Invariants — BLOCK on violation

- No raw types — always use parameterized generics (`List<String>`, not `List`).
- No empty catch blocks — handle, re-throw with context, or log with severity.
- No `null` returns from public methods without `@Nullable` annotation and documented behavior.
- All public API methods have Javadoc with `@param`, `@return`, and `@throws`.
- Resources (streams, connections) use try-with-resources — never manual `finally` close.

## Conventions — WARN on violation

- Records over classes for immutable data carriers (Java 16+).
- `Optional` return type over nullable for methods that may not produce a result.
- `var` for local variables only when the type is obvious from the right-hand side.
- `sealed` interfaces/classes for closed hierarchies with pattern matching.
- Builder pattern only for objects with 5+ fields — constructors or factories for fewer.
- Prefer `List.of()`, `Map.of()` for immutable collections — not `Collections.unmodifiable*`.
- `@Override` on every overriding method — let the compiler catch signature drift.
- Stream operations only when they improve readability — explicit loops for complex logic.

## Removal Condition
Remove when a Java-specific linter rule engine replaces generation-time constraints.
