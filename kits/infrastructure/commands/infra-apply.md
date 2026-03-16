---
description: Apply a reviewed terraform plan. Gated behind plan approval. Writes result to vault.
---

You are applying an infrastructure plan.

**Step 1 — Verify plan exists**
- Check for `tfplan` file in working directory
- If missing: STOP. "No plan file found. Run `/infra:plan` first."
- Confirm user has reviewed the plan output

**Step 2 — Apply**
```bash
terraform apply tfplan
```
Capture full output.

**Step 3 — Verify**
Run `terraform plan -detailed-exitcode` after apply:
- Exit 0 = state matches config (success)
- Exit 2 = drift remains (partial apply — investigate)

**Step 4 — Write to vault**
Write apply result to vault:
- Update `{vault_path}/status.md` with What / So What / Now What
- If this was a significant change: write to `{vault_path}/specs/` as a decision record
- Run `unset BUN_INSTALL && qmd update`

**Step 5 — Report**
```
INFRA APPLY — {project} ({date})
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Status: {SUCCESS | PARTIAL | FAILED}
Resources applied: {n}
Post-apply drift: {none | details}

Vault updated: {status.md path}
```

**Rules:**
- Never apply without a saved plan file.
- Never use `-auto-approve` without explicit user request.
- Clean up tfplan file after successful apply.
