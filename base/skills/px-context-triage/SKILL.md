---
name: px-context-triage
disable-model-invocation: true
description: "Prioritize context contents: what to keep, what to offload to vault, what to drop. Use before compaction or when context bracket is DEPLETED."
---

# context-triage Skill

You are triaging context contents to free budget for continued work.

## Vault Path Resolution

Read vault_path from `~/.claude/praxis.config.json`.

---

**Step 1 — Inventory current context**

From memory (do NOT read files just for inventory), list what is loaded:

| Category | Examples |
| -------- | -------- |
| Code files read/edited | Source files, configs, tests |
| Plan/spec files | Active plan, SPEC, ADRs |
| Conversation topics | Discussion threads, decisions, corrections |
| Reference material | Docs read, research, examples already applied |
| MCP connections | Which servers are active |

**Step 2 — Classify by priority tier**

| Tier | Rule | Examples |
| ---- | ---- | -------- |
| T1: Active working set | Always keep | File being edited, active plan milestone, failing test output |
| T2: Decision context | Keep if FRESH/MODERATE | SPEC, architectural constraints, last 3 decisions |
| T3: Session history | Offload to vault | Earlier discussion, exploration results, superseded approaches |
| T4: Reference material | Drop | Docs already consumed, examples already applied |

**Step 3 — Offload T3/T4 to vault**

For each T3/T4 item that contains decisions or state worth preserving:

1. Append to `{vault_path}/plans/{YYYY-MM-DD}-triage-offload.md` (create if needed, append if exists)
2. Format per item: date, item name, 1-2 line summary, file references if applicable
3. Add YAML frontmatter if creating new file:
   ```yaml
   ---
   tags: [triage, offload]
   date: YYYY-MM-DD
   source: agent
   ---
   ```

Items with no decision value (pure reference, already applied) — drop without saving.

**Step 4 — Report**

```
CONTEXT TRIAGE
━━━━━━━━━━━━━━━━━━━━━
Keeping:    {count} items (T1/T2)
Offloaded:  {count} items to vault
Dropped:    {count} items (no state value)
━━━━━━━━━━━━━━━━━━━━━
```

**Step 5 — Recommend next action**

| Bracket | Recommendation |
| ------- | -------------- |
| FRESH/MODERATE | Triage complete. No compaction needed yet. |
| DEPLETED | Run `/px-compact` now for mid-session optimization. |
| CRITICAL | Run `/px-context-reset` + `/clear` for full reset. |

## Removal Condition

Remove when Claude Code provides native context budget visibility and automatic triage.
