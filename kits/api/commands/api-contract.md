---
description: "Generate contract tests from an OpenAPI spec or route definitions"
---

# api:contract

## Steps

1. **Locate spec** — read `docs/openapi.yaml` or detect routes from code
2. **For each endpoint**, generate a contract test that verifies:
   - Response status code matches expected
   - Response body matches schema
   - Required fields are present
   - Error responses follow the standard format
3. **Detect test framework** — Jest, pytest, Go testing, etc.
4. **Write tests** to project test directory
5. **Run tests** — execute and report results
6. **Report** — tests generated, pass/fail counts
