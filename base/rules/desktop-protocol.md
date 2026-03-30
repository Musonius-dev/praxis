# Desktop Protocol — Rules
# Scope: Sessions involving Claude Desktop ↔ Claude Code handoff
# Defines role boundaries and structured handoff format

## Role Boundaries

| Surface | Role | Responsible for |
|---------|------|-----------------|
| Claude Desktop | Architect / Reviewer | ADR review, security audit, diff validation, prompt engineering |
| Claude Code | Executor | File writes, git ops, test runs, tool use, vault updates |

Desktop generates structured intent. Code executes it.
Never use Desktop for file writes. Never use Code for open-ended architecture debate.

## Handoff Format — Desktop → Code

When Desktop completes a review or decision, it emits a structured handoff block.
Code reads this block as its initial task context.

```
HANDOFF:
  TASK: [one-line description]
  SPEC: [link to vault plan or spec file]
  CONSTRAINTS: [hard limits — what must NOT change]
  ACCEPTANCE: [how to know it's done]
  CONTEXT: [optional — key decisions or rationale from review]
```

Code MUST NOT start implementation without at least TASK and ACCEPTANCE filled.
If SPEC is missing, Code asks before proceeding.

## Handoff Format — Code → Desktop

When Code completes implementation and wants architectural review:

```
REVIEW-REQUEST:
  TASK: [what was implemented]
  DIFF: [git diff summary or branch name]
  SPEC: [link to plan that drove this work]
  QUESTIONS: [specific things to review — not "does this look good"]
```

## Vault Write-Back

After Desktop review, append the decision to `{vault_path}/notes/review-decisions.md`:

```
## YYYY-MM-DD | [task-slug]
- **Decision**: APPROVED | CHANGES_REQUESTED | DEFERRED
- **Rationale**: [1-2 sentences]
- **Action items**: [if CHANGES_REQUESTED — specific items for Code to address]
```

## Conventions — WARN on violation

- Desktop review decisions that affect architecture go to `{vault_path}/specs/` as ADRs
- Desktop review decisions that are tactical (naming, style, small refactors) stay in `review-decisions.md`
- Code must not self-approve architectural changes — route through Desktop review
- If Desktop is unavailable, Code may proceed but must flag the decision in `status.md` for later review

## Removal Condition
Remove when a unified Claude surface handles both architecture review and code execution
natively, eliminating the need for explicit handoff protocols.
