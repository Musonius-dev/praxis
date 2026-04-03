# Session Bridge — Rules
# Scope: All projects, all sessions
# Protocol for session handoff: end-of-session persist + start-of-session rehydrate

## End-of-Session Persist — Invariants (BLOCK on violation)

### Mandatory writes before session ends
1. Update `{vault_path}/status.md` with current What / So What / Now What
2. Update `{vault_path}/claude-progress.json` with session entry
3. Write session note to `{vault_path}/notes/{YYYY-MM-DD}_session-note.md`

These are already enforced by the Stop hook prompt. This rule makes explicit
that the vault write is the bridge — conversation state that isn't persisted is lost.

## Start-of-Session Rehydrate — Conventions (WARN on violation)

### Bootstrap sequence (extends After Compaction § in CLAUDE.md)
1. Read project CLAUDE.md
2. Read `{vault_path}/status.md` for loop position and current plan
3. Read active plan file (current milestone only)
4. Search vault for context relevant to active task: `rg "{task topic}" {vault_path}/specs/ {vault_path}/notes/`
5. Load rules scoped to the current task's file types

## Cross-Session Continuity — Conventions (WARN on violation)

### What survives sessions (via vault)
- Decisions, specs, ADRs → `{vault_path}/specs/`
- Session summaries → `{vault_path}/notes/`
- Learnings → `{vault_path}/notes/learnings.md`
- Task state → `{vault_path}/status.md`, `claude-progress.json`
- Plan progress → `{vault_path}/plans/`

### What does NOT survive sessions
- Conversation context (volatile — this is by design)
- File contents read into context (re-read as needed)
- Subagent outputs (summarize findings into vault if important)

## Removal Condition
Remove when Claude Code provides native cross-session memory persistence.
