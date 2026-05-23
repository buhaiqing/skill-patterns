#!/usr/bin/env bash
# Round 0 门禁：未通过则禁止进入 Round 1（本地/编排者自检）
set -euo pipefail

[[ $# -eq 1 ]] || { echo "usage: check_round0_gate.sh TASK_ID" >&2; exit 1; }

TASK_ID="$1"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INST="${ROOT}/references/rubric-instances/${TASK_ID}-rubric.md"
fail=0

err() { echo "GATE: $*" >&2; fail=1; }

[[ -f "$INST" ]] || err "missing rubric instance: ${INST} (run instantiate_rubric.sh)"

if [[ -f "$INST" ]]; then
  tid=$(awk -F': ' '/^template_id:/ {print $2; exit}' "$INST" | tr -d ' ')
  [[ -n "$tid" ]] || err "instance missing template_id in header"
  if [[ "$tid" != "generic-default" ]]; then
    reg="${ROOT}/references/rubric-templates/_registry.yaml"
    grep -qE -e "- id: \"${tid}\"" "$reg" || err "template_id '${tid}' not found in _registry.yaml"
  fi
  if grep -q 'confirm_status: pending' "$INST" || ! grep -q 'confirm_status: confirmed' "$INST"; then
    err "instance not confirmed (need confirm_status: confirmed)"
  fi
  if grep -qE '\{[A-Z_]+\}' "$INST"; then
    err "unfilled placeholders remain in instance (e.g. {TEST_CMD})"
  fi
  if ! grep -q '^## 评测项' "$INST"; then
    err "instance missing ## 评测项 section"
  fi
fi

if [[ "$fail" -ne 0 ]]; then
  echo "round 0 gate FAILED — do not dispatch Critic" >&2
  exit 1
fi

echo "round 0 gate OK: ${INST}"
echo "Active rubric_path for Handoff: references/rubric-instances/${TASK_ID}-rubric.md"
