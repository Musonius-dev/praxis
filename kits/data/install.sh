#!/bin/bash
set -euo pipefail

echo "=== Praxis: Installing data kit ==="
echo ""

PASS=0
TOTAL=0

check() {
  TOTAL=$((TOTAL + 1))
  if command -v "$1" &>/dev/null; then
    echo "  ✓ $1 found ($(command -v "$1"))"
    PASS=$((PASS + 1))
  else
    echo "  ✗ $1 not found (optional)"
    echo "    Install: $2"
  fi
}

echo "Checking optional CLI tools..."
echo ""

check "psql"    "brew install postgresql  OR  apt-get install postgresql-client"
check "mysql"   "brew install mysql-client  OR  apt-get install mysql-client"
check "mongosh" "brew install mongosh  OR  https://www.mongodb.com/try/download/shell"
check "jq"      "brew install jq  OR  apt-get install jq"

echo ""
echo "  $PASS/$TOTAL tools found"
echo ""

echo "Note: This kit uses Claude's built-in analysis for schema and query review."
echo "Database CLI tools are needed only for live query testing."
echo ""
echo "Commands available: /data:schema, /data:migration, /data:query"
echo ""
echo "=== data kit check complete ==="
echo "Activate with: /kit:data"
echo ""
