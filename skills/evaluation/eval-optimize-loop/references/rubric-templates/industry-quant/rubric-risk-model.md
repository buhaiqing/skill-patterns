---
industry: quant
scenario: risk-model
version: "1.0"
generated_at: "2025-05-18"
keywords: ["risk", "model", "VaR", "回撤", "风险模型"]
---

# 量化风险模型 Rubric

> 最佳实践：风险模型是生存的底线，必须稳健

## 评测项

| ID | 项 | Pass 条件 | 级别 | 最佳实践 |
|----|-----|----------|------|---------|
| M1 | 回测 | 历史回测通过 | BLOCKER | 历史验证 |
| M2 | 压力 | 极端场景压力测试通过 | BLOCKER | 尾部风险 |
| M3 | 参数 | 参数稳健，不敏感 | BLOCKER | 稳健性 |
| M4 | 监控 | 实时风险监控有效 | BLOCKER | 实时监控 |
| M5 | 预警 | 风险预警阈值合理 | normal | 预警机制 |
| M6 | 归因 | 风险归因清晰 | normal | 风险分解 |
| M7 | 文档 | 模型文档完整 | normal | 模型治理 |
| M8 | 复核 | 独立复核通过 | normal | 模型验证 |

## 风险指标

| 指标 | 说明 | 阈值 |
|------|------|------|
| VaR | 风险价值 | < {VAR_THRESHOLD}% |
| CVaR | 条件风险价值 | < {CVAR_THRESHOLD}% |
| 最大回撤 | 峰值到谷底 | < {MAX_DRAWDOWN}% |
| 波动率 | 收益率标准差 | < {VOLATILITY}% |

## 压力场景

- 2008 金融危机
- 2015 股灾
- 2020 疫情
- 2022 俄乌冲突

## 模型验证

- 样本外测试
- 滚动回测
- 参数敏感性
- 蒙特卡洛模拟

## 占位符

- `{VAR_THRESHOLD}`: 如 5%
- `{MAX_DRAWDOWN}`: 如 20%
