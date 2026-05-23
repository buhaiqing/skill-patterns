#!/usr/bin/env bash
# 确定性 Round 0：从注册表或默认 rubric 生成实例（防 Agent 抄错路径/漏 template_id）
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  instantiate_rubric.sh TASK_ID TEMPLATE_ID
  instantiate_rubric.sh TASK_ID --default

Examples:
  instantiate_rubric.sh T3 ops-incident-response
  instantiate_rubric.sh hotfix-1 generic-bug-fix
  instantiate_rubric.sh trivial --default

Writes: references/rubric-instances/{TASK_ID}-rubric.md
EOF
  exit 1
}

[[ $# -ge 2 ]] || usage

TASK_ID="$1"
TEMPLATE_ARG="$2"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REGISTRY="${ROOT}/references/rubric-templates/_registry.yaml"
INST_DIR="${ROOT}/references/rubric-instances"
OUT="${INST_DIR}/${TASK_ID}-rubric.md"

mkdir -p "$INST_DIR"

if [[ "$TEMPLATE_ARG" == "--default" ]]; then
  SRC="${ROOT}/references/rubric.md"
  TEMPLATE_ID="generic-default"
  TEMPLATE_VERSION="1.0"
  TEMPLATE_PATH="references/rubric.md"
else
  TEMPLATE_ID="$TEMPLATE_ARG"
  path=$(awk -v id="$TEMPLATE_ID" '
    $0 ~ "- id: \""id"\"" { grab=1 }
    grab && /^[[:space:]]+path:/ {
      gsub(/.*path:[[:space:]]*"/, "")
      gsub(/".*/, "")
      print
      exit
    }
  ' "$REGISTRY")
  ver=$(awk -v id="$TEMPLATE_ID" '
    $0 ~ "- id: \""id"\"" { grab=1 }
    grab && /^[[:space:]]+version:/ {
      gsub(/.*version:[[:space:]]*"/, "")
      gsub(/".*/, "")
      print
      exit
    }
  ' "$REGISTRY")
  [[ -n "$path" ]] || { echo "unknown template_id: ${TEMPLATE_ID}" >&2; exit 1; }
  SRC="${ROOT}/references/rubric-templates/${path}"
  TEMPLATE_VERSION="${ver:-1.0}"
  TEMPLATE_PATH="references/rubric-templates/${path}"
fi

[[ -f "$SRC" ]] || { echo "source rubric missing: $SRC" >&2; exit 1; }

TS="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

{
  echo "---"
  echo "task_id: ${TASK_ID}"
  echo "template_id: ${TEMPLATE_ID}"
  echo "template_version: ${TEMPLATE_VERSION}"
  echo "template_path: ${TEMPLATE_PATH}"
  echo "instantiated_at: ${TS}"
  echo "confirm_status: pending"
  echo "---"
  echo ""
  cat "$SRC"
} > "$OUT"

echo "Wrote ${OUT}"
echo "Next: fill placeholders, user confirm, then run check_round0_gate.sh ${TASK_ID}"
