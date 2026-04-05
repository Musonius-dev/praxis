---
domain: zero-trust-azure
generated: 2026-04-05
refreshed: 2026-04-05
source: perplexity-research
---

# Zero Trust Architecture for Azure — Reference Guide

## Key Concepts & Terminology
- **Zero Trust**: Security model that eliminates implicit trust — every access request is verified regardless of origin
- **Three Principles**: Verify explicitly, use least privilege access, assume breach
- **Microsoft Entra ID** (formerly Azure AD): Central identity provider for Zero Trust on Azure
- **Conditional Access**: Policy engine that evaluates signals (identity, device, location, risk) to enforce access decisions
- **Privileged Identity Management (PIM)**: Just-in-time (JIT) and just-enough-access (JEA) privilege elevation
- **Continuous Access Evaluation (CAE)**: Real-time token validation and session controls
- **Micro-segmentation**: Granular network isolation using Azure Firewall, NSGs, and Private Link

## Current Standards & Frameworks
- **NIST SP 800-207**: Zero Trust Architecture (August 2020) — remains the authoritative reference. Defines policy enforcement points (PEP), policy decision points (PDP). No revisions issued; companion documents include NIST SP 1800-35 (ZTA implementation guides)
- **CISA Zero Trust Maturity Model v2.0**: Updated from v1.0 — added "Optimal" maturity stage. Covers 5 pillars: Identity, Devices, Networks, Applications & Workloads, Data
  - Initial: Entra ID as IdP, MFA for all apps/guests, Conditional Access with entity attributes
  - Advanced: Phishing-resistant MFA (FIDO2/CBA), app migration, risk-based policies
  - Optimal: Real-time risk (ID Protection/Sentinel), CAE, automated governance, cross-tenant sync
- **Microsoft Zero Trust guidance** (2025-2026): Extended to cover AI workloads — verify explicitly now includes AI agent identity and behavior evaluation

## Best Practices

### Identity
- Deploy Entra ID as the single identity provider; consolidate identity stores
- Enforce MFA for all users, guests, and service accounts — security defaults deprecated in favor of Conditional Access policies
- Use phishing-resistant MFA: FIDO2 passkeys, Certificate-Based Authentication (CBA), Windows Hello for Business
- Block legacy authentication protocols (97-99% of attacks target them)
- Implement PIM for privileged roles with JIT elevation and approval workflows
- Use managed identities for service-to-service authentication

### Conditional Access
- Deploy baseline policies in report-only mode first; monitor 7-14 days via sign-in logs
- Require MFA, device compliance, and approved apps as baseline conditions
- Use authentication strengths to enforce phishing-resistant methods for sensitive operations
- Maintain break-glass accounts excluded from all policies
- Use risk-based policies (Entra ID Protection) for user and sign-in risk detection

### Network
- Use Private Link and private endpoints for all PaaS services
- Segment workloads with Azure Virtual Network and subnet-level NSGs
- Deploy Azure Firewall for centralized network policy enforcement
- Implement micro-segmentation to limit lateral movement
- Use Global Secure Access for compliant network checks

### Monitoring
- Deploy Microsoft Defender for Cloud — risk-based Cloud Secure Score (March 2026) now includes severity-based risk assignment for prioritization
- Use Microsoft Sentinel for SIEM/SOAR with UEBA analytics — Codeless Connector Framework (CCF) Push in preview (February 2026), legacy Data Collector API retiring September 14, 2026
- Deploy Defender XDR for extended detection and response — automatic attack disruption now enforces Zero Trust containment (account lockdown)
- Deploy Defender External Attack Surface Management (EASM) for internet-facing asset discovery and exposure scanning
- Enable diagnostic logging for all identity, network, and application events
- Configure automated incident response playbooks

### Network (2026 Updates)
- Azure Firewall **Draft & Deploy** enables collaborative policy drafts without live disruption
- Confidential VMs (DCesv6, ECesv6 series) with Intel TDX for hardware-isolated workloads (GA)
- Microsoft Sovereign Cloud added disconnected operations for air-gapped Zero Trust governance

## Implementation Steps (Recommended Order)
1. Deploy Conditional Access baseline policies in report-only mode
2. Enable MFA enforcement via Conditional Access (replace security defaults)
3. Migrate to phishing-resistant MFA for privileged users
4. Implement PIM for administrative roles
5. Configure network segmentation and private endpoints
6. Deploy Defender for Cloud + Sentinel for monitoring
7. Enable CAE and real-time risk assessment
8. Block legacy authentication protocols
9. Onboard devices to Intune for device compliance signals
10. Target and maintain Azure Secure Score >85%

## SOC 2 Mapping
| Zero Trust Component | SOC 2 TSC Mapping |
|---------------------|-------------------|
| MFA / Conditional Access | CC6.1, CC6.2, CC6.3 (Logical Access) |
| PIM / Least Privilege | CC6.1, CC6.3 (Access Management) |
| Network Segmentation | CC6.6 (System Boundaries) |
| Monitoring / Sentinel | CC7.1, CC7.2, CC7.3 (System Operations) |
| Incident Response | CC7.3, CC7.4 (Incident Management) |
| Change Management | CC8.1 (Change Authorization) |
| Vendor Management | CC9.2 (Vendor Risk) |
| Encryption | CC6.7 (Transmission/Storage) |

## Sources
- NIST SP 800-207: Zero Trust Architecture (August 2020) — current authoritative reference
- NIST SP 1800-35: Implementing a Zero Trust Architecture (companion practice guide)
- CISA Zero Trust Maturity Model v2.0 — 5-pillar framework with Initial/Advanced/Optimal stages
- Microsoft Learn: Zero Trust deployment guide for Azure (continuously updated)
- Microsoft Learn: CISA Zero Trust Maturity Model — Identity pillar alignment
- Microsoft Security Blog: Secure Future Initiative and Zero Trust (May 2025)
- Microsoft Defender for Cloud release notes (March 2026) — risk-based Secure Score, severity assignment
- Microsoft Sentinel: CCF Push connector preview (February 2026 drop)
- GitHub: Conditional Access baseline policies (maintained, latest updates through 2025-2026)
- Perplexity research refresh: April 2026
