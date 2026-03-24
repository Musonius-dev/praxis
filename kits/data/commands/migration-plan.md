---
description: "Plan a database migration with rollback strategy and safety checks"
---

# data:migration

## Steps

1. **Understand the change** — what schema changes are needed and why
2. **Classify risk level:**
   - **Low**: add nullable column, add index, add table
   - **Medium**: rename column, add NOT NULL with default, modify index
   - **High**: drop column/table, change column type, data transformation
3. **Generate migration:**
   - Up script (apply changes)
   - Down script (reverse changes)
   - Data migration script (if needed, separate from schema migration)
4. **Safety checklist:**
   - [ ] Down migration tested?
   - [ ] Production data volume considered? (large table ALTERs may lock)
   - [ ] Backward compatible? (old code works with new schema during deploy)
   - [ ] Indexes added for new query patterns?
5. **Write plan** to vault `specs/migration-plan-{date}.md`
