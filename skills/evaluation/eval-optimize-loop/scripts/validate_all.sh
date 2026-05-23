#!/usr/bin/env bash
# eval-optimize-loop 全量校验（CI / 提交前运行）
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$DIR/.." && pwd)"

run() {
  echo "==> $1"
  "$DIR/$1"
}

run validate_rubric_registry.sh
run validate_registry_consistency.sh
run validate_registry_metadata.sh
run validate_rubric_templates.sh
run validate_rubric_default.sh
run validate_skill_integrity.sh
run validate_match_rubric_fixtures.py
run validate_test_prompts.sh
run validate_usage_logs.sh
echo "==> validate_usage_logs.sh (fixture)"
"$DIR/validate_usage_logs.sh" "${ROOT}/references/fixtures/example-usage-log.v1.yaml"
run validate_runtime_smoke.sh

echo "==> all validations passed"
