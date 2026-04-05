---
domain: architecture-decision-records
generated: 2026-04-05
source: perplexity-research
---

# Architecture Decision Records — Reference Guide

## MADR Template (Recommended)

```markdown
# ADR-NNN: [Title]

## Status
[Proposed | Accepted | Deprecated | Superseded by ADR-NNN]

## Context and Problem Statement
[Describe the context and the problem or force driving this decision]

## Decision Drivers
- [Driver 1]
- [Driver 2]

## Considered Options
| Option | Pros | Cons |
|--------|------|------|
| Option A | ... | ... |
| Option B | ... | ... |

## Decision Outcome
Chosen option: [Option], because [justification]

## Consequences
- Positive: [what improves]
- Negative: [what gets harder]
- Neutral: [what changes without clear positive/negative]
```

## ADR Categories for Azure

| Category | Common Decisions | Azure Services |
|----------|-----------------|----------------|
| Networking | Hub-and-spoke vs. mesh, private endpoints, DNS | VNet, Azure Firewall, Private Link |
| Identity | PIM adoption, MFA enforcement, managed identities | Entra ID, Conditional Access |
| Compute | App Service vs. AKS vs. Container Apps, scaling | App Service, AKS, Functions |
| Data | Database selection, replication strategy | Cosmos DB, SQL, PostgreSQL, Synapse |
| Governance | Policy enforcement level, tagging strategy | Azure Policy, Resource Graph |
| Security | Defender tier, Sentinel deployment, key management | Defender, Sentinel, Key Vault |
| Observability | Logging strategy, alert routing | Log Analytics, App Insights, Monitor |

## Confluence Integration
- Store ADRs in Git repo (source of truth) with version control
- Link from Confluence pages for stakeholder access and narrative context
- Use Confluence for architecture diagrams, stakeholder summaries, and decision indexes
- Automate: CI pipeline publishes ADRs to Confluence on merge
- ADR index page in Confluence links to all decisions with status and date

## Tooling
- **dotnet-adr**: .NET CLI tool for creating/managing ADRs in repos
- **Kloudbean ADR Generator**: Professional ADR generation with context and alternatives
- **Azure DevOps/GitHub**: Branching policies for ADR review workflows

## Sources
- MADR template: Markdown Architectural Decision Records (ozimmer.ch, 2022)
- Joel Parker Henderson: ADR collection (github.com/joelparkerhenderson)
- Microsoft Learn: Azure Well-Architected architect role fundamentals
- Perplexity research: April 2026
