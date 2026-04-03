# Context Budget — Rules
# Scope: All projects, all sessions
# Quantitative budget for context window usage
# Companion to context-management.md (qualitative bracket discipline)

## Budget Allocation — Invariants (BLOCK on violation)

### Zone model

The context window is a finite resource. Allocate it deliberately:

| Zone | Share | Contents |
| ---- | ----- | -------- |
| System overhead | ~15-20% | CLAUDE.md, universal rules, settings, MCP tool schemas |
| Working content | ~55-65% | Code, plans, conversation, tool output |
| Reserve | ~20% | Buffer for compaction, final outputs, tool responses |

When working content approaches capacity (signals below), begin offloading to vault.
Never wait for compaction to force the issue.

### Budget signals (quantitative bracket thresholds)

| Signal | FRESH | MODERATE | DEPLETED |
| ------ | ----- | -------- | -------- |
| Tool calls | <15 | 15-35 | 35+ |
| Files read | <8 | 8-20 | 20+ |
| Large files (>200 lines) in session | <2 | 2-4 | 5+ |
| Corrections received | 0 | 1 | 2+ |

These thresholds feed `context-management.md` brackets and `/px-context-probe`.

## Cost-Conscious Loading — Conventions (WARN on violation)

### MCP servers
- Connect 2-3 core servers at session start (context7, github).
- Lazy-load optional servers (perplexity, filesystem, sequential-thinking) only when the task requires them.
- Never connect all registered servers preemptively — each adds schema overhead.

### File reads
- Read targeted line ranges (`offset`/`limit`), not entire files, when you know the section.
- Files >200 lines: read the relevant section, not the whole file.

### Search output
- Use `files_with_matches` for initial discovery; switch to `content` only for confirmed matches.
- Delegate exploration expected to produce >50 lines of output to a subagent.

## Universal Rule Weight — Conventions (WARN on violation)

The 14 universal rules consume ~50KB of every session's context budget.

- Before proposing a new universal rule: justify the always-loaded cost.
- Prefer scoped rules (path-matched) over universal ones when the rule applies to a specific domain.
- New universal rules must stay under 3KB individually.
- If a universal rule exceeds 100 lines: split into a short universal rule and a scoped reference file.

## Budget Actions

| Bracket | Action |
| ------- | ------ |
| FRESH | No budget concern. Batch aggressively, load full context. |
| MODERATE | Prefer concise output. Stop reading whole files. Use subagents for exploration. |
| DEPLETED | Run `/px-compact` for mid-session optimization, or `/px-context-reset` + `/clear` for full reset. |
| CRITICAL | STOP new work. Complete current milestone. Write all state to vault. New session. |

## Removal Condition
Remove when Claude Code exposes native token utilization metrics and budget enforcement.
