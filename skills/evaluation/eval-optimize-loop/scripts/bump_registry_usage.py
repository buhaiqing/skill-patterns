#!/usr/bin/env python3
"""将 _registry.yaml 中指定 template 的 usage_count +1。"""
from __future__ import annotations

import re
import sys
from pathlib import Path


def bump(registry_path: Path, template_id: str) -> bool:
    if template_id in ("", "generic-default"):
        return False
    text = registry_path.read_text(encoding="utf-8")
    # Use re.DOTALL instead of [\s\S]*? for better performance
    pattern = re.compile(
        rf'(- id: "{re.escape(template_id)}".*?usage_count: )(\d+)',
        re.MULTILINE | re.DOTALL,
    )
    m = pattern.search(text)
    if not m:
        print(f"bump: template_id not found: {template_id}", file=sys.stderr)
        return False
    new_count = int(m.group(2)) + 1
    new_text = pattern.sub(rf"\g<1>{new_count}", text, count=1)
    registry_path.write_text(new_text, encoding="utf-8")
    print(f"bump: {template_id} usage_count -> {new_count}")
    return True


def main() -> int:
    if len(sys.argv) != 2:
        print("Usage: bump_registry_usage.py TEMPLATE_ID", file=sys.stderr)
        return 1
    root = Path(__file__).resolve().parent.parent
    registry = root / "references" / "rubric-templates" / "_registry.yaml"
    return 0 if bump(registry, sys.argv[1]) else 1


if __name__ == "__main__":
    raise SystemExit(main())
