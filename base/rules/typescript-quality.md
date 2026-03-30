# TypeScript Quality — Generation Constraints
# Scope: **/*.ts, **/*.tsx
# Active during code generation, not post-hoc review

## Invariants — BLOCK on violation

- No `any` type — ever. Use `unknown` and narrow, or define the actual type.
- Explicit return types on all exported functions.
- No non-null assertion (`!`) without an inline comment explaining why it's safe.
- No `@ts-ignore` or `@ts-expect-error` without an inline comment explaining why.
- No `as` type assertions unless narrowing from `unknown` — prefer type guards.
- Strict null checks: handle `null` and `undefined` explicitly, never assume presence.

## Conventions — WARN on violation

- `const` by default — `let` only when reassignment is necessary. Never `var`.
- Discriminated unions over optional fields for modeling distinct states.
- `readonly` on properties that should not be mutated after construction.
- `interface` for object shapes, `type` for unions, intersections, and computed types.
- Named exports over default exports — better refactoring support and tree-shaking.
- `Promise.all` for independent async operations — never sequential awaits for parallel work.
- Error boundaries in React components that render user-generated or external data.
- `satisfies` operator over `as` for type validation without widening.

## Removal Condition
Remove when a TypeScript-specific linter rule engine replaces generation-time constraints.
