---
name: api
version: 1.0.0
description: "API design — RESTful conventions, OpenAPI specs, contract testing, endpoint review"
activation: /kit:api
deactivation: /kit:off
skills_chain:
  - phase: spec
    skills: []
    status: planned
  - phase: review
    skills: []
    status: planned
  - phase: contract
    skills: []
    status: planned
context_cost: medium
depends_on: []
mcp_servers: []
rules:
  - api-design.md
removal_condition: >
  Remove when API design is fully handled by a dedicated API gateway or design tool
  with no manual Claude-driven operations remaining.
---

# API Kit

## Purpose
Enforce API design best practices across RESTful and GraphQL endpoints.
Covers spec generation, endpoint review, and contract test scaffolding.

## Skills Chain

| # | Phase | Command | What It Provides |
|---|-------|---------|-----------------|
| 1 | Spec | `/api:spec` | Generate or validate OpenAPI spec from code |
| 2 | Review | `/api:review` | Endpoint naming, versioning, error codes, auth patterns |
| 3 | Contract | `/api:contract` | Generate contract tests from OpenAPI spec |

## Workflow Integration

This kit operates WITHIN the Praxis workflow:
- **Praxis** structures the work (discuss → plan → execute → verify → simplify → ship)
- **This kit** adds API-specific rules and commands

## Prerequisites

Run `install.sh` in this directory to check for required CLI tools.
Verify with `/kit:api` after install.
