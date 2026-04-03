---
name: px-compact
disable-model-invocation: true
description: "Intelligent mid-session compaction. Triages context, checkpoints to vault, triggers compact, reloads working set. Use when DEPLETED but mid-milestone — no /clear needed."
---

# compact Skill

You are performing an intelligent mid-session compaction to free context budget
while preserving the active working set.

**Key difference from `/px-context-reset`:** No `/clear` required. You stay in the
same session and resume immediately after compaction.

## Vault Path Resolution

Read vault_path from `~/.claude/praxis.config.json`.

---

**Step 1 — Pre-flight check**

Assess context bracket from signals (see `context-budget.md` § Budget signals):

- **FRESH** → Print: "Context is still fresh. Compaction would lose more than it saves." → STOP.
- **CRITICAL with no active milestone** → Print: "Context is critically degraded with no active milestone. Use `/px-context-reset` + `/clear` instead." → STOP.
- **MODERATE/DEPLETED/CRITICAL with active milestone** → Continue.

**Step 2 — Triage context**

Classify all loaded context into priority tiers:

| Tier | Action |
| ---- | ------ |
| T1: Active working set (current file, active milestone, failing tests) | Keep — reload after compact |
| T2: Decision context (SPEC, constraints, last 3 decisions) | Keep — include in checkpoint |
| T3: Session history (earlier discussion, exploration, superseded approaches) | Offload summaries to vault |
| T4: Reference material (docs consumed, examples applied) | Drop |

For T3 items with decision value: append summaries to `{vault_path}/plans/{YYYY-MM-DD}-triage-offload.md`.

**Step 3 — Write compact checkpoint**

Write `{vault_path}/plans/{YYYY-MM-DD}-compact-checkpoint.md`:

```markdown
---
tags: [checkpoint, compact, triage]
date: {YYYY-MM-DD}
source: agent
---
# Compact Checkpoint — {YYYY-MM-DD HH:MM}

## Active Working Set (reload after compact)
- File: {path} — {what you are doing with it}
- File: {path} — {what you are doing with it}

## Current Milestone
{milestone name from active plan}

## Decisions (last 3)
1. {decision} — {rationale}
2. {decision} — {rationale}
3. {decision} — {rationale}

## Offloaded This Session
See: plans/{YYYY-MM-DD}-triage-offload.md

## Next Step After Compact
{exact next action — be specific}
```

**Step 4 — Update vault state**

1. Update `{vault_path}/status.md` — refresh What / So What / Now What
2. Update `{vault_path}/claude-progress.json` — add session entry with `"source": "compact"`

**Step 5 — Trigger compaction**

Print the bootstrap instructions first:

```
Compact checkpoint saved. Triggering compaction.

After compaction, re-bootstrap:
1. Read {vault_path}/plans/{YYYY-MM-DD}-compact-checkpoint.md
2. Read the active plan: {plan-filename}, milestone: {milestone-name}
3. Re-read only files listed in "Active Working Set" above
4. Resume: {next step}
```

Then run `/compact` (Claude Code built-in).

**Note:** The PreCompact hook (`vault-checkpoint.sh`) will also fire and write its own
checkpoint. The triage checkpoint from Step 3 is authoritative — it contains the
curated working set. The hook checkpoint is a safety net.

## Removal Condition

Remove when Claude Code provides native intelligent compaction with working set preservation.
