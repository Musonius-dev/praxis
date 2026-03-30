# Python Quality — Generation Constraints
# Scope: **/*.py
# Active during code generation, not post-hoc review

## Invariants — BLOCK on violation

- Type hints on every function signature — parameters and return type. No exceptions.
- No bare `except:` — always catch a specific exception type.
- No mutable default arguments (`def f(x=[])`) — use `None` and assign inside.
- No `import *` — explicit imports only.
- No `type: ignore` without an inline comment explaining why it's safe.
- f-strings only for string formatting — never `%` or `.format()`.

## Conventions — WARN on violation

- `dataclass` or `TypedDict` over raw dicts for structured data with 3+ fields.
- `pathlib.Path` over `os.path` for path manipulation.
- Context managers (`with`) for all resource handling (files, connections, locks).
- Comprehensions only when they fit one line — explicit loops otherwise.
- `enum.Enum` or `Literal` for fixed sets of values — never raw strings.
- `logging` module over `print()` in anything that isn't a CLI script.
- Async functions: every `await` in a try/except or the caller handles the exception.

## Removal Condition
Remove when a Python-specific linter rule engine replaces generation-time constraints.
