# Security — Rules
# Scope: Loads when security kit is active
# Extends base secret-scan with deeper analysis

## Invariants — BLOCK on violation

### Input validation
- Validate ALL user input at the boundary — never trust client data
- Use allowlists over denylists for input validation
- Parameterize all database queries — no string interpolation in SQL
- Sanitize HTML output — prevent XSS via output encoding
- Validate file uploads: type, size, content (not just extension)

### Authentication
- Hash passwords with bcrypt/argon2 — never MD5/SHA1
- Enforce minimum password complexity at the application level
- Implement account lockout after N failed attempts
- Session tokens must be cryptographically random, sufficient length (128+ bits)
- Invalidate sessions on logout and password change

### Authorization
- Enforce least privilege — default deny, explicit allow
- Check authorization on every request — never rely on client-side checks
- Use role-based (RBAC) or attribute-based (ABAC) access control
- Validate object-level access — prevent IDOR (Insecure Direct Object Reference)
- Log all authorization failures

### Secrets
- No secrets in code, config files, or environment variable defaults
- Use secret managers (Vault, AWS Secrets Manager, Azure Key Vault)
- Rotate secrets on schedule and on compromise
- Audit secret access logs

### Transport
- TLS 1.2+ for all external communication
- HSTS headers on all HTTP responses
- Certificate pinning for mobile/critical APIs

## Conventions — WARN on violation

### CORS
- Restrict `Access-Control-Allow-Origin` to specific domains — never `*` in production
- Limit allowed methods and headers to what's needed

### CSP
- Content Security Policy headers on all HTML responses
- No `unsafe-inline` or `unsafe-eval` in production CSP

### Dependencies
- Audit dependencies for known vulnerabilities before adding
- Pin dependency versions — no floating ranges in production
- Review transitive dependencies for supply chain risk

### Logging
- Log security events: auth failures, privilege escalations, input validation failures
- Never log secrets, tokens, passwords, or PII
- Structured logging with correlation IDs for incident investigation
