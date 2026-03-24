---
name: data
version: 1.0.0
description: "Data engineering — schema design, migration planning, query optimization"
activation: /kit:data
deactivation: /kit:off
skills_chain:
  - phase: schema
    skills: []
    status: planned
  - phase: migration
    skills: []
    status: planned
  - phase: query
    skills: []
    status: planned
mcp_servers: []
rules:
  - data.md
removal_condition: >
  Remove when data operations are fully handled by a dedicated DBA tool
  with no manual Claude-driven operations remaining.
---

# Data Kit

## Purpose
Enforce data engineering best practices for schema design, migrations,
and query optimization across SQL and NoSQL databases.

## Skills Chain

| # | Phase | Command | What It Provides |
|---|-------|---------|-----------------|
| 1 | Schema | `/data:schema` | Schema design review with normalization analysis |
| 2 | Migration | `/data:migration` | Migration planning with rollback strategy |
| 3 | Query | `/data:query` | Query optimization and N+1 detection |

## Workflow Integration

This kit operates WITHIN the Praxis workflow:
- **Praxis** structures the work (discuss → plan → execute → verify → simplify → ship)
- **This kit** adds data-specific rules and commands

## Prerequisites

Run `install.sh` in this directory to check for required CLI tools.
Verify with `/kit:data` after install.
