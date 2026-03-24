---
description: "Review API endpoints for naming, versioning, error handling, and auth patterns"
---

# api:review

## Steps

1. **Identify scope** — review all endpoints, or specific routes if user specifies
2. **Launch subagent** (follow `/subagent` protocol) with role: "API design reviewer"
3. **Check against api-design rules:**
   - RESTful naming conventions
   - HTTP status code usage
   - Error response format consistency
   - Authentication/authorization patterns
   - Pagination implementation
   - Versioning strategy
4. **Present findings** by severity (Critical/Major/Minor)
5. **Write review** to vault `specs/api-review-{date}.md`
