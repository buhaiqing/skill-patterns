---
industry: ops
scenario: monitoring
version: "1.0"
generated_at: "2025-05-23"
keywords: ["monitoring", "metrics", "alert", "dashboard", "监控", "告警"]
---

# 监控与告警 Rubric

> 行业最佳实践：可观测性三件套（指标/日志/链路）；告警要可行动、可降噪。

## 评测项

| ID | 项 | Pass 条件 | 级别 | 行业最佳实践 |
|----|-----|----------|------|-------------|
| M1 | 指标覆盖 | 核心 SLI/SLO 已覆盖（{SLI_LIST}） | BLOCKER | 用户可感知路径优先 |
| M2 | 告警规则 | 规则有阈值、持续时间、严重级别 | BLOCKER | 避免瞬时毛刺误报 |
| M3 | 可行动性 | 告警含 Runbook 链接或处置步骤 | BLOCKER | 禁止「仅通知无指引」 |
| M4 | 降噪 | 有分组/抑制/依赖，避免告警风暴 | normal | on-call 友好 |
| M5 | 仪表盘 | Dashboard 可回答「现在是否正常」 | normal | 黄金信号四件套 |
| M6 | 日志 | 关键路径结构化日志可检索 | BLOCKER | 含 trace/request id |
| M7 | 验证 | 已在测试环境触发告警并收到通知 | BLOCKER | 告警也要测试 |
| M8 | 所有权 | 告警路由到明确 on-call/团队 | normal | 无孤儿告警 |

## 占位符说明

- `{SLI_LIST}`: 如可用性、P99 延迟、错误率、饱和度

## 定制说明

- M7: 可用 synthetic check 或手动 fire-drill 记录为证据
- M3: Runbook 可为 issue/wiki 链接，须在 handoff 列出
