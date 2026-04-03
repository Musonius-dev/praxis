# Session Metrics — Rules
# Scope: All projects, all sessions
# Tracks harness-level performance for self-improvement

## Metric Collection — Conventions (WARN on violation)

### Metrics captured by existing hooks
The Stop hook and session-data-collect.sh already capture:
- Session date and timestamp
- Branch and last commit
- Accomplishments (via vault prompt)
- Corrections count (via session-retro)
- Learn entries count (via session-retro)

### Additional metrics to track (when session-retro runs)
Append these to the session entry in `claude-progress.json`:

| Metric | Source | Purpose |
| ------ | ------ | ------- |
| `compaction_count` | Count compact checkpoints for today | How often context exhausted |
| `files_modified` | `git diff --stat` at session end | Session scope indicator |
| `milestones_completed` | Plan file milestone checkmarks | Throughput indicator |
| `repair_attempts` | Count repair traces in vault | Code quality signal |
| `phase_time` | Estimated split across plan/implement/verify | Bottleneck detection |

### Metrics directory
When session-retro produces structured metrics, write to:
`{vault_path}/metrics/{YYYY-MM-DD}_session-metrics.md`

Format:
```markdown
---
tags: [metrics, session]
date: YYYY-MM-DD
source: agent
---
# Session Metrics — {YYYY-MM-DD}

| Metric | Value |
| ------ | ----- |
| Milestones completed | {n} |
| Files modified | {n} |
| Compactions | {n} |
| Repair attempts | {n} |
| Corrections | {n} |
| Learnings | {n} |
| Phase split | Plan {n}% / Implement {n}% / Verify {n}% |
```

## Pattern Detection — Conventions (WARN on violation)

After 5+ sessions with metrics, look for:
- Debugging consistently >40% of session time → suggest architectural review
- Compaction count >2 per session → suggest smaller task scoping
- Repair attempts >3 per session → suggest better spec clarity
- Corrections >2 per session → suggest context reset or rule update

Surface patterns in `/px-session-retro` Phase 7 (Session Health Assessment).

## Removal Condition
Remove when Claude Code provides native session analytics and performance tracking.
