---
industry: finance
scenario: risk-control
version: "1.0"
generated_at: "2025-05-18"
keywords: ["risk", "风控", "限额"]
---

# 金融风控系统 Rubric

> 合规要求：实时拦截、规则准确、不可旁路、可审计

## 评测项

| ID | 项 | Pass 条件 | 级别 | 合规要求 |
|----|-----|----------|------|---------|
| K1 | 拦截率 | 风险请求拦截率 ≥ {BLOCK_RATE}% | BLOCKER | 监管要求 |
| K2 | 误杀率 | 误拦截率 ≤ {FALSE_POSITIVE}% | BLOCKER | 用户体验 |
| K3 | 实时性 | 风控决策 P99 < {LATENCY}ms | BLOCKER | 实时拦截 |
| K4 | 规则准确 | 规则逻辑与策略文档一致 | BLOCKER | 策略一致性 |
| K5 | 不可旁路 | 无绕过风控的接口/后门 | BLOCKER | 安全红线 |
| K6 | 灰名单 | 灰名单机制有效 | normal | 渐进处置 |
| K7 | 审计 | 风控决策日志完整 | normal | 监管审计 |

## 占位符

- `{BLOCK_RATE}`: 如 99%
- `{FALSE_POSITIVE}`: 如 0.1%
- `{LATENCY}`: 如 100

## 合规检查

- [ ] 风控规则已法务/合规评审
- [ ] 黑名单/灰名单同步机制
- [ ] 风控决策不可人工覆盖（除非授权）
