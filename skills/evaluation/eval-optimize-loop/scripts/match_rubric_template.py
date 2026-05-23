#!/usr/bin/env python3
"""L1 确定性 Rubric 模板匹配（registry keywords + 行业/场景/语言 hint）。"""
from __future__ import annotations

import re
import sys
from pathlib import Path

REGISTRY_NAME = "_registry.yaml"
THRESHOLD_DIRECT = 0.8
THRESHOLD_CONFIRM = 0.5
BOOST_HITS = 2

# 与 rubric-selector.md 对齐
INDUSTRY_HINTS: dict[str, list[str]] = {
    "ops": ["故障", "告警", "部署", "配置", "监控", "线上", "运维", "p0", "p1", "incident", "outage"],
    "finance": ["交易", "资金", "风控", "清算", "对账", "监管", "finance", "settlement"],
    "quant": ["策略", "回测", "因子", "实盘", "夏普", "var", "quant", "backtest"],
    "generic": ["bug", "feature", "refactor", "修复", "缺陷", "功能", "重构"],
    "software-dev": [
        "api", "前端", "数据库", "代码审查", "pr", "fastapi", "flask", "django",
        "golang", "gin", "echo", "typescript", "nestjs", "express", "rust", "tokio",
    ],
}

SCENARIO_HINTS: dict[tuple[str, str], list[str]] = {
    ("ops", "incident-response"): ["故障", "告警", "响应", "p0", "p1", "止损", "应急"],
    ("ops", "config-change"): ["配置", "参数", "变更"],
    ("ops", "deployment"): ["部署", "上线", "发布", "rollout", "deploy"],
    ("ops", "monitoring"): ["监控", "告警", "metrics", "dashboard"],
    ("finance", "trade-system"): ["交易", "撮合", "订单"],
    ("finance", "risk-control"): ["风控", "限额", "拦截"],
    ("finance", "settlement"): ["清算", "对账", "结算"],
    ("finance", "reporting"): ["报表", "监管", "报送"],
    ("quant", "strategy-backtest"): ["回测", "策略", "因子"],
    ("quant", "live-trading"): ["实盘", "成交", "滑点"],
    ("quant", "data-pipeline"): ["数据", "行情", "清洗", "pipeline"],
    ("quant", "risk-model"): ["var", "回撤", "风险模型"],
    ("generic", "bug-fix"): ["bug", "修复", "缺陷", "fix", "hotfix"],
    ("generic", "feature"): ["功能", "特性", "feature", "新增"],
    ("generic", "refactor"): ["重构", "refactor", "清理"],
    ("software-dev", "code-review"): ["code-review", "审查", "pr", "pull-request"],
    ("software-dev", "api-design"): ["api", "接口", "rest", "设计"],
    ("software-dev", "database-migration"): ["migration", "数据库", "ddl", "迁移"],
    ("software-dev", "frontend-component"): ["前端", "component", "ui", "组件"],
    ("software-dev", "python-service"): ["python", "fastapi", "flask", "django", "pytest"],
    ("software-dev", "go-service"): ["golang", "go ", " gin", "echo"],
    ("software-dev", "ts-service"): ["typescript", "nodejs", "nestjs", "express"],
    ("software-dev", "rust-service"): ["rust", "tokio", "axum", "actix"],
}

# registry scenario -> template id suffix
SCENARIO_TO_TEMPLATE_SUFFIX: dict[tuple[str, str], str] = {
    ("ops", "incident-response"): "ops-incident-response",
    ("ops", "config-change"): "ops-config-change",
    ("ops", "deployment"): "ops-deployment",
    ("ops", "monitoring"): "ops-monitoring",
    ("generic", "bug-fix"): "generic-bug-fix",
    ("generic", "feature"): "generic-feature",
    ("generic", "refactor"): "generic-refactor",
    ("software-dev", "python-service"): "python-service",
    ("software-dev", "go-service"): "go-service",
    ("software-dev", "ts-service"): "ts-service",
    ("software-dev", "rust-service"): "rust-service",
}


def load_templates(registry_path: Path) -> list[dict]:
    text = registry_path.read_text(encoding="utf-8")
    templates = []
    for block in re.split(r"\n  - id:", text)[1:]:
        m_id = re.search(r'"([^"]+)"', block)
        m_path = re.search(r'path:\s*"([^"]+)"', block)
        m_ind = re.search(r'industry:\s*"([^"]+)"', block)
        m_scen = re.search(r'scenario:\s*"([^"]+)"', block)
        kw_block = block.split("keywords:", 1)[-1].split("version:")[0] if "keywords:" in block else ""
        keywords = re.findall(r'"([^"]+)"', kw_block) if kw_block else []
        if m_id and m_path:
            templates.append(
                {
                    "id": m_id.group(1),
                    "path": m_path.group(1),
                    "industry": m_ind.group(1) if m_ind else "",
                    "scenario": m_scen.group(1) if m_scen else "",
                    "keywords": [k for k in keywords if k and len(k) > 1],
                }
            )
    return templates


def hint_boost(query: str, industry: str, scenario: str) -> float:
    q = query.lower()
    boost = 0.0
    for kw in INDUSTRY_HINTS.get(industry, []):
        if kw.lower() in q:
            boost += 0.08
            break
    for (ind, scen), kws in SCENARIO_HINTS.items():
        if ind == industry and scen == scenario:
            if any(kw.lower() in q for kw in kws):
                boost += 0.2
            break
    return min(boost, 0.35)


def scenario_hint_hit_count(query: str, industry: str, scenario: str) -> int:
    q = query.lower()
    kws = SCENARIO_HINTS.get((industry, scenario), [])
    return sum(1 for kw in kws if kw.lower() in q)


def score_template(query: str, template: dict) -> tuple[float, int]:
    keywords = template["keywords"]
    ind, scen = template["industry"], template["scenario"]
    if not keywords:
        base, hits = 0.0, 0
    else:
        q = query.lower()
        hits = sum(1 for kw in keywords if kw.lower() in q)
        base = hits / len(keywords)
        if hits >= BOOST_HITS:
            base = max(base, 0.85)
    if scenario_hint_hit_count(query, ind, scen) >= 1:
        base = max(base, 0.85)
    boosted = min(1.0, base + hint_boost(query, ind, scen))
    return boosted, hits


BUG_SIGNALS = ["bug", "修复", "缺陷", "hotfix", "fix"]
NOVEL_DOMAIN_SIGNALS = ["区块链", "医疗", "healthcare", "blockchain", "跨链"]


def adjust_ranking(query: str, ranked: list[tuple[float, int, dict]]) -> list[tuple[float, int, dict]]:
    q = query.lower()
    out = list(ranked)
    if any(s in q for s in BUG_SIGNALS):
        adjusted = []
        for s, h, t in out:
            if t["id"] == "generic-bug-fix":
                s = max(s, 0.9)
            elif t["industry"] in ("finance", "quant") and h <= 1:
                s = s * 0.4
            adjusted.append((s, h, t))
        out = adjusted
    if any(s in q for s in NOVEL_DOMAIN_SIGNALS):
        adjusted = []
        for s, h, t in out:
            if h < 2:
                s = min(s, 0.45)
            adjusted.append((s, h, t))
        out = adjusted
    out.sort(key=lambda x: (-x[0], -x[1], x[2]["id"]))
    return out


def action_for(score: float) -> str:
    if score >= THRESHOLD_DIRECT:
        return "direct"
    if score >= THRESHOLD_CONFIRM:
        return "confirm"
    return "generate"


def emit_result(
    act: str,
    best: dict | None,
    score: float,
    hits: int,
    ranked: list[tuple[float, int, dict]],
) -> None:
    print(f"action: {act}")
    if act == "generate":
        print("template_id: ")
        if best and score > 0:
            print(f"suggestion: {best['id']}")
            print("suggestion_only: true")
        if score == 0:
            print("message: 无关键词命中，建议动态生成或用户选择")
    else:
        assert best is not None
        print(f"template_id: {best['id']}")
    print(f"score: {score:.2f}")
    print(f"hits: {hits}")
    if best:
        print(f"industry: {best['industry']}")
        print(f"scenario: {best['scenario']}")
        print(f"path: {best['path']}")
    if act == "confirm" and ranked:
        print("alternatives:")
        for s, h, t in ranked[1:4]:
            if s >= THRESHOLD_CONFIRM:
                print(f"  - {t['id']}: score={s:.2f} hits={h}")


def main() -> int:
    if len(sys.argv) < 2:
        print("Usage: match_rubric_template.py \"用户任务描述\"", file=sys.stderr)
        return 1

    query = " ".join(sys.argv[1:])
    root = Path(__file__).resolve().parent.parent
    registry = root / "references" / "rubric-templates" / REGISTRY_NAME
    if not registry.is_file():
        print(f"missing registry: {registry}", file=sys.stderr)
        return 1

    ranked: list[tuple[float, int, dict]] = []
    for t in load_templates(registry):
        s, hits = score_template(query, t)
        ranked.append((s, hits, t))

    ranked.sort(key=lambda x: (-x[0], -x[1], x[2]["id"]))
    ranked = adjust_ranking(query, ranked)
    if not ranked or ranked[0][0] == 0:
        emit_result("generate", None, 0.0, 0, ranked)
        return 0

    best_score, best_hits, best = ranked[0]
    act = action_for(best_score)
    emit_result(act, best, best_score, best_hits, ranked)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
