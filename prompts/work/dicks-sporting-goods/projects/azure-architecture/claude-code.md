# Dick's Sporting Goods — Azure Architecture

## Overview
Solutions architect for Dick's Sporting Goods on Azure Commercial. ADRs, reference architecture docs, design reviews, documented in Confluence.

## Identity
- **Type**: Work
- **Git profile**: work
- **Client**: Dick's Sporting Goods

## Tech Stack
- Azure Commercial (Entra ID, Conditional Access, PIM, Defender for Cloud, Sentinel, Key Vault)
- Azure data services (Cosmos DB, Synapse, Event Hubs, API Management)
- Azure compute (App Service, Container Apps, Functions, AKS)
- Terraform / Bicep for IaC
- Confluence for architecture documentation

## Commands
```bash
dev:    N/A
test:   N/A
lint:   N/A
build:  N/A
format: N/A
```

## Domain Context

### Frameworks
- Azure Well-Architected Framework (5 pillars): Reliability, Security, Cost Optimization, Operational Excellence, Performance Efficiency
- Cloud Adoption Framework (7 methodologies): Strategy, Plan, Ready, Adopt, Govern, Secure, Manage
- Landing zones: hub-and-spoke, management groups, Azure Policy, RBAC

### ADR Standards
- MADR template: Title, Status, Context, Decision Drivers, Options, Outcome, Consequences
- Categories: networking, identity, compute, data, governance, security, observability
- Store in Git, link from Confluence

### Retail Context
- Omnichannel: POS, inventory, customer data, e-commerce
- Key services: Cosmos DB (omnichannel data), Synapse (analytics), Event Hubs (real-time)
- Compliance: PCI-DSS awareness, SOC 2 alignment

## Verification
- Architecture decisions trace to WAF pillars or business requirements
- ADRs follow MADR template with options table and consequences
- Azure service names use current naming (Entra ID, not Azure AD)

## Conventions
- **Commits**: conventional commits (feat:, fix:, docs:, refactor:, chore:)
- **Branches**: `feat/description` or `fix/description`
- ADRs for all architecture decisions affecting infrastructure
- Reference architectures include Mermaid diagrams and service mapping tables
