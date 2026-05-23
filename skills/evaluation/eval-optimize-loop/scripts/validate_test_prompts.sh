#!/usr/bin/env bash
# test-prompts.json 中带 match 字段的用例 → 校验 L1 匹配
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROMPTS="${ROOT}/test-prompts.json"
MATCH_PY="${ROOT}/scripts/match_rubric_template.py"
TMP_DIR="${ROOT}/.tmp"

command -v python3 >/dev/null || { echo "python3 required" >&2; exit 1; }

# 清理临时文件（如果有）
cleanup() {
    if [[ -d "$TMP_DIR" ]]; then
        rm -rf "$TMP_DIR"
    fi
}
trap cleanup EXIT

python3 - "$PROMPTS" "$MATCH_PY" "$TMP_DIR" <<'PY'
import json, os, subprocess, sys, tempfile

prompts_path, match_py, tmp_dir = sys.argv[1], sys.argv[2], sys.argv[3]

# 创建临时目录（用于未来可能需要的临时文件）
if tmp_dir:
    os.makedirs(tmp_dir, exist_ok=True)

data = json.load(open(prompts_path, encoding="utf-8"))
errors = []
ran = 0
for item in data:
    m = item.get("match")
    if not m:
        continue
    ran += 1
    proc = subprocess.run(
        [sys.executable, match_py, item["prompt"]],
        capture_output=True,
        text=True,
    )
    if proc.returncode != 0:
        errors.append(f"id {item['id']}: match script failed: {proc.stderr}")
        continue
    out = {}
    for line in proc.stdout.splitlines():
        if ":" in line:
            k, v = line.split(":", 1)
            out[k.strip()] = v.strip()
    if out.get("action") != m.get("action"):
        errors.append(
            f"id {item['id']}: action expected {m['action']!r} got {out.get('action')!r}"
        )
    exp_tid = m.get("template_id", "")
    got_tid = out.get("template_id", "")
    if exp_tid != got_tid:
        errors.append(
            f"id {item['id']}: template_id expected {exp_tid!r} got {got_tid!r}"
        )

if ran == 0:
    print("test-prompts: no match cases (skip)")
    sys.exit(0)
if errors:
    print("TEST_PROMPTS:", file=sys.stderr)
    for e in errors:
        print(f"  {e}", file=sys.stderr)
    sys.exit(1)
print(f"test-prompts match OK ({ran} cases)")
PY
