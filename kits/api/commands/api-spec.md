---
description: "Generate or validate an OpenAPI spec from the current codebase"
---

# api:spec

## Steps

1. **Detect API framework** — scan for route definitions (Express, FastAPI, Gin, etc.)
2. **Extract endpoints** — list all routes with methods, paths, handlers
3. **Generate OpenAPI 3.x spec** — for each endpoint:
   - Path and method
   - Request parameters (path, query, header)
   - Request body schema (from types/models)
   - Response schemas (success + error)
   - Authentication requirements
4. **Validate against api-design rules** — flag violations
5. **Write spec** to `docs/openapi.yaml` (or project-configured location)
6. **Report** — endpoints found, violations flagged, spec location
