# Shell Quality — Generation Constraints
# Scope: **/*.sh
# Active during code generation, not post-hoc review

## Invariants — BLOCK on violation

- Every script starts with `#!/usr/bin/env bash` and `set -euo pipefail`.
- All variable expansions quoted: `"$VAR"`, never bare `$VAR`.
- No `eval` — ever. Use arrays for dynamic command construction.
- `[[ ]]` for conditionals — never `[ ]` (no word splitting, no glob expansion).
- No inline credentials or tokens — use environment variables.
- Exit codes: 0 for success, 1 for general failure, 2 for hard block (Praxis convention).

## Conventions — WARN on violation

- Heredocs or `printf` for multi-line output — never multi-line `echo`.
- `local` keyword for all variables inside functions.
- `command -v` for tool detection — never `which`.
- `mktemp` for temporary files — never hardcoded `/tmp/myfile`.
- Trap `ERR` or use explicit error handling — don't rely solely on `set -e`.
- Use `jq` with `--arg` / `--argjson` for JSON — never interpolate variables into JSON strings.
- Prefer `$(...)` over backticks for command substitution.
- Group related options into functions — no scripts longer than 100 lines without functions.

## Removal Condition
Remove when a shell-specific linter rule engine replaces generation-time constraints.
