---
name: security
version: 1.0.0
description: "Security review — threat modeling, IAM audit, OWASP checks, secrets management"
activation: /kit:security
deactivation: /kit:off
skills_chain:
  - phase: threat-model
    skills: []
    status: planned
  - phase: iam-review
    skills: []
    status: planned
  - phase: audit
    skills: []
    status: planned
mcp_servers: []
rules:
  - security.md
removal_condition: >
  Remove when security review is fully handled by a dedicated SAST/DAST pipeline
  with no manual Claude-driven operations remaining.
---

# Security Kit

## Purpose
Structured security analysis for applications and infrastructure.
Covers threat modeling, IAM policy review, and OWASP top 10 auditing.

## Skills Chain

| # | Phase | Command | What It Provides |
|---|-------|---------|-----------------|
| 1 | Threat Model | `/security:threat-model` | STRIDE-based threat modeling for the current system |
| 2 | IAM Review | `/security:iam-review` | Review IAM policies, roles, permissions for least privilege |
| 3 | Audit | `/security:audit` | OWASP top 10 check against codebase |

## Workflow Integration

This kit operates WITHIN the Praxis workflow:
- **Praxis** structures the work (discuss → plan → execute → verify → simplify → ship)
- **This kit** adds security-specific rules and commands
- Extends the base `secret-scan` hook with deeper analysis

## Prerequisites

Run `install.sh` in this directory to check for required CLI tools.
Verify with `/kit:security` after install.
