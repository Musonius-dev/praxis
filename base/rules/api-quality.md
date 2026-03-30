# API Quality — Generation Constraints
# Scope: **/routes/**, **/api/**, **/controllers/**, **/handlers/**
# Active during code generation, not post-hoc review

## Invariants — BLOCK on violation

- Validate all input before touching business logic — type, range, format, length.
- Auth and permission checks execute before any data access — never after.
- Every endpoint has an explicit error response shape — no raw stack traces to callers.
- No raw database objects in responses — always project to a response type or DTO.
- Parameterized queries only — never concatenate user input into SQL or query strings.
- Rate limiting or pagination on any endpoint that returns unbounded collections.

## Conventions — WARN on violation

- Consistent error response format across all endpoints (status, code, message, details).
- Idempotency keys on state-changing operations that clients may retry.
- Request correlation IDs for tracing — propagate through the call chain.
- CORS, CSRF, and security headers configured explicitly — not inherited from defaults.
- Separate validation errors (400) from auth errors (401/403) from not-found (404) from server errors (500).
- Log request context (method, path, status, duration) — never log request bodies containing PII.
- API versioning strategy declared before first endpoint is written.

## Removal Condition
Remove when an API-specific linter rule engine replaces generation-time constraints.
