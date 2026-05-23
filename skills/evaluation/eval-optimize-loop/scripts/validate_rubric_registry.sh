#!/usr/bin/env bash
# 校验 _registry.yaml 中每个 template.path 在 rubric-templates/ 下存在
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REGISTRY="${ROOT}/references/rubric-templates/_registry.yaml"
BASE="${ROOT}/references/rubric-templates"

if [[ ! -f "$REGISTRY" ]]; then
  echo "missing registry: $REGISTRY" >&2
  exit 1
fi

missing=0
while IFS= read -r path; do
  [[ -z "$path" ]] && continue
  full="${BASE}/${path}"
  if [[ ! -f "$full" ]]; then
    echo "MISSING: ${path} (expected ${full})" >&2
    missing=$((missing + 1))
  fi
done < <(awk -F'"' '/^[[:space:]]+path:/ {print $2}' "$REGISTRY")

if [[ "$missing" -gt 0 ]]; then
  echo "registry validation failed: ${missing} missing file(s)" >&2
  exit 1
fi

echo "registry OK: all template paths exist"
