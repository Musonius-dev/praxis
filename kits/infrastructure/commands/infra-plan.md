---
description: Run terraform plan, review output, flag destructive changes. Use before any infrastructure apply.
---

You are running an infrastructure plan review.

**Step 1 — Validate environment**
- Confirm `terraform` is available: `command -v terraform`
- Confirm working directory has `.tf` files
- Check for remote backend configuration: `rg 'backend' *.tf`
- If no backend: STOP. "Remote state backend not configured. Set up backend before planning."

**Step 2 — Run plan**
```bash
terraform init -input=false
terraform plan -out=tfplan -detailed-exitcode
```
Capture the exit code:
- 0 = no changes
- 1 = error
- 2 = changes detected

**Step 3 — Review output**
- Flag **destructive changes** (destroy, replace) prominently
- Flag **new resources** that introduce cost
- Flag **security-relevant changes** (NSG rules, RBAC, public endpoints)
- Summarize: {N} to add, {N} to change, {N} to destroy

**Step 4 — Report**
```
INFRA PLAN — {project} ({date})
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Add: {n}  |  Change: {n}  |  Destroy: {n}

{destructive changes if any, highlighted}
{security-relevant changes if any}

Plan saved to: tfplan
Run /infra:apply to proceed.
```

**Rules:**
- Never auto-approve. Always require explicit user confirmation.
- If destroy count >0: require user to acknowledge before `/infra:apply`.
