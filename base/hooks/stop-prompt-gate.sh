#!/usr/bin/env bash
# stop-prompt-gate.sh — Gates Stop prompt hooks behind session activity detection.
# Only outputs the prompt text if the session had substantive work.
# Silent exit otherwise — prevents infinite Stop hook loops.
#
# Usage in settings-hooks.json:
#   { "type": "command", "command": "bash ~/.claude/hooks/stop-prompt-gate.sh vault-update" }
#   { "type": "command", "command": "bash ~/.claude/hooks/stop-prompt-gate.sh test-runner" }
set -uo pipefail

PROMPT_TYPE="${1:-vault-update}"
CONFIG_FILE="$HOME/.claude/praxis.config.json"

# ── Detect session activity ──
HAS_RECENT_COMMITS=false
HAS_DIRTY_TREE=false

RECENT=$(git --no-pager log --oneline --since="1 hour ago" 2>/dev/null | head -1)
if [[ -n "$RECENT" ]]; then
  HAS_RECENT_COMMITS=true
fi

DIRTY=$(git --no-pager status --porcelain 2>/dev/null | head -1)
if [[ -n "$DIRTY" ]]; then
  HAS_DIRTY_TREE=true
fi

# Check staging file from session-data-collect.sh
STAGING_DIRTY=false
if [[ -f "$CONFIG_FILE" ]]; then
  VAULT_PATH=$(jq -r '.vault_path // empty' "$CONFIG_FILE" 2>/dev/null)
  STAGING_FILE="${VAULT_PATH:+$VAULT_PATH/.session-staging.json}"
  if [[ -n "$STAGING_FILE" && -f "$STAGING_FILE" ]]; then
    STAGING_DIRTY=$(jq -r '.git.dirty // false' "$STAGING_FILE" 2>/dev/null)
  fi
fi

# ── Gate: no activity → exit silently ──
if [[ "$HAS_RECENT_COMMITS" == "false" && "$HAS_DIRTY_TREE" == "false" && "$STAGING_DIRTY" != "true" ]]; then
  exit 0
fi

# ── Activity detected — output the requested prompt ──
case "$PROMPT_TYPE" in
  test-runner)
    cat << 'PROMPT'
Run the project test suite. Read CLAUDE.md ## Commands for the test command. If no test command defined, respond {ok:true}. Run tests. If all pass: respond {ok:true}. If tests fail: respond {ok:false, reason:'Tests failing: <summary>'}. Do not fix — only report.
PROMPT
    ;;
  vault-update)
    cat << 'PROMPT'
You are completing a session with substantive work. Perform these vault updates silently — no confirmation needed.

1. Read vault_path from ~/.claude/praxis.config.json. If missing: skip all steps.
2. Read {vault_path}/.session-staging.json if it exists (structured session data from hooks).
3. Update {vault_path}/status.md:
   - Set last_updated to today, last_session to now (ISO timestamp)
   - Update loop_position based on where the session ended
   - Refresh What / So What / Now What sections with session accomplishments
   - If >100 lines: archive resolved items to notes/{date}_status-archive.md
4. Update {vault_path}/claude-progress.json:
   - Enrich the latest sessions[] entry (added by hook) with: summary (1 line), accomplishments (array)
   - If jq hook did not run (no sessions[] entry for today): create the full entry
   - Update milestones[] if any milestones were completed this session
   - Update features[] if any features were shipped this session
5. Write {vault_path}/notes/{YYYY-MM-DD}_session-note.md with frontmatter (tags: [session, {project-slug}], date, source: agent) containing:
   - Summary (3-5 bullets of what was accomplished)
   - Decisions Made (checkpoint decisions, scope changes, approach choices made this session)
   - Learnings (any [LEARN:tag] entries from this session)
   - Next Session (what to pick up next)
6. If checkpoint decisions, scope expansions, or rule proposals occurred this session:
   - Append each to {vault_path}/notes/decision-log.md with date, decision type, context, decision, and rationale
7. If corrections or patterns were discovered this session:
   - Append [LEARN:tag] entries to {vault_path}/notes/learnings.md following the existing format
8. If architectural decisions were made this session:
   - Write ADR to {vault_path}/specs/ using vault frontmatter conventions
9. Delete {vault_path}/.session-staging.json if it exists.

Keep all writes concise. Use [[wikilinks]] for internal references. Follow existing YAML frontmatter conventions. If vault_path is missing or vault is inaccessible: skip silently. Do not ask permission — this is automatic housekeeping.
PROMPT
    ;;
  *)
    echo "Unknown prompt type: $PROMPT_TYPE" >&2
    exit 0
    ;;
esac

exit 0
