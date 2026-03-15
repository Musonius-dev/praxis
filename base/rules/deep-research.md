---
description: When and how to use Perplexity MCP for deep research
---

# Deep Research

## When to Use Perplexity

Use the `perplexity` MCP server when you need:

- **Current information** beyond your training cutoff (API docs, changelogs, CVEs, pricing)
- **Best practices research** before proposing architecture or tool choices
- **Troubleshooting** obscure errors where web context would help
- **Competitive analysis** or landscape surveys during `/spec` or `/risk`

## When NOT to Use It

- Don't use it for questions you can answer confidently from training data
- Don't use it as a crutch — exhaust local context (codebase, vault, project docs) first
- Don't fire multiple redundant queries — compose one clear question

## How to Use It

1. **Compose a specific query.** Vague queries waste tokens. Include version numbers, error messages, or technology names.
2. **Cite what you find.** When Perplexity results inform a recommendation, say so: "Based on current docs [via Perplexity]: …"
3. **Cross-reference.** Perplexity results are a starting point, not gospel. Validate against official docs when stakes are high.

## Integration Points

- `/spec` — Research prior art, competing approaches, current best practices
- `/risk` — Check for known vulnerabilities, deprecation notices, breaking changes
- `/plan` — Verify tool/library availability and compatibility
- General coding — Look up current API signatures, configuration options, migration guides
