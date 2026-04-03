# Multi-Agent Orchestration — Rules
# Scope: All projects, all sessions
# Governs when and how to use multi-agent patterns

## Agent Patterns

### Single-Agent (default)
One Claude instance handles the full task. Subagents handle scoped delegation
(review, simplify, explore) per the `px-subagent` dispatch protocol.

**Use when:** Task touches ≤3 files, single domain, straightforward implementation.

### Generator/Evaluator
Generator produces output. Evaluator critically reviews against spec, scoring on
correctness, completeness, style compliance, and test coverage.

**Use when:** Task touches >5 files, crosses module boundaries, or has high
correctness requirements (auth, data integrity, public API changes).

### Planner/Generator/Evaluator
Planner decomposes into subtask graph first. Generator and Evaluator work each subtask.

**Use when:** Task spans multiple milestones, requires architectural decisions,
or the plan itself needs adversarial review.

## Activation Thresholds — Conventions (WARN on violation)

| Signal | Single-Agent | Generator/Evaluator | Planner/Generator/Evaluator |
| ------ | ------------ | ------------------- | --------------------------- |
| Files changed | ≤3 | 4-10 | 10+ |
| Domains crossed | 1 | 2 | 3+ |
| Milestone count | 1 | 1-2 | 3+ |
| Risk level | Low | Medium | High |

These are guidelines, not hard gates. Use judgment — a 2-file auth change
may warrant Generator/Evaluator; a 15-file rename may not.

## Evaluator Agent Spec

When Generator/Evaluator mode is active, the Evaluator receives:

| Input | Source |
| ----- | ------ |
| Diff | Generator's output (staged changes) |
| SPEC | From active plan file |
| Rules | Relevant quality rules for file types in diff |
| Test output | If tests were run |

The Evaluator does NOT receive conversation history.

### Evaluator scoring rubric

| Dimension | Weight | Criteria |
| --------- | ------ | -------- |
| Correctness | 40% | Does the code do what the spec says? All paths handled? |
| Completeness | 25% | Are all acceptance criteria met? Tests present? |
| Style compliance | 20% | Naming, structure, quality rules respected? |
| Test coverage | 15% | Happy path, failure path, edge cases covered? |

### Evaluator output format
Uses the same severity format as `px-subagent`:
```
{file}:{line} — {severity} — {category} — {description} — {fix}
```

### Escalation
- Critical findings → Generator must fix before proceeding
- Major findings → Generator should fix before merge
- >3 findings addressed → re-run Evaluator (max 3 rounds)

## Planner Agent Spec

When Planner mode is active, the Planner receives:
- PROBLEM / DELIVERABLE / ACCEPTANCE / BOUNDARIES
- Relevant codebase context (file structure, key interfaces)
- Active constraints from rules

The Planner outputs a subtask graph:
```
1. [subtask] — {files} — {acceptance criteria}
   └─ depends_on: []
2. [subtask] — {files} — {acceptance criteria}
   └─ depends_on: [1]
```

Generator and Evaluator process each subtask in dependency order.

## Integration with Existing Skills

| Skill | Orchestration role |
| ----- | ------------------ |
| `/px-plan` | May invoke Planner agent for complex decomposition |
| `/px-review` | Already uses Evaluator pattern via `px-subagent` |
| `/px-verify` | Self-review step is a lightweight Evaluator |
| `/px-execute` | Generator role — produces implementation |

## Removal Condition
Remove when Claude Code provides native multi-agent orchestration with
built-in evaluator and planner agent types.
