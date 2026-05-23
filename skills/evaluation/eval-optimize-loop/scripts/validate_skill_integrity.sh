#!/usr/bin/env bash
# 校验 Skill 规程契约（防 P0：Critic 读错 rubric、Handoff 缺 Active Rubric）
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REF="${ROOT}/references"
fail=0

err() { echo "INTEGRITY: $*" >&2; fail=1; }

require_file() {
  [[ -f "${REF}/$1" ]] || err "missing required reference: $1"
}

require_file "rubric-resolution.md"
require_file "rubric-usage-log-schema.yaml"
require_file "rubric-usage-log-write.md"
require_file "critic-prompt-template.md"
require_file "generator-handoff.md"
require_file "blocker-conditions.md"
require_file "round-0-gate.md"
require_file "maintenance-checklist.md"
require_file "critic-subagent-matrix.md"
require_file "round-0-rubric-factory.md"
require_file "retrospective-evolution.md"

# Critic 必须使用实例路径占位符，不得回退为「只读 rubric.md」
if ! grep -q '{rubric_path}' "${REF}/critic-prompt-template.md"; then
  err "critic-prompt-template.md must contain {rubric_path}"
fi
if grep -qE 'Read 项目 rubric.*默认 references/rubric\.md' "${REF}/critic-prompt-template.md"; then
  err "critic-prompt-template.md must not instruct Critic to read rubric.md as primary source"
fi
if ! grep -q 'rubric-resolution' "${REF}/critic-prompt-template.md"; then
  err "critic-prompt-template.md must reference rubric-resolution.md"
fi

# Handoff 必须含 Active Rubric
if ! grep -q 'Active Rubric' "${REF}/generator-handoff.md"; then
  err "generator-handoff.md must define Active Rubric section"
fi
if ! grep -q 'rubric_path' "${REF}/generator-handoff.md"; then
  err "generator-handoff.md must include rubric_path field"
fi

# BLOCKER 规则不得写死 R1/R2/R5 为唯一依据
if grep -qE '默认 R1、R2、R5' "${REF}/blocker-conditions.md"; then
  err "blocker-conditions.md must not hardcode R1/R2/R5 as default BLOCKER set"
fi
if ! grep -q 'rubric-resolution' "${REF}/blocker-conditions.md"; then
  err "blocker-conditions.md must reference rubric-resolution.md"
fi
if ! grep -q 'write_usage_log' "${REF}/escalate-template.md"; then
  err "escalate-template.md must mention write_usage_log"
fi
if ! grep -q 'rubric-templates' "${REF}/rubric-resolution.md"; then
  err "rubric-resolution.md must forbid reading rubric-templates mother copies"
fi

# SKILL.md 必须引用解析与日志规程
if ! grep -q 'critic-subagent-matrix' "${REF}/critic-prompt-template.md"; then
  err "critic-prompt-template.md must reference critic-subagent-matrix.md"
fi

for needle in rubric-resolution.md rubric-usage-log-write.md round-0-rubric-factory.md critic-subagent-matrix.md; do
  if ! grep -q "$needle" "${ROOT}/SKILL.md"; then
    err "SKILL.md must reference $needle"
  fi
done

# SKILL.md 内 references/ 链接可达（不含 # 锚点）
while IFS= read -r rel; do
  [[ -z "$rel" ]] && continue
  target="${ROOT}/${rel}"
  if [[ ! -f "$target" ]]; then
    err "SKILL.md broken link: ${rel}"
  fi
done < <(grep -oE '\]\(references/[^)#]+\)' "${ROOT}/SKILL.md" | sed -E 's/^\]\(//;s/\)$//')

if [[ "$fail" -ne 0 ]]; then
  echo "skill integrity validation failed" >&2
  exit 1
fi

echo "skill integrity OK"
