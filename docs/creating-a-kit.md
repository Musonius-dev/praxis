# Creating an AI-Kit

## Overview

An AI-Kit is a domain-specific extension for Praxis. It bundles rules, commands, and optionally MCP servers into a package that can be activated on demand.

## Kit Structure

```
kits/{kit-name}/
├── KIT.md              # Manifest (required)
├── install.sh          # MCP/dependency setup (optional)
├── rules/
│   └── {domain}.md     # Domain-specific rules
└── commands/
    └── {command}.md    # Domain-specific commands
```

## KIT.md Manifest

```markdown
# {Kit Name}

> One-line description.

## Activation

\`\`\`
/kit:{kit-name}
\`\`\`

## What This Kit Provides

### Rules
- `rules/{file}.md` — Description

### Commands
- `/{command}` — Description

### MCP Servers (optional)
- **{server-name}** — Description

## MCP Setup (optional)

Run `install.sh` to register MCP servers.

## Commit Prefix (optional)

`[{prefix}]` — Used for all commits while kit is active.
```

## Rules

### File Format

Rules are markdown with YAML frontmatter:

```markdown
---
description: What this rule covers
---

# {Title}

{Content}
```

Kit rules extend (never override) base rules.

### Commands

Follow the same format as base commands. The command filename (minus `.md`) becomes the slash command name.

## Registration

Add the kit to the registry in `base/CLAUDE.md`:

```markdown
| `{kit-name}` | `/kit:{kit-name}` | {description} |
```

## Agent-First Authoring

All kit commands and rules must follow the `skill-authoring.md` conventions:

### Frontmatter is mandatory

Every command file needs YAML frontmatter with a `description` field:

```yaml
---
description: Third-person summary of WHAT it does, WHEN it activates, and freedom level.
---
```

The description is the agent's discovery API — it determines whether the command gets activated. Include trigger keywords the user might say naturally.

### Freedom levels

Assign one per command based on blast radius:

| Level | When | Example |
|-------|------|---------|
| **Low** | Deterministic, read-only, or destructive with gate | `/az-deploy` (has human approval gate) |
| **Medium** | Generates artifacts for review | `/az-review` (audit report) |
| **High** | Creative latitude expected | `/web-component` (design decisions) |

### Prose style

- Imperative mood ("Run checks", not "This command runs checks")
- No marketing language ("Non-negotiable", "Supercharged")
- Every line must change agent behavior — delete lines that don't

### Verification

State-changing commands must include a verify step with PASS/FAIL reporting. If verification fails, fix and re-verify in a loop.

## Guidelines

- Keep kits focused on a single domain
- Rules should be actionable, not aspirational
- Commands should collect all input in one prompt (single-reply intake)
- Test the kit on a real project before publishing
- Kit activation must be idempotent
