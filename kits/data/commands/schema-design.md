---
description: "Review database schema design for normalization, indexing, and best practices"
---

# data:schema

## Steps

1. **Identify schema files** — find migration files, model definitions, or SQL schemas
2. **Analyze structure:**
   - Normalization level (1NF → 3NF)
   - Primary key strategy
   - Foreign key relationships and ON DELETE behavior
   - Index coverage on foreign keys and query columns
   - Missing created_at/updated_at timestamps
3. **Check for anti-patterns:**
   - God tables (>20 columns)
   - Missing indexes on foreign keys
   - Polymorphic associations without proper constraints
   - Over-normalization causing excessive joins
4. **Present findings** by severity
5. **Write review** to vault `specs/schema-review-{date}.md`
