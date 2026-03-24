#!/bin/bash
set -euo pipefail

echo "=== Praxis: Installing api kit ==="
echo ""

PASS=0
TOTAL=0

check() {
  TOTAL=$((TOTAL + 1))
  if command -v "$1" &>/dev/null; then
    echo "  ✓ $1 found ($(command -v "$1"))"
    PASS=$((PASS + 1))
  else
    echo "  ✗ $1 not found"
    echo "    Install: $2"
  fi
}

echo "Checking optional CLI tools..."
echo ""

check "jq"      "brew install jq  OR  apt-get install jq"
check "curl"    "pre-installed on macOS/Linux"

echo ""
echo "  $PASS/$TOTAL tools found"
echo ""

echo "Note: This kit uses Claude's built-in analysis capabilities."
echo "No external API linting tools required."
echo ""
echo "Commands available: /api:spec, /api:review, /api:contract"
echo ""
echo "=== api kit check complete ==="
echo "Activate with: /kit:api"
echo ""
