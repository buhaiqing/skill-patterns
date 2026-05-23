#!/usr/bin/env bash
# 校验 rubric 模板结构（评测项表、BLOCKER、frontmatter）
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BASE="${ROOT}/references/rubric-templates"
fail=0

err() { echo "TEMPLATE: $*" >&2; fail=1; }

while IFS= read -r file; do
  rel="${file#${BASE}/}"

  if ! grep -q '^## 评测项' "$file"; then
    err "${rel}: missing '## 评测项' section"
    continue
  fi

  if ! grep -qE '\| BLOCKER \|' "$file"; then
    err "${rel}: no BLOCKER row in rubric table"
  fi

  # 表内 ID 列：| X1 | 形式（字母+数字）
  ids=$(awk -F'|' '/^\| [A-Za-z][A-Za-z0-9]*[0-9]+ \|/ {gsub(/ /,"",$2); print $2}' "$file" | sort)
  if [[ -z "$ids" ]]; then
    err "${rel}: no rubric IDs found in table (expected | B1 | style)"
    continue
  fi
  dup=$(echo "$ids" | uniq -d)
  if [[ -n "$dup" ]]; then
    err "${rel}: duplicate rubric IDs: ${dup}"
  fi

  # 每项须有 BLOCKER 或 normal 级别
  bad_levels=$(awk -F'|' '
    /^\| [A-Za-z][A-Za-z0-9]*[0-9]+ \|/ {
      gsub(/ /, "", $5)
      if ($5 != "BLOCKER" && $5 != "normal") print $2
    }
  ' "$file")
  if [[ -n "$bad_levels" ]]; then
    err "${rel}: rubric rows with invalid 级别 (must be BLOCKER or normal)"
  fi

  blocker_count=$(grep -cE '^\| [A-Za-z][A-Za-z0-9]*[0-9]+ \|.*\| BLOCKER \|' "$file" || true)
  if [[ "$blocker_count" -lt 2 ]]; then
    err "${rel}: need at least 2 BLOCKER rows (found ${blocker_count})"
  fi

  for key in industry scenario; do
    if ! head -25 "$file" | grep -qE "^${key}:"; then
      err "${rel}: missing frontmatter field '${key}'"
    fi
  done
done < <(find "$BASE" -name 'rubric-*.md' -type f | sort)

if [[ "$fail" -ne 0 ]]; then
  echo "rubric template validation failed" >&2
  exit 1
fi

echo "rubric templates OK"
