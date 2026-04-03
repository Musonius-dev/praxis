# Phase Detection — Rules
# Scope: All projects, all sessions
# Automatic detection of current workflow phase for adaptive rule loading

## Phase Definitions

| Phase | Signals | Active Rule Focus |
| ----- | ------- | ----------------- |
| **Planning** | `/px-discuss`, `/px-plan`, `/px-spec` invoked; reading specs/plans; no code edits | engineering-judgment, architecture patterns |
| **Implementing** | Code files being written/edited; tests being written | code-quality, code-excellence, language-specific rules |
| **Testing** | Test files being run; test output being analyzed | self-verify, observable-code |
| **Debugging** | `/px-debug` invoked; error analysis; stack traces being read | coding (Context7 mandate), language-specific rules |
| **Reviewing** | `/px-review`, `/px-simplify` invoked; diff analysis | refactor-triggers, code-quality |
| **Shipping** | `/px-ship`, `/px-verify` invoked; pre-commit checks | git-workflow, security-posture |

## Detection Heuristic — Conventions (WARN on violation)

Phase detection is heuristic — infer from the most recent actions:

1. **Explicit signal**: A phase-associated skill was invoked → phase is known
2. **File type signal**: Editing `.ts` files → Implementing. Reading test output → Testing.
3. **Conversation signal**: Discussing tradeoffs → Planning. Analyzing errors → Debugging.

When phase is ambiguous: default to the broader rule set rather than the narrower one.
Loading extra rules is preferable to missing a constraint.

## Adaptive Loading Behavior — Conventions (WARN on violation)

### What changes per phase
- **Planning**: Prioritize engineering-judgment.md, deprioritize language-specific rules
- **Implementing**: Load language-specific rules for active file types, full code-quality
- **Reviewing**: Load refactor-triggers.md, emphasize simplicity checks
- **Shipping**: Load git-workflow.md pre-commit invariants, security-posture checks

### What never changes
Universal rules (14) are always loaded regardless of phase.
Phase detection adjusts emphasis and attention, not which rules are loaded.
Claude Code does not support dynamic rule unloading — phase detection shapes
which rules get actively applied, not which are present in context.

## Kit Phase Integration

Kits define `skills_chain` with phase fields in their manifests.
When a kit is active, its phases override the generic phases above:
- `code-quality` kit: gate → ai-review → self-review
- `infrastructure` kit: plan → apply → drift → compliance
- `web-designer` kit: design-system-init → component-build → audit → final-lint

Kit phases take precedence when the kit is active.

## Removal Condition
Remove when Claude Code provides native phase-aware rule loading.
