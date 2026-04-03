# Skill Authoring — Rules
# Scope: Creating or editing base/skills/*/SKILL.md files
# Codifies agent-first skill design principles

## Agent-First Principle

The agent is the primary reader of every skill. Design decisions optimize for
how Claude discovers, loads, and executes a skill — not for how a human browses.

## SKILL.md Structure — Invariants (BLOCK on violation)

### Frontmatter (required)
```yaml
---
name: px-{skill-name}
disable-model-invocation: true  # false only for auto-trigger skills
description: "{what it does}. {when to use it}."
---
```

### Description as discovery API
The description field is how Claude selects this skill from 40+ candidates.

- Write in third person — descriptions are injected into the system prompt
- Include BOTH what the skill does AND when to activate it
- Include trigger keywords the user is likely to say
- Bad: "Helps with infrastructure" (too vague to discover)
- Good: "Generates Terraform modules for Azure resources. Use when the user asks to create, modify, or scaffold infrastructure."

### Body structure
- Imperative voice — step-by-step, not conversational
- Flat structure — one level of headings, no deep nesting
- Every line must change agent behavior or it's dead weight
- Under 150 lines — skills over 150 lines should split into a skill + reference file

## Degrees of Freedom — Conventions (WARN on violation)

Calibrate constraint tightness to operation risk:

| Freedom | When | Example skills |
| ------- | ---- | -------------- |
| High (text guidance) | Multiple valid paths, creative work | px-discuss, px-review |
| Medium (templates) | Structured output, consistent format | px-plan, px-session-retro |
| Low (exact scripts) | Destructive ops, security-sensitive | px-ship, px-secret-scan |

### Feedback loops
Non-trivial skills must include a validate → fix → repeat cycle:
- Produce intermediate artifact
- Validate it (test, lint, structural check)
- Iterate until validation passes
- Verbose error messages so Claude can self-correct

## Naming Convention — Conventions (WARN on violation)

- Prefix: `px-` for all Praxis skills
- Format: short verb or noun — `px-verify`, `px-plan`, `px-debug`
- Not gerunds — slash commands read better as `/px-verify` than `/px-verifying`
- Kit skills: `{kit-prefix}:{action}` — `/infra:plan`, `/kg:query`

## Boundaries Section — Conventions (WARN on violation)

Every skill with side effects must include a `## Boundaries` section:
- What is explicitly out of scope
- What the skill must NOT modify
- Maximum attempts before escalation
- Whether user approval is required for destructive actions

## Progressive Disclosure — Conventions (WARN on violation)

- SKILL.md is the entry point — keep it under 150 lines
- Additional context in reference files one level deep from SKILL.md
- Prefer executing scripts over reading them into context
- Name files for content, not sequence: `validation_rules.md` not `doc2.md`

## Testing New Skills

1. Write the skill
2. Load it in a fresh session (Claude B)
3. Invoke with a realistic prompt
4. Check: Did Claude discover it? Execute it correctly? Follow boundaries?
5. Tighten constraints where Claude diverged from intent

## Removal Condition
Remove when Claude Code provides a native skill authoring wizard with
built-in agent-first validation.
