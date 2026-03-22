---
description: Check infrastructure compliance — NIST CSF mapping, public endpoints, missing tags.
---

You are running an infrastructure compliance check.

**Step 1 — Load engagement context**
- Read vault_path from `~/.claude/praxis.config.json`
- Read `{vault_path}/_index.md` for engagement compliance requirements
- Identify applicable frameworks (NIST CSF, SOC 2, ISO 27001, FedRAMP, VITA)

**Step 2 — Public endpoint check**
```bash
# Azure: find public endpoints
az storage account list -g {rg} --query "[?publicNetworkAccess!='Disabled'].[name]" -o table 2>/dev/null
az sql server list -g {rg} --query "[?publicNetworkAccess!='Disabled'].[name]" -o table 2>/dev/null

# Terraform: check for public access in config
rg 'public_network_access\s*=\s*"Enabled"' --glob '*.tf'
rg 'public_access\s*=\s*true' --glob '*.tf'
```

**Step 3 — Tag compliance**
Check for mandatory tags defined in `_index.md`:
```bash
# Find resources missing required tags
rg 'tags\s*=' --glob '*.tf' -l  # files with tags
rg 'resource\s+"' --glob '*.tf' -l  # files with resources
# Compare: resources without tags blocks
```

**Step 4 — NIST CSF mapping**
For security-relevant resources, map to NIST CSF functions:
- **Identify**: asset inventory, data classification
- **Protect**: encryption, access control, network segmentation
- **Detect**: monitoring, logging, alerting
- **Respond**: incident response procedures
- **Recover**: backup, disaster recovery

**Step 5 — Report**
```
INFRA COMPLIANCE — {project} ({date})
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Framework: {applicable frameworks}

PUBLIC ENDPOINTS: {n found}
{list with resource and recommendation}

TAG COMPLIANCE: {n non-compliant}
{list with resource and missing tags}

NIST CSF GAPS: {n identified}
{list with function, gap, recommendation}

Overall: {PASS | ISSUES FOUND}
```

**Step 6 — Document**
Write compliance report to `{vault_path}/specs/{date}_compliance-check.md`
Vault indexing is automatic.

**Rules:**
- Compliance checks are advisory. They do not modify infrastructure.
- Critical findings (public endpoints on data services, missing encryption) should be flagged as risks via `/risk`.
