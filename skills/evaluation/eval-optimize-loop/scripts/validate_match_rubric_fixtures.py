#!/usr/bin/env python3
"""校验 match_rubric_template.py 与 fixtures 期望一致。"""
from __future__ import annotations

import re
import subprocess
import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    yaml = None  # type: ignore


def load_cases(fixtures_path: Path) -> list[dict]:
    text = fixtures_path.read_text(encoding="utf-8")
    if yaml:
        data = yaml.safe_load(text)
        return data.get("cases", [])
    # minimal parser
    cases = []
    current: dict = {}
    for line in text.splitlines():
        line = line.strip()
        if line.startswith("- query:"):
            if current:
                cases.append(current)
            current = {"query": line.split(":", 1)[1].strip().strip('"')}
        elif line.startswith("action:"):
            current["action"] = line.split(":", 1)[1].strip()
        elif line.startswith("template_id:"):
            val = line.split(":", 1)[1].strip().strip('"')
            current["template_id"] = val
    if current:
        cases.append(current)
    return cases


def run_match(script: Path, query: str) -> dict[str, str]:
    proc = subprocess.run(
        [sys.executable, str(script), query],
        capture_output=True,
        text=True,
        check=False,
    )
    if proc.returncode != 0:
        raise RuntimeError(proc.stderr or proc.stdout)
    out: dict[str, str] = {}
    for line in proc.stdout.splitlines():
        if ":" not in line:
            continue
        key, val = line.split(":", 1)
        out[key.strip()] = val.strip()
    return out


def main() -> int:
    root = Path(__file__).resolve().parent.parent
    script = Path(__file__).resolve().parent / "match_rubric_template.py"
    fixtures = root / "references" / "fixtures" / "match_rubric_expectations.yaml"
    if not fixtures.is_file():
        print(f"MISSING: {fixtures}", file=sys.stderr)
        return 1

    errors = []
    for i, case in enumerate(load_cases(fixtures), 1):
        query = case["query"]
        exp_action = case["action"]
        exp_tid = case.get("template_id", "")
        got = run_match(script, query)
        if got.get("action") != exp_action:
            errors.append(f"case {i}: action want {exp_action} got {got.get('action')!r} query={query!r}")
        got_tid = got.get("template_id", "")
        if exp_tid != got_tid:
            errors.append(
                f"case {i}: template_id want {exp_tid!r} got {got_tid!r} query={query!r}"
            )

    if errors:
        print("MATCH_FIXTURES:", file=sys.stderr)
        for e in errors:
            print(f"  {e}", file=sys.stderr)
        return 1

    print(f"match rubric fixtures OK ({len(load_cases(fixtures))} cases)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
