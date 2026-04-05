---
domain: engagement-scope
generated: 2026-04-05
source: client-document
---

# Azure Zero Trust Security Engagement — Scope of Work

## Engagement Overview
- Brownfield Azure environment: 50-100+ applications, 50-100 VMs
- 3-phase contractor engagement: Discovery → Zero Trust Implementation → Future Architecture
- 93 checklist items: 84 contractor-delivered technical, 9 internal policy/process
- Targets: SOC 2 Type 2 readiness, ISO 27001:2022 certification
- No hard compliance deadline — prioritize correctness over speed

## Current State Gaps
- Flat network — no segmentation, unrestricted lateral movement
- No SIEM — no centralized monitoring, no automated threat detection
- Informal change management — verbal/Teams approvals, no audit trail
- Standing privileged access — PIM exists but not widely adopted
- No tiered architecture — users can reach VMs, databases, APIs directly

## Security Model

### Tiered Network Architecture
- **User tier → Web front-end only.** NSGs and firewall deny user traffic to anything non-web.
- **Front-end → Application/API tier.** Backend only accepts traffic from front-end subnets on specific ports.
- **Application → Data tier.** Databases only accept connections from authorized app servers.
- Enforcement via deny-all rules, not obscurity.

### Uncontrolled Device Model
- ALL devices treated as untrusted — managed, unmanaged, corporate, personal
- No device compliance gates for general users
- Security enforced at identity, network, application, and data layers
- Exception: PAW (Privileged Access Workstation) required for Azure management plane
- EDR (Defender for Endpoint) deployed on corporate endpoints for detection — does not change trust model

### No Trusted Client Assumptions
- Every application treated as publicly available
- Server-side validation, secure sessions, CSRF protection, API authorization required on ALL apps
- "It's internal" justification eliminated
- Significant practice change for development group

### Environment Parity
- Dev, staging, and production share identical security controls
- Same tiered architecture, segmentation rules, access controls, pipeline gates
- Only scale and cost differ (smaller SKUs, fewer replicas)
- Prevents prod failures from control mismatch

### Non-Web Service Exceptions
- Print management server — requires specific controlled network path from user subnets
- License management server — engineering workstations need license checkout/checkin access
- Architecture must accommodate with targeted rules, not broad access

## What Does Not Change
- Users access web apps from any device — no new device restrictions
- MFA stays as-is (fully enforced)
- Private Endpoints remain in place
- Key Vault continues as secrets store
- Existing CI/CD pipeline preserved (improved, not replaced)

## Engagement Phases
- **Phase 1 — Discovery + Prepare**: 2-4 weeks flow logs, dependency agents, app mapping, env audit
- **Phase 2 — Zero Trust**: Bulk of engagement, months of phased implementation. Network segmentation and SIEM are longest-lead items.
- **Phase 3 — Future**: Architecture decisions for growth beyond this engagement

## Critical Risks (6 of 30)
| Risk ID | Risk | Mitigation |
|---------|------|------------|
| R-01 | Network segmentation causes outages (undocumented dependencies) | Phase 1 Discovery non-negotiable. 2+ weeks flow logs. Incremental rollout, documented rollback. |
| R-05 | Apps that assume trusted clients | DISC-11 assesses every app. Highest-risk first. Tiered network blocks backend regardless. |
| R-07 | Prod failures from env parity gaps | Same security architecture across all environments. |
| R-22 | Dev team cannot adapt to public-facing standards fast enough | Contractor provides guidelines and reusable patterns. Training before enforcement. |
| R-26 | Client service disruption during rollout | Client-critical apps last to segment, longest testing, leadership sign-off. |
| R-28 | No detection capability during transition | Deploy Azure Monitor + Defender for Cloud as EARLY Phase 2 priority before segmentation. |

## Leadership Requirements
- Sponsorship for change management formalization (cultural change)
- Patience during discovery (no visible improvements, produces maps and plans)
- Tolerance for initial friction (pipeline scanning, DLP, shadow IT blocking)
- Engagement with contractor review process
- Budget for tooling (Defender for Cloud, Sentinel, Purview licensing)
