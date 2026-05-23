#!/usr/bin/env bash
# 注册表一致性：唯一 id、无孤儿模板、每项含 keywords
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REGISTRY="${ROOT}/references/rubric-templates/_registry.yaml"
BASE="${ROOT}/references/rubric-templates"
fail=0

err() { echo "REGISTRY: $*" >&2; fail=1; }

ids=$(awk -F'"' '/^[[:space:]]+- id:/ {print $2}' "$REGISTRY" | sort)
dup=$(echo "$ids" | uniq -d)
if [[ -n "$dup" ]]; then
  err "duplicate template ids: $(echo "$dup" | tr '\n' ' ')"
fi

reg_list="$(mktemp)"
file_list="$(mktemp)"
trap 'rm -f "$reg_list" "$file_list"' EXIT

awk -F'"' '/^[[:space:]]+path:/ {print $2}' "$REGISTRY" | sort -u > "$reg_list"
find "$BASE" -name 'rubric-*.md' -type f | sed "s|^${BASE}/||" | sort -u > "$file_list"

while IFS= read -r rel; do
  [[ -z "$rel" ]] && continue
  if ! grep -qxF "$rel" "$reg_list"; then
    err "orphan template not in _registry.yaml: ${rel}"
  fi
done < "$file_list"

while IFS= read -r tid; do
  [[ -z "$tid" ]] && continue
  if ! grep -A 12 -e "- id: \"${tid}\"" "$REGISTRY" | grep -q 'keywords:'; then
    err "template '${tid}' missing keywords in registry"
  fi
done <<< "$ids"

if [[ "$fail" -ne 0 ]]; then
  echo "registry consistency validation failed" >&2
  exit 1
fi

echo "registry consistency OK"
