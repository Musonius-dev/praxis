# SQL Quality — Generation Constraints
# Scope: **/*.sql
# Active during code generation, not post-hoc review

## Invariants — BLOCK on violation

- Parameterized queries only — never concatenate user input into SQL strings.
- Every `SELECT` on user-generated data has a `LIMIT` — no unbounded result sets.
- Every migration is reversible — include both `UP` and `DOWN` in every migration file.
- No `SELECT *` — explicitly list columns. Schema changes should not silently alter query results.
- No `DROP TABLE` or `DROP COLUMN` without a preceding data migration or explicit confirmation.

## Conventions — WARN on violation

- Uppercase SQL keywords (`SELECT`, `FROM`, `WHERE`) — lowercase for identifiers.
- `snake_case` for all table and column names.
- Foreign keys have explicit `ON DELETE` and `ON UPDATE` behavior — never rely on defaults.
- Indexes on all columns used in `WHERE`, `JOIN`, and `ORDER BY` on tables >1000 rows.
- `NOT NULL` by default — nullable columns require a comment explaining why null is valid.
- `TIMESTAMP WITH TIME ZONE` for all temporal columns — never naive timestamps.
- `CHECK` constraints for domain validation at the database level — don't rely solely on application code.
- CTEs (`WITH`) for readability over nested subqueries beyond 2 levels.

## Removal Condition
Remove when a SQL-specific linter rule engine replaces generation-time constraints.
