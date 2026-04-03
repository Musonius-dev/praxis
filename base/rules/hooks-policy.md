# Hooks Policy — Rules
# Scope: All projects, all sessions
# Documents which hooks are mandatory vs optional

## Hook Inventory

### Mandatory — must not be disabled (BLOCK on violation)

| Hook | Event | Purpose |
| ---- | ----- | ------- |
| `secret-scan.sh` | PreToolUse: Write/Edit | Blocks credential patterns in code |
| `credential-guard.sh` | PreToolUse: Bash | Blocks access to protected credential paths |
| `identity-check.sh` | PreToolUse: Bash | Verifies git identity before commits |
| `file-guard.sh` | PreToolUse: Write/Edit | Blocks writes to protected file patterns |
| `vault-checkpoint.sh` | PreCompact | Saves state before context compaction |

These hooks are security and data-integrity controls. Disabling them requires
explicit user approval with documented justification.

### Required — should not be disabled without reason (WARN on violation)

| Hook | Event | Purpose |
| ---- | ----- | ------- |
| `dep-audit.sh` | PostToolUse: Write/Edit | Audits dependencies when manifests change |
| `session-data-collect.sh` | Stop | Captures session metadata for vault |
| Stop vault prompt | Stop | Writes session summary and vault updates |
| `on-stop-failure.sh` | StopFailure | Error handling for failed stop hooks |

### Optional — enhance but not required

| Hook | Event | Purpose |
| ---- | ----- | ------- |
| `auto-format.sh` | PostToolUse: Write/Edit | Auto-formats files after edits |
| `recursion-guard.sh` | PreToolUse | Prevents recursive tool invocation |

## Adding New Hooks

Before adding a hook to `settings-hooks.json`:
1. Classify as mandatory, required, or optional using the criteria above
2. Mandatory: security or data-integrity function — must never silently fail
3. Required: workflow quality — should warn on failure but not block
4. Optional: convenience — can be disabled per-project
5. All hooks must exit 0 on success, non-zero to block (PreToolUse only)
6. All hooks must handle missing dependencies gracefully (exit 0 if tool not found)

## Hook Configuration

Hooks are declared in `base/hooks/settings-hooks.json`.
Install copies them to `~/.claude/settings.json` during `install.sh`.
Project-specific hooks can be added in project `.claude/settings.json`.

## Removal Condition
Remove when Claude Code provides a native hook policy/priority system.
