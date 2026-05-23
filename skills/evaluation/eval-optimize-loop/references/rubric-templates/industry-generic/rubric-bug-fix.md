---
industry: generic
scenario: bug-fix
version: "1.0"
generated_at: "2025-05-18"
keywords: ["bug", "fix", "defect", "patch"]
---

# Bug 修复质量标准

> 行业最佳实践：修复 Bug 的核心是「止损 → 根因 → 回归」，避免修复引入新问题。

## 评测项

| ID | 项 | Pass 条件 | 级别 | 行业最佳实践 |
|----|-----|----------|------|-------------|
| B1 | 止损 | 已采取临时措施控制影响 | BLOCKER | 先止损，再修复 |
| B2 | 根因 | 根因分析有 {EVIDENCE_TYPE} 证据支撑 | BLOCKER | 5 Whys 或鱼骨图 |
| B3 | 测试 | {TEST_CMD} 0 failures，含回归测试 | BLOCKER | 修复必带测试 |
| B4 | 范围 | diff 仅含相关文件，无「顺便重构」 | normal | 最小变更原则 |
| B5 | 安全 | 无硬编码密钥，无危险 API 误用 | BLOCKER | 安全红线 |
| B6 | 回归 | {REGRESSION_SCOPE} 验证通过 | BLOCKER | 历史数据/场景验证 |
| B7 | 复盘 | 复盘文档含改进项（P0/P1 必须） | normal | 24h 内输出 |

## 占位符说明

- `{TEST_CMD}`: 项目测试命令，如 `pytest tests/bug123_test.py -v`
- `{EVIDENCE_TYPE}`: 日志/监控/复现步骤/代码分析
- `{REGRESSION_SCOPE}`: 受影响功能范围，如「订单模块核心流程」

## 定制说明

- B7: P2 及以下 Bug 可选，P0/P1 强制
- B6: 如涉及数据变更，必须验证历史数据一致性
