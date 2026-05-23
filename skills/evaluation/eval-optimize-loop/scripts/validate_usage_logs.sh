#!/usr/bin/env bash
# 校验 usage log YAML（目录内全部，或指定单文件）
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LOG_DIR="${ROOT}/references/rubric-usage-logs"
REGISTRY="${ROOT}/references/rubric-templates/_registry.yaml"
fail=0

err() { echo "USAGE_LOG: $*" >&2; fail=1; }

validate_one() {
  local f="$1"
  local base
  base=$(basename "$f")

  if ! grep -qE '^schema_version:' "$f"; then
    echo "USAGE_LOG: skip non-v1 file: ${base} (no schema_version)"
    return 0
  fi

  for key in schema_version template_id task_id rubric_instance started_at ended_at outcome rounds_used failed_rubric_ids; do
    grep -qE "^${key}:" "$f" || err "${base}: missing required field ${key}"
  done

  local outcome
  outcome=$(awk -F': ' '/^outcome:/ {print $2; exit}' "$f" | tr -d ' "')
  case "$outcome" in
    pass|fail|escalate) ;;
    *) err "${base}: invalid outcome '${outcome}'" ;;
  esac

  local tid
  tid=$(awk -F': ' '/^template_id:/ {print $2; exit}' "$f" | tr -d ' "')
  if [[ "$tid" != "generic-default" ]]; then
    grep -qE -e "- id: \"${tid}\"" "$REGISTRY" || err "${base}: unknown template_id '${tid}'"
  fi

  local rounds
  rounds=$(awk -F': ' '/^rounds_used:/ {print $2; exit}' "$f" | tr -d ' ')
  if [[ ! "$rounds" =~ ^[1-9][0-9]*$ ]] || [[ "$rounds" -gt 3 ]]; then
    err "${base}: rounds_used must be 1..3 (got ${rounds})"
  fi
}

if [[ $# -ge 1 ]]; then
  for f in "$@"; do
    [[ -f "$f" ]] || { err "not a file: $f"; continue; }
    validate_one "$f"
  done
else
  shopt -s nullglob
  files=("${LOG_DIR}"/*.yaml)
  if [[ ${#files[@]} -eq 0 ]]; then
    echo "usage logs OK (no yaml files to validate)"
    exit 0
  fi
  for f in "${files[@]}"; do
    validate_one "$f"
  done
fi

if [[ "$fail" -ne 0 ]]; then
  echo "usage log validation failed" >&2
  exit 1
fi

echo "usage logs OK"
