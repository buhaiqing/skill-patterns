---
industry: quant
scenario: live-trading
version: "1.0"
generated_at: "2025-05-18"
keywords: ["live", "实盘", "trading"]
---

# 量化实盘交易 Rubric

> 行业规范：实盘与回测的差异管理、实时风控、异常处理

## 评测项

| ID | 项 | Pass 条件 | 级别 | 行业规范 |
|----|-----|----------|------|---------|
| L1 | 仿真验证 | 仿真环境运行 ≥ {SIMULATION_DAYS} 天 | BLOCKER | 仿真先行 |
| L2 | 差异分析 | 实盘 vs 回测差异 < {DIFF_THRESHOLD}% | BLOCKER | 差异可控 |
| L3 | 实时风控 | 单笔/日累计/回撤风控已配置 | BLOCKER | 多层风控 |
| L4 | 异常处理 | 价格跳变 > {JUMP_THRESHOLD}σ 自动暂停 | BLOCKER | 熔断机制 |
| L5 | 监控 | 实时 P&L、希腊字母、VaR 监控 | BLOCKER | 实时监控 |
| L6 | 滑点 | 实际滑点 vs 预估滑点 < {SLIPPAGE}% | normal | 成本控制 |
| L7 | 归因 | 实盘收益归因已配置 | normal | 收益来源 |

## 占位符

- `{SIMULATION_DAYS}`: 如 7
- `{DIFF_THRESHOLD}`: 如 10%
- `{JUMP_THRESHOLD}`: 如 3
- `{SLIPPAGE}`: 如 20%

## 检查清单

- [ ] 实盘 vs 回测参数一致性检查
- [ ] 交易时段/停牌处理
- [ ] 资金/持仓初始化正确
- [ ] 紧急停止按钮可用
