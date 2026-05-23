#!/usr/bin/env bash
# 运行时脚本冒烟：实例化 → 门禁 → 写日志 → 校验日志
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIR="$(cd "$(dirname "$0")" && pwd)"
TASK="_smoke_$$"
INST="${ROOT}/references/rubric-instances/${TASK}-rubric.md"
cleanup() {
  rm -f "$INST"
  rm -f "${ROOT}/references/rubric-usage-logs/${TASK}"-*.yaml 2>/dev/null || true
  rm -f "${ROOT}/references/rubric-usage-logs/generic-bug-fix"-*_smoke*.yaml 2>/dev/null || true
}
trap cleanup EXIT

"$DIR/instantiate_rubric.sh" "$TASK" generic-bug-fix

# 填充占位符并确认
sed -i.bak \
  -e 's/confirm_status: pending/confirm_status: confirmed/' \
  -e 's/{TEST_CMD}/echo test_ok/g' \
  -e 's/{EVIDENCE_TYPE}/logs/g' \
  -e 's/{REGRESSION_SCOPE}/core/g' \
  "$INST"
rm -f "${INST}.bak"

"$DIR/check_round0_gate.sh" "$TASK"

LOG_OUT=$("$DIR/write_usage_log.sh" \
  --template-id generic-bug-fix \
  --task-id "$TASK" \
  --rubric-instance "references/rubric-instances/${TASK}-rubric.md" \
  --outcome pass \
  --rounds 1 \
  --failed-ids "")

LOG_FILE=$(echo "$LOG_OUT" | awk '/^Wrote /{print $2}')
[[ -f "$LOG_FILE" ]] || { echo "SMOKE: log file not created" >&2; exit 1; }

"$DIR/validate_usage_logs.sh" "$LOG_FILE"

echo "runtime smoke OK"
