#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"
CONFIG_FILE="${CLAUDE_DIR}/praxis.config.json"

# ── Flag parsing ─────────────────────────────────────────────────────────

VAULT_PATH="${PRAXIS_VAULT_PATH:-}"
PPLX_KEY="${PERPLEXITY_API_KEY:-}"
NO_MCP=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --vault)       VAULT_PATH="$2"; shift 2 ;;
    --perplexity-key) PPLX_KEY="$2"; shift 2 ;;
    --no-mcp)      NO_MCP=true; shift ;;
    --help|-h)
      echo "Usage: bash install.sh [options]"
      echo ""
      echo "Options:"
      echo "  --vault <path>            Obsidian vault path (or PRAXIS_VAULT_PATH env var)"
      echo "  --perplexity-key <key>    Perplexity API key (or PERPLEXITY_API_KEY env var)"
      echo "  --no-mcp                  Skip MCP server registration"
      echo "  --help, -h                Show this help"
      exit 0
      ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

echo "=== Praxis Installer (bash) ==="
echo ""

# Ensure ~/.claude exists
mkdir -p "${CLAUDE_DIR}"

# ── Symlink base assets ──────────────────────────────────────────────

symlink() {
  local src="$1" dst="$2"
  if [ -L "$dst" ]; then
    local current
    current="$(readlink "$dst")"
    if [ "$current" = "$src" ]; then
      echo "  ✓ ${dst} (already linked)"
      return
    fi
    rm "$dst"
  elif [ -e "$dst" ]; then
    echo "  ⚠ ${dst} exists and is not a symlink — skipping (back up manually)"
    return
  fi
  ln -s "$src" "$dst"
  echo "  → ${dst}"
}

echo "Linking base assets into ${CLAUDE_DIR}/ …"
symlink "${SCRIPT_DIR}/base/CLAUDE.md"  "${CLAUDE_DIR}/CLAUDE.md"
symlink "${SCRIPT_DIR}/base/rules"      "${CLAUDE_DIR}/rules"
symlink "${SCRIPT_DIR}/base/commands"   "${CLAUDE_DIR}/commands"
symlink "${SCRIPT_DIR}/base/skills"     "${CLAUDE_DIR}/skills"
echo ""

# ── Obsidian vault path ──────────────────────────────────────────────

if [ -f "$CONFIG_FILE" ] && [ -z "$VAULT_PATH" ]; then
  echo "Config already exists: ${CONFIG_FILE}"
  echo "  To reconfigure, pass --vault or delete the file and re-run."
elif [ -n "$VAULT_PATH" ]; then
  # Expand ~ manually
  VAULT_PATH="${VAULT_PATH/#\~/$HOME}"

  if [ ! -d "$VAULT_PATH" ]; then
    echo "  ⚠ Directory does not exist: ${VAULT_PATH}"
    echo "  Writing config anyway — create the directory before using vault features."
  fi

  cat > "$CONFIG_FILE" <<EOF
{
  "vault_path": "${VAULT_PATH}"
}
EOF
  echo "  ✓ Wrote ${CONFIG_FILE}"
elif [ -t 0 ]; then
  # Interactive TTY — prompt for vault path
  read -rp "Obsidian vault path (e.g. ~/Documents/Obsidian, or press Enter to skip): " vault_input
  if [ -n "$vault_input" ]; then
    vault_input="${vault_input/#\~/$HOME}"
    if [ ! -d "$vault_input" ]; then
      echo "  ⚠ Directory does not exist: ${vault_input}"
      echo "  Writing config anyway — create the directory before using vault features."
    fi
    cat > "$CONFIG_FILE" <<EOF
{
  "vault_path": "${vault_input}"
}
EOF
    echo "  ✓ Wrote ${CONFIG_FILE}"
  else
    echo "  ⊘ Vault path skipped (use --vault to set later)"
  fi
else
  echo "  ⊘ No vault path configured (use --vault to set)"
fi
echo ""

# ── MCP Servers ────────────────────────────────────────────────────

if [ "$NO_MCP" = false ]; then
  echo "MCP servers …"

  if command -v claude &>/dev/null; then
    if [ -n "$PPLX_KEY" ]; then
      if claude mcp add perplexity --scope user -e PERPLEXITY_API_KEY="$PPLX_KEY" -- npx -yq @perplexity-ai/mcp-server 2>/dev/null; then
        echo "  ✓ Registered MCP: perplexity"
      else
        echo "  ⚠ MCP registration failed: perplexity"
        echo "    Register manually: claude mcp add perplexity --scope user -e PERPLEXITY_API_KEY=\"your-key\" -- npx -yq @perplexity-ai/mcp-server"
      fi
    else
      echo "  ⊘ Skipped MCP: perplexity (no API key — use --perplexity-key or PERPLEXITY_API_KEY)"
    fi
  else
    echo "  ⚠ 'claude' CLI not found — skipped MCP registration. Install Claude Code first."
  fi
  echo ""
fi

echo "=== Done ==="
echo "To activate a kit: /kit:web-designer"
