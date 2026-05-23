---
industry: ops
scenario: deployment
version: "1.0"
generated_at: "2025-05-23"
keywords: ["deploy", "release", "rollout", "上线", "发布"]
---

# 部署上线 Rubric

> 行业最佳实践：可回滚、可观测、可灰度；禁止「直接全量赌一把」。

## 评测项

| ID | 项 | Pass 条件 | 级别 | 行业最佳实践 |
|----|-----|----------|------|-------------|
| D1 | 变更评审 | 发布内容已评审（含回滚方案） | BLOCKER | 变更即风险 |
| D2 | 灰度/金丝雀 | 已在灰度或金丝雀环境验证 | BLOCKER | 先小流量再全量 |
| D3 | 回滚 | 回滚步骤明确且演练/验证过 | BLOCKER | 5 分钟内可回滚 |
| D4 | 健康检查 | 发布后 {HEALTH_CHECK} 通过 | BLOCKER | 就绪探针 + 业务探针 |
| D5 | 监控 | 核心指标无异常（错误率/延迟/饱和度） | BLOCKER | 发布窗口盯盘 |
| D6 | 版本追溯 | 镜像/包版本与 Git 提交可对应 | normal | 可追溯 |
| D7 | 文档 | Runbook/发布说明已更新（若适用） | normal | 值班可执行 |
| D8 | 沟通 | 干系人已通知发布窗口与影响 | normal | 避免静默上线 |

## 占位符说明

- `{HEALTH_CHECK}`: 如 `kubectl rollout status`、HTTP `/health`、冒烟用例集

## 定制说明

- D2: 无法灰度时须在 handoff 说明理由 + 额外监控项
- D3: 「手动回滚」不可接受，须有可执行命令或自动化流水线
