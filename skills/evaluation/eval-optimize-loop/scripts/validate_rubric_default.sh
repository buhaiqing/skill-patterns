#!/usr/bin/env bash
# 校验默认 fallback rubric（references/rubric.md）
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="${ROOT}/references/rubric.md"
fail=0

err() { echo "DEFAULT_RUBRIC: $*" >&2; fail=1; }

[[ -f "$FILE" ]] || { echo "missing $FILE" >&2; exit 1; }

grep -q 'rubric-resolution' "$FILE" || err "rubric.md must reference rubric-resolution.md"

grep -q '^## 评测项' "$FILE" || err "rubric.md missing '## 评测项' section"

if ! grep -qE '^\| R[0-9]+ \|' "$FILE"; then
  err "rubric.md missing R-series rubric table rows"
fi

blockers=$(grep -cE '^\| R[0-9]+ \|.*\| BLOCKER \|' "$FILE" || true)
if [[ "$blockers" -lt 2 ]]; then
  err "rubric.md must have at least 2 BLOCKER rows (found ${blockers})"
fi

for rid in R1 R2 R5; do
  grep -qE "^\| ${rid} \|" "$FILE" || err "rubric.md missing required id ${rid}"
done

if ! grep -q '{TEST_CMD}' "$FILE"; then
  err "rubric.md must document {TEST_CMD} placeholder"
fi

if [[ "$fail" -ne 0 ]]; then
  echo "default rubric validation failed" >&2
  exit 1
fi

echo "default rubric OK"
