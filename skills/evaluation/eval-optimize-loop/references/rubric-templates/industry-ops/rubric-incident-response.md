---
industry: ops
scenario: incident-response
version: "1.0"
generated_at: "2025-05-18"
keywords: ["incident", "outage", "alarm", "response"]
---

# 运维应急响应 Rubric

> 行业最佳实践：1分钟发现 → 5分钟止损 → 15分钟定位 → 30分钟恢复

## 评测项

| ID | 项 | Pass 条件 | 级别 | 行业最佳实践 |
|----|-----|----------|------|------------|
| O1 | 止损 | 告警确认后 {SLA_MINUTES} 分钟内止损 | BLOCKER | P0故障5分钟内止损 |
| O2 | 根因 | 根因分析有 {EVIDENCE_TYPE} 三证 | BLOCKER | 日志+链路+监控三证齐全 |
| O3 | 回滚 | 有明确回滚方案且验证通过 | BLOCKER | 蓝绿/金丝雀回滚 |
| O4 | 影响 | 影响范围已量化（用户数/金额/时长） | BLOCKER | 精确到分钟级 |
| O5 | 复盘 | 复盘文档含 5 Whys + 改进项 | normal | 24小时内输出 |
| O6 | 监控 | 新增/修复监控项，防止二次故障 | normal | 监控即代码 |
| O7 | 沟通 | 干系人已通知（IM/电话/邮件） | BLOCKER | SLA内升级机制 |
| O8 | 现场 | 故障现场已保留（日志/堆栈/快照） | BLOCKER | 先保留，再重启 |

## 占位符说明

- `{SLA_MINUTES}`: 5（P0）/ 15（P1）/ 60（P2）
- `{EVIDENCE_TYPE}`: 应用日志 + 链路追踪 + 监控指标

## 定制说明

- O7: 根据故障级别确定通知范围，P0需电话+IM+邮件
- O8: 严禁未保留现场直接重启服务
