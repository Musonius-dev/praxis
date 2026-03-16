#!/bin/bash
set -euo pipefail

echo "=== Praxis: Installing infrastructure kit ==="
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

echo "Checking required CLI tools..."
echo ""

check "az"        "https://learn.microsoft.com/en-us/cli/azure/install-azure-cli"
check "terraform"  "https://developer.hashicorp.com/terraform/install"
check "tflint"     "brew install tflint  OR  https://github.com/terraform-linters/tflint"
check "jq"         "brew install jq  OR  apt-get install jq"

echo ""
echo "  $PASS/$TOTAL tools found"
echo ""

if [[ $PASS -lt $TOTAL ]]; then
  echo "  ⚠ Some tools missing. Install them before using infrastructure commands."
fi

echo ""
echo "Note: Skills chain phases are status: planned."
echo "Commands available: /infra:plan, /infra:apply, /infra:drift, /infra:compliance"
echo ""
echo "=== infrastructure kit check complete ==="
echo "Activate with: /kit:infrastructure"
echo ""
