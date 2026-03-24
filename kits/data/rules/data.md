# Data Engineering — Rules
# Scope: Loads when data kit is active
# Paths: **/*.sql, **/migrations/**, **/models/**, **/schema/**

## Invariants — BLOCK on violation

### Migration safety
- Every migration must be reversible — include both up and down scripts
- Never drop columns or tables in a single migration — deprecate first, remove later
- Add columns as nullable or with defaults — never add NOT NULL without a default to existing tables
- Test migrations against a copy of production data before applying
- No data transformations in schema migrations — separate data migrations

### Query safety
- No `SELECT *` in production code — specify columns explicitly
- No unbounded queries — always include LIMIT or pagination
- No raw SQL string interpolation — use parameterized queries
- Validate that DELETE/UPDATE statements have WHERE clauses

### Schema design
- Primary keys on every table — prefer UUIDs for distributed systems, auto-increment for single-node
- Foreign keys with explicit ON DELETE behavior (CASCADE, SET NULL, RESTRICT)
- Created/updated timestamps on every table
- Indexes on all foreign keys and frequently queried columns

## Conventions — WARN on violation

### Naming
- Tables: plural, snake_case (`user_accounts`, not `UserAccount`)
- Columns: snake_case, descriptive (`created_at`, not `ts`)
- Indexes: `idx_{table}_{columns}` pattern
- Constraints: `fk_{table}_{ref_table}`, `uq_{table}_{columns}`

### Performance
- Detect N+1 query patterns — suggest eager loading or joins
- Large tables (>1M rows estimated): require index analysis before new queries
- Avoid correlated subqueries — prefer joins or CTEs
- Connection pooling required for production applications

### Normalization
- Aim for 3NF unless denormalization is justified by read performance
- Document denormalization decisions as ADRs in vault `specs/`
- JSON columns acceptable for truly flexible schemas — not for avoiding normalization
