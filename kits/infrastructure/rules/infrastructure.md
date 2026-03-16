# Infrastructure — Kit Rules
# Scope: Active when /kit:infrastructure is loaded
# Generalized from azure.md and terraform.md for cross-cloud applicability

## Invariants — BLOCK on violation

### No hardcoded subscription or account IDs
- Never hardcode cloud subscription IDs, account IDs, tenant IDs, or project IDs in Terraform or scripts.
- Use variables, data sources, or environment-based lookups.

### Plan before apply — always
- `terraform plan` (or equivalent) must be reviewed before ANY `terraform apply`.
- No blind applies. No `-auto-approve` without explicit user approval.
- Flag destructive changes (destroy, replace) prominently in plan output.

### Remote state only
- No local state files committed to git.
- State backend must be configured before first apply.
- State files never contain secrets — verify backend config before committing.

### Least privilege RBAC
- No Owner or Contributor at subscription/account scope as permanent assignments.
- Propose least-privilege alternatives with specific scope.
- RBAC changes to production must be documented in vault `specs/` before implementation.

### Private endpoints by default
- PaaS data services (storage, databases, key vaults, analytics) use private endpoints.
- Public endpoint exposure requires explicit justification written to vault `specs/`.

### No any-any network rules
- Never create firewall/NSG rules with `source: Any` and `destination: Any`.
- Flag existing any-any rules as HIGH risk.
- Every allow rule must have a documented business reason.

### Mandatory tagging
- Every resource must include tags required by the engagement.
- Check `_index.md` for engagement-specific tag requirements.
- Missing mandatory tags = BLOCK. Add them before proceeding.

---

## Conventions — WARN on violation

### Drift detection
- Run `terraform plan -detailed-exitcode` periodically to detect drift.
- Exit code 2 = drift detected. Document in vault and remediate or accept.

### Module hygiene
- Pin module versions. No floating `source` references without version constraints.
- Prefer registry modules over git references for stability.

### Cost awareness
- Flag resource changes estimated to increase monthly cost by >5%.
- Note SKU changes, reserved instance candidates, and scale-out implications.

### Compliance mapping
- Federal/government engagements: reference NIST CSF function or 800-53 control family
  for security-relevant changes.
- Compliance framework requirements documented in engagement `_index.md`.

---

## Verification Commands

```bash
# Check for hardcoded subscription/account IDs in Terraform
rg '(subscription_id|account_id|tenant_id)\s*=\s*"[a-f0-9-]{36}"' --glob '*.tf'

# Find any-any security rules
rg '(source_address_prefix|source)\s*=\s*"\*"' --glob '*.tf'

# Check for local state files
find . -name 'terraform.tfstate' -o -name '*.tfstate.backup' 2>/dev/null

# Verify remote backend configured
rg 'backend\s+"(azurerm|s3|gcs|consul)"' --glob '*.tf'
```

---

## Removal Condition
Remove when `/kit:infrastructure` is deactivated. Rules are kit-scoped, not universal.
