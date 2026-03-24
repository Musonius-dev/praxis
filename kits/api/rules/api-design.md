# API Design — Rules
# Scope: Loads when api kit is active
# Paths: **/*.ts, **/*.js, **/*.py, **/*.go (API route files)

## Invariants — BLOCK on violation

### RESTful naming
- Resources are nouns, plural: `/users`, `/orders`, not `/getUser`, `/createOrder`
- Nested resources for relationships: `/users/{id}/orders`
- No verbs in URLs — HTTP methods convey the action
- Query parameters for filtering, sorting, pagination: `?status=active&sort=created_at&page=2`

### HTTP status codes
- 200: success with body. 201: created. 204: success no body.
- 400: client error (validation). 401: not authenticated. 403: not authorized. 404: not found.
- 409: conflict. 422: unprocessable entity.
- 500: server error (never leak internals).
- Never return 200 with an error body — use the appropriate 4xx/5xx code.

### Error response format
All error responses use a consistent structure:
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Human-readable description",
    "details": [{"field": "email", "issue": "required"}]
  }
}
```
Never return raw stack traces or internal error messages.

### Versioning
- URL path versioning preferred: `/v1/users`, `/v2/users`
- Header versioning acceptable: `Accept: application/vnd.api.v2+json`
- Never break existing versions without a migration path
- Deprecation: announce in response headers before removal

### Authentication
- Bearer tokens in Authorization header, not query parameters
- API keys in headers, never in URLs (URLs are logged)
- Short-lived tokens with refresh mechanism for user-facing APIs

## Conventions — WARN on violation

### Pagination
- Cursor-based for large/real-time datasets
- Offset-based acceptable for small, static datasets
- Always return: `total`, `page`/`cursor`, `per_page`, `next`/`prev` links

### Request/Response
- Use camelCase for JSON fields (or snake_case — be consistent per project)
- Dates in ISO 8601: `2024-01-15T10:30:00Z`
- IDs as strings (UUIDs preferred over sequential integers for external APIs)
- Envelope responses only when metadata is needed — prefer flat responses

### Rate limiting
- Return `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset` headers
- 429 status code with `Retry-After` header when exceeded

### Documentation
- Every endpoint must have: method, path, description, request body, response body, error codes
- OpenAPI 3.x spec as source of truth — code generates from spec or spec generates from code
