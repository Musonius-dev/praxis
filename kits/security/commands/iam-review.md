---
description: "Review IAM policies and permissions for least-privilege compliance"
---

# security:iam-review

## Steps

1. **Identify IAM scope** — cloud provider (AWS/Azure/GCP), service accounts, user roles
2. **Collect policies** — read IAM policy files, role definitions, permission sets
3. **Check for violations:**
   - Wildcard permissions (`*` actions or resources)
   - Overly broad roles (admin/owner where reader/contributor suffices)
   - Service accounts with user-level permissions
   - Cross-account access without justification
   - Unused roles or permissions (if access logs available)
4. **Present findings** by severity (Critical/Major/Minor)
5. **Recommend** least-privilege alternatives for each violation
6. **Write review** to vault `specs/iam-review-{date}.md`
