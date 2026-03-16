---
description: Detect infrastructure drift via terraform plan. Reports divergence between state and config.
---

You are checking for infrastructure drift.

**Step 1 — Run drift check**
```bash
terraform init -input=false
terraform plan -detailed-exitcode
```
Capture exit code:
- 0 = no drift, config matches state
- 1 = error running plan
- 2 = drift detected

**Step 2 — Analyze drift**
If exit code 2:
- List each drifted resource with: resource address, attribute changed, expected vs actual
- Classify drift:
  - **Benign**: tags, descriptions, metadata (manual update outside Terraform)
  - **Concerning**: security groups, RBAC, network config (possible unauthorized change)
  - **Critical**: data resources, encryption settings, public access (investigate immediately)

**Step 3 — Report**
```
INFRA DRIFT — {project} ({date})
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Status: {NO DRIFT | DRIFT DETECTED}
Drifted resources: {n}

{resource list with classification}

Recommendation: {accept drift | remediate | investigate}
```

**Step 4 — Document**
If drift is Concerning or Critical:
- Write findings to `{vault_path}/notes/{date}_drift-report.md`
- Run `unset BUN_INSTALL && qmd update`

**Rules:**
- Drift detection is read-only. Never modify state or config during drift check.
- Benign drift can be accepted. Concerning/Critical drift requires action.
