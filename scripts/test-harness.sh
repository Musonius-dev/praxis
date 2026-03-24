#!/bin/bash
set -euo pipefail

# ════════════════════════════════════════════════════════════════
#  Praxis — Harness Test Suite
#  Functional tests beyond what lint-harness.sh covers:
#  shellcheck, JSON validation, cross-skill refs, hook wiring
# ════════════════════════════════════════════════════════════════

REPO_PATH="${1:-$(cd "$(dirname "$0")/.." && pwd)}"

ERRORS=0
WARNINGS=0
PASS=0
TOTAL=0

error() {
  echo "  ✗ ERROR: $1"
  ERRORS=$((ERRORS + 1))
  TOTAL=$((TOTAL + 1))
}

warn() {
  echo "  ⚠ WARN:  $1"
  WARNINGS=$((WARNINGS + 1))
  TOTAL=$((TOTAL + 1))
}

ok() {
  echo "  ✓ $1"
  PASS=$((PASS + 1))
  TOTAL=$((TOTAL + 1))
}

echo "Praxis Harness Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Repo: $REPO_PATH"

# ── 1. ShellCheck ──────────────────────────────────────────────
echo ""
echo "ShellCheck:"

if command -v shellcheck &>/dev/null; then
  while IFS= read -r -d '' script; do
    name=$(echo "$script" | sed "s|$REPO_PATH/||")
    if shellcheck -S warning "$script" &>/dev/null; then
      ok "$name"
    else
      warn "$name has shellcheck warnings"
    fi
  done < <(find "$REPO_PATH" -name "*.sh" -not -path "*/node_modules/*" -print0 2>/dev/null)
else
  warn "shellcheck not installed — skipping (brew install shellcheck)"
fi

# ── 2. JSON Validation ────────────────────────────────────────
echo ""
echo "JSON validation:"

for json_file in \
  "$REPO_PATH/base/hooks/settings-hooks.json" \
  "$REPO_PATH/templates/claude-progress.json" \
  "$REPO_PATH/package.json"; do
  if [[ -f "$json_file" ]]; then
    name=$(echo "$json_file" | sed "s|$REPO_PATH/||")
    if jq . "$json_file" >/dev/null 2>&1; then
      ok "$name"
    else
      error "$name is invalid JSON"
    fi
  fi
done

# ── 3. Hook Wiring ────────────────────────────────────────────
echo ""
echo "Hook wiring (settings-hooks.json → scripts exist):"

HOOKS_JSON="$REPO_PATH/base/hooks/settings-hooks.json"
if [[ -f "$HOOKS_JSON" ]]; then
  # Extract all .sh filenames referenced in hook commands
  hook_scripts=$(jq -r '.. | .command? // empty' "$HOOKS_JSON" 2>/dev/null | grep -oE '[a-z-]+\.sh' || true)
  for script in $hook_scripts; do
    if [[ -f "$REPO_PATH/base/hooks/$script" ]]; then
      ok "hooks/$script exists"
    else
      error "hooks/$script referenced in settings-hooks.json but not found"
    fi
  done
fi

# ── 4. Cross-Skill References ─────────────────────────────────
echo ""
echo "Cross-skill references:"

# Skills that reference other skills — verify targets exist
declare -A SKILL_REFS
SKILL_REFS["verify"]="repair subagent"
SKILL_REFS["review"]="subagent"
SKILL_REFS["simplify"]="subagent"
SKILL_REFS["verify-app"]="subagent"
SKILL_REFS["repair"]="verify"
SKILL_REFS["execute"]="verify discuss"

for caller in "${!SKILL_REFS[@]}"; do
  for target in ${SKILL_REFS[$caller]}; do
    if [[ -d "$REPO_PATH/base/skills/$target" ]]; then
      ok "$caller → $target"
    else
      error "$caller references skill '$target' which does not exist"
    fi
  done
done

# ── 5. Template Frontmatter ───────────────────────────────────
echo ""
echo "Template frontmatter:"

for tmpl in "$REPO_PATH"/templates/*.md; do
  if [[ -f "$tmpl" ]]; then
    name=$(basename "$tmpl")
    if head -1 "$tmpl" | grep -q "^---"; then
      ok "$name has frontmatter"
    else
      error "$name missing YAML frontmatter"
    fi
  fi
done

# ── 6. Kit Structure ──────────────────────────────────────────
echo ""
echo "Kit structure:"

for kit_dir in "$REPO_PATH"/kits/*/; do
  if [[ -d "$kit_dir" ]]; then
    kit_name=$(basename "$kit_dir")
    for required in KIT.md install.sh teardown.sh; do
      if [[ -f "$kit_dir/$required" ]]; then
        ok "kits/$kit_name/$required"
      else
        error "kits/$kit_name/$required missing"
      fi
    done
  fi
done

# ── 7. Installer Syntax ───────────────────────────────────────
echo ""
echo "Installer:"

if node --check "$REPO_PATH/bin/praxis.js" 2>/dev/null; then
  ok "bin/praxis.js syntax valid"
else
  error "bin/praxis.js has syntax errors"
fi

# ── Summary ───────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Pass:     $PASS"
echo "  Errors:   $ERRORS"
echo "  Warnings: $WARNINGS"

if [[ $ERRORS -gt 0 ]]; then
  echo "  FAILED"
  exit 1
else
  if [[ $WARNINGS -gt 0 ]]; then
    echo "  PASSED with warnings"
  else
    echo "  PASSED"
  fi
fi
