---
domain: azure-frameworks
generated: 2026-04-05
source: perplexity-research
---

# Azure Well-Architected & Cloud Adoption Frameworks — Reference Guide

## Well-Architected Framework (WAF)

### Five Pillars
| Pillar | Focus | Key Design Principles |
|--------|-------|----------------------|
| Reliability | Resiliency, recovery | Design for failure, self-healing, redundancy |
| Security | Data protection, identity | Zero trust, defense in depth, least privilege |
| Cost Optimization | Spend efficiency | Right-sizing, reserved instances, scaling policies |
| Operational Excellence | Observability, DevOps | Automation, monitoring, CI/CD, IaC |
| Performance Efficiency | Scalability | Horizontal scaling, caching, async patterns |

### Assessment Process (June 2025 Update)
- Maturity model assessments evaluate current state across all pillars
- Track progress with checklists, design principles, and tradeoff analyses
- Azure Advisor provides continuous automated recommendations
- Workload-specific assessments for App Service, Functions, AKS

### Tradeoff Analysis
Each decision requires explicit tradeoff documentation:
- Reliability vs. Cost (redundancy increases spend)
- Security vs. Performance (encryption adds latency)
- Simplicity vs. Flexibility (abstractions add complexity)

## Cloud Adoption Framework (CAF)

### Seven Methodologies
| Phase | Purpose | Key Activities |
|-------|---------|---------------|
| Strategy | Business alignment | Define motivations, outcomes, business case |
| Plan | Roadmap | Operating model, skills, migration plan, cost estimate |
| Ready | Environment setup | Landing zones, tenant config, networking |
| Adopt | Workload deployment | Migrate, modernize, or build cloud-native |
| Govern | Policy enforcement | Azure Policy, compliance, cost guardrails |
| Secure | Security posture | Defender for Cloud, Sentinel, identity hardening |
| Manage | Operations | Monitor, patch, optimize, incident response |

First four (Strategy→Adopt) are sequential. Last three (Govern/Secure/Manage) run in parallel.

### Landing Zone Patterns
- **Start small and expand**: Minimal for <10 subscriptions
- **Enterprise-scale**: Full hierarchy for >20 subscriptions, regulated workloads
- Management groups organized by Environment and Business Unit
- Network: VWAN or hub-and-spoke with centralized firewall
- Governance: mandatory tagging, allowed SKUs, encryption, IaC enforcement

## Sources
- Microsoft Learn: Azure Well-Architected Framework (updated June 2025)
- Microsoft Learn: Cloud Adoption Framework overview
- Microsoft Learn: Landing Zone architecture patterns
- Perplexity research: April 2026
