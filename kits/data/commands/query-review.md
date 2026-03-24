---
description: "Review SQL queries and data access patterns for performance and correctness"
---

# data:query

## Steps

1. **Identify queries** — scan for SQL in code, ORM queries, or user-provided queries
2. **Analyze each query:**
   - Missing indexes (check WHERE, JOIN, ORDER BY columns)
   - N+1 patterns (loop with individual queries instead of batch)
   - Unbounded results (missing LIMIT/pagination)
   - SELECT * usage
   - Correlated subqueries that could be joins
3. **Check data access patterns:**
   - Connection pooling configuration
   - Transaction scope (too broad or too narrow)
   - Read replica usage for read-heavy workloads
4. **Suggest optimizations** with before/after examples
5. **Write review** to vault `specs/query-review-{date}.md`
