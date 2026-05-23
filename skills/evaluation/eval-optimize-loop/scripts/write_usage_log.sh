#!/usr/bin/env bash
# 确定性写入使用日志（防复盘无数据）
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  write_usage_log.sh \
    --template-id ID \
    --task-id TASK_ID \
    --rubric-instance PATH \
    --outcome pass|fail|escalate \
    --rounds N \
    [--failed-ids id1,id2] \
    [--rating 1-5] \
    [--feedback TEXT] \
    [--critic-subagent TYPE] \
    [--project NAME] \
    [--no-bump-registry]

Writes: references/rubric-usage-logs/{template-id}-{timestamp}.yaml
默认将 _registry.yaml 中该模板的 usage_count +1（generic-default 除外）。
EOF
  exit 1
}

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LOG_DIR="${ROOT}/references/rubric-usage-logs"
mkdir -p "$LOG_DIR"

TEMPLATE_ID="" TASK_ID="" INSTANCE="" OUTCOME="" ROUNDS=""
FAILED_IDS="" RATING="" FEEDBACK="" CRITIC="" PROJECT=""
BUMP_REGISTRY=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    --template-id) TEMPLATE_ID="$2"; shift 2 ;;
    --task-id) TASK_ID="$2"; shift 2 ;;
    --rubric-instance) INSTANCE="$2"; shift 2 ;;
    --outcome) OUTCOME="$2"; shift 2 ;;
    --rounds) ROUNDS="$2"; shift 2 ;;
    --failed-ids) FAILED_IDS="$2"; shift 2 ;;
    --rating) RATING="$2"; shift 2 ;;
    --feedback) FEEDBACK="$2"; shift 2 ;;
    --critic-subagent) CRITIC="$2"; shift 2 ;;
    --project) PROJECT="$2"; shift 2 ;;
    --no-bump-registry) BUMP_REGISTRY=0; shift ;;
    -h|--help) usage ;;
    *) echo "unknown arg: $1" >&2; usage ;;
  esac
done

[[ -n "$TEMPLATE_ID" && -n "$TASK_ID" && -n "$INSTANCE" && -n "$OUTCOME" && -n "$ROUNDS" ]] || usage

case "$OUTCOME" in
  pass|fail|escalate) ;;
  *) echo "invalid --outcome: $OUTCOME" >&2; exit 1 ;;
esac

TS="$(date -u +"%Y%m%d-%H%M%S")"
OUT="${LOG_DIR}/${TEMPLATE_ID}-${TS}.yaml"
STARTED="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

# failed_rubric_ids as YAML list
if [[ -z "$FAILED_IDS" ]]; then
  FAILED_YAML="[]"
else
  FAILED_YAML="[$(echo "$FAILED_IDS" | tr ',' '\n' | sed 's/^/"/;s/$/"/' | paste -sd, -)]"
fi

{
  echo "schema_version: \"1.0\""
  echo "template_id: ${TEMPLATE_ID}"
  echo "task_id: ${TASK_ID}"
  echo "rubric_instance: ${INSTANCE}"
  echo "started_at: ${STARTED}"
  echo "ended_at: ${STARTED}"
  echo "outcome: ${OUTCOME}"
  echo "rounds_used: ${ROUNDS}"
  echo "failed_rubric_ids: ${FAILED_YAML}"
  [[ -n "$RATING" ]] && echo "user_rating: ${RATING}"
  [[ -n "$FEEDBACK" ]] && echo "user_feedback: \"${FEEDBACK}\""
  [[ -n "$CRITIC" ]] && echo "critic_subagent: ${CRITIC}"
  [[ -n "$PROJECT" ]] && echo "project: ${PROJECT}"
} > "$OUT"

echo "Wrote ${OUT}"

# 写入后立即校验
"$(cd "$(dirname "$0")" && pwd)/validate_usage_logs.sh" "$OUT"

if [[ "$BUMP_REGISTRY" -eq 1 ]]; then
  python3 "$(cd "$(dirname "$0")" && pwd)/bump_registry_usage.py" "$TEMPLATE_ID" || true
fi
