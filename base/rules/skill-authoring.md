---
description: Agent-first authoring constraints for skills, commands, and kit files. Enforces description-as-API, calibrated freedom, progressive disclosure, feedback loops, and token posture.
paths:
  - "**/skills/**"
  - "**/commands/**"
  - "**/kits/**"
---

# Skill & Command Authoring

These rules apply when creating or editing any skill, command, or kit file.

## Frontmatter is mandatory

Every `.md` file in `skills/`, `commands/`, or `kits/commands/` MUST have YAML frontmatter with a `description:` field.

Skills additionally require `disable-model-invocation: true`.

## Description field = discovery API

The `description:` determines whether the agent invokes this file. Write it as:

1. Third person, imperative mood.
2. State WHAT it does AND WHEN to activate (trigger keywords).
3. Include scope boundaries (what it does NOT do).
4. One sentence, max two.

**Bad:** `"Bootstrap a new project"`
**Good:** `"Scaffolds a new project with vault entry, CLAUDE.md, and progress tracking. Activates on 'new project', 'init', 'bootstrap'. Not for existing repos — use scaffold-exist."`

## Calibrate degrees of freedom

Declare the freedom level in the description or first section:

- **Low freedom** — Destructive or precise operations (deploys, migrations, checkpoints). Follow steps exactly. No improvisation.
- **Medium freedom** — Templated output (specs, plans, risk registers). Follow structure; adapt content to context.
- **High freedom** — Creative work (reviews, component design, documentation). Use judgment within stated constraints.

## Progressive disclosure

- SKILL.md is the entry point. Keep it under 500 lines.
- Put templates, examples, and reference material in a `references/` subdirectory.
- Reference files must be one level deep from SKILL.md — the agent partially reads deeper references.
- Prefer executing validation scripts over reading them into context. Only the output consumes tokens.

## Feedback loops

State-changing skills MUST include a validate-fix-repeat cycle:

1. Define machine-readable PASS/FAIL criteria.
2. After execution, run verification against those criteria.
3. If FAIL: list specific errors with file path and line, fix, re-verify.
4. Do not declare completion until all checks PASS.

Output-only commands (standup, risk) that produce a report without changing state are exempt.

## Token posture

Every line must change agent behavior. Delete:

- Marketing copy ("This powerful feature...")
- Explanatory prose the agent will not act on
- Redundant restatements of rules defined elsewhere
- Comments that describe what the next line does when the line is self-evident

## Body prose style

- Imperative mood: "Create the file" not "The file is created"
- Lead with the action, not the context
- If a step has substeps, use a flat numbered list — not nested headings
