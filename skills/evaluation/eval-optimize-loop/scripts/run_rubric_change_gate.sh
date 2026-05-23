#!/usr/bin/env bash
# Rubric 规则变更后统一门禁：跑 validate_all，非 0 则失败
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
REASON="${1:-rubric rules changed}"

echo "==> Rubric change gate: ${REASON}"
echo "==> Running validate_all.sh ..."
"$DIR/validate_all.sh"
echo "==> Rubric change gate PASSED"
