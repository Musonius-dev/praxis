#!/usr/bin/env bash
# on-stop-failure.sh — StopFailure hook (Auto mode failure classifier)
# Reads Claude's stop context, classifies the failure, and either:
#   - Auto-repairs (transient: test fail, lint fail, tool error) → exit 0 (continue)
#   - Escalates to human (boundary/spec/security violation) → exit 1 (halt)
# Tracks repair attempts per failure fingerprint to prevent infinite loops.
# Reuses PPID-scoped state pattern from recursion-guard.sh.
set -euo pipefail

if ! command -v jq &>/dev/null; then
  echo "on-stop-failure: jq required but not found. Cannot classify failure." >&2
  exit 1
fi

# ── Parse input (single jq call) ──
INPUT=$(cat)
PARSED=$(echo "$INPUT" | jq -r '[
  (.exit_code // 1 | tostring),
  (.stop_reason // ""),
  (.last_tool_use.name // ""),
  (.last_tool_use.error // "")
] | join("\t")' 2>/dev/null || echo "1\t\t\t")

IFS=$'\t' read -r EXIT_CODE STOP_REASON LAST_TOOL TOOL_ERROR <<< "$PARSED"

MAX_REPAIR_ATTEMPTS=3
MAX_FINGERPRINT_LEN=200

# ── Repair attempt tracker (PPID-scoped, same pattern as recursion-guard.sh) ──
REPAIR_STATE="/tmp/praxis-repair-${PPID}.json"
if [[ ! -f "$REPAIR_STATE" ]]; then
  echo '{"repair_attempts":0,"last_fingerprint":""}' > "$REPAIR_STATE"
fi

# Compare raw fingerprint strings — no hash needed for equality checks
FINGERPRINT="${EXIT_CODE}:${LAST_TOOL}:${STOP_REASON:0:$MAX_FINGERPRINT_LEN}"

# Single jq call to read both fields
STATE_READ=$(jq -r '[(.last_fingerprint // ""), (.repair_attempts // 0 | tostring)] | join("\t")' "$REPAIR_STATE" 2>/dev/null || echo $'\t0')
IFS=$'\t' read -r LAST_FINGERPRINT CURRENT_ATTEMPTS <<< "$STATE_READ"

# Same fingerprint = looping on the same error
if [[ "$FINGERPRINT" == "$LAST_FINGERPRINT" ]]; then
  CURRENT_ATTEMPTS=$((CURRENT_ATTEMPTS + 1))
else
  CURRENT_ATTEMPTS=1
fi

# Atomic state file update (tmp + mv)
TMP_STATE="${REPAIR_STATE}.tmp"
jq -n --argjson attempts "$CURRENT_ATTEMPTS" --arg fp "$FINGERPRINT" \
  '{"repair_attempts": $attempts, "last_fingerprint": $fp}' \
  > "$TMP_STATE" && mv "$TMP_STATE" "$REPAIR_STATE"

# ── Hard escalation: too many repair attempts on same failure ──
if [[ $CURRENT_ATTEMPTS -gt $MAX_REPAIR_ATTEMPTS ]]; then
  echo "AUTO-REPAIR EXHAUSTED: $CURRENT_ATTEMPTS attempts on same failure." >&2
  echo "Failure: exit=$EXIT_CODE tool=$LAST_TOOL" >&2
  echo "Halting — human review required." >&2

  CONFIG="$HOME/.claude/praxis.config.json"
  if [[ -f "$CONFIG" ]]; then
    VAULT_PATH=$(jq -r '.vault_path // ""' "$CONFIG" 2>/dev/null)
    if [[ -n "$VAULT_PATH" && -d "$VAULT_PATH" ]]; then
      TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
      ESCALATION_FILE="$VAULT_PATH/notes/escalations.md"

      if [[ ! -f "$ESCALATION_FILE" ]]; then
        printf -- "---\ntags: [escalation, auto-repair]\ndate: %s\nsource: agent\n---\n\n# Auto-Repair Escalations\n" \
          "$(date +%Y-%m-%d)" > "$ESCALATION_FILE"
      fi

      printf "\n## %s\n- **Failure**: exit=%s tool=%s\n- **Attempts**: %s\n- **Reason**: %s\n- **Status**: HALTED — needs human review\n" \
        "$TIMESTAMP" "$EXIT_CODE" "$LAST_TOOL" "$CURRENT_ATTEMPTS" "${STOP_REASON:0:$MAX_FINGERPRINT_LEN}" \
        >> "$ESCALATION_FILE"
    fi
  fi

  exit 1
fi

# ── Hard escalation patterns (single regex, never auto-repair these) ──
HARD_REGEX="BLOCKED:|secret detected|Protected path|out of scope|permission denied|identity mismatch"
COMBINED_CONTEXT="$STOP_REASON $TOOL_ERROR"

if echo "$COMBINED_CONTEXT" | grep -qiE "$HARD_REGEX"; then
  MATCHED=$(echo "$COMBINED_CONTEXT" | grep -oiE "$HARD_REGEX" | head -1)
  echo "ESCALATING: Hard violation — '$MATCHED' matched." >&2
  echo "Auto-repair suppressed. Human review required." >&2
  exit 1
fi

# Exit code 2 = guard hard-block (recursion-guard.sh, secret-scan.sh, file-guard.sh convention)
if [[ "$EXIT_CODE" == "2" ]]; then
  echo "ESCALATING: Exit code 2 = guard hard-block. No auto-repair." >&2
  exit 1
fi

# ── Transient failure → emit repair prompt (Auto mode continues) ──
# Claude Code reads stdout from StopFailure hooks as an injected prompt.

cat <<REPAIR
Auto-repair attempt $CURRENT_ATTEMPTS of $MAX_REPAIR_ATTEMPTS.

Failure context:
- Exit code: $EXIT_CODE
- Last tool: $LAST_TOOL
- Stop reason: ${STOP_REASON:0:500}
- Tool error: ${TOOL_ERROR:0:$MAX_FINGERPRINT_LEN}

Instructions:
1. Read the error above carefully. Identify the root cause from actual output.
2. Apply the minimum fix required. Do not expand scope.
3. Re-run validation (tests + lint) after fixing.
4. If this is attempt $CURRENT_ATTEMPTS of $MAX_REPAIR_ATTEMPTS and the fix is not obvious:
   report What / So What / Now What and halt.

Do NOT re-attempt the same approach that just failed.
REPAIR

exit 0
