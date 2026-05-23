#!/usr/bin/env bash
# 注册表元数据：stats 计数、registry 与模板 frontmatter 的 industry/scenario 一致
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REGISTRY="${ROOT}/references/rubric-templates/_registry.yaml"
BASE="${ROOT}/references/rubric-templates"

command -v python3 >/dev/null || { echo "python3 required" >&2; exit 1; }

python3 - "$REGISTRY" "$BASE" <<'PY'
import re, sys, pathlib

registry_path, base = sys.argv[1], pathlib.Path(sys.argv[2])
text = open(registry_path, encoding="utf-8").read()
entries = []
for block in re.split(r"\n  - id:", text)[1:]:
    m_id = re.search(r'"([^"]+)"', block)
    m_path = re.search(r'path:\s*"([^"]+)"', block)
    m_ind = re.search(r'industry:\s*"([^"]+)"', block)
    m_scen = re.search(r'scenario:\s*"([^"]+)"', block)
    if m_id and m_path:
        entries.append((m_id.group(1), m_path.group(1), m_ind.group(1) if m_ind else "", m_scen.group(1) if m_scen else ""))

count = len(entries)
m_total = re.search(r"total_templates:\s*(\d+)", text)
m_active = re.search(r"active_templates:\s*(\d+)", text)
declared = int(m_total.group(1)) if m_total else -1
active = int(m_active.group(1)) if m_active else -1

errors = []
if count != declared:
    errors.append(f"stats.total_templates={declared} but found {count} template ids")
if count != active:
    errors.append(f"stats.active_templates={active} should equal template count {count}")

for tid, path, reg_ind, reg_scen in entries:
    f = base / path
    if not f.is_file():
        continue
    head = "\n".join(f.read_text(encoding="utf-8").splitlines()[:25])
    mfi = re.search(r"^industry:\s*(\S+)", head, re.M)
    mfs = re.search(r"^scenario:\s*(\S+)", head, re.M)
    file_ind = mfi.group(1) if mfi else ""
    file_scen = mfs.group(1) if mfs else ""
    if reg_ind and reg_ind != file_ind:
        errors.append(f"{tid}: registry industry={reg_ind} != file industry={file_ind}")
    if reg_scen and reg_scen != file_scen:
        errors.append(f"{tid}: registry scenario={reg_scen} != file scenario={file_scen}")

if errors:
    print("METADATA:", file=sys.stderr)
    for e in errors:
        print(f"METADATA: {e}", file=sys.stderr)
    sys.exit(1)

print(f"registry metadata OK ({count} templates)")
PY
