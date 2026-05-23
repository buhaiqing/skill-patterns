---
industry: generic
scenario: refactor
version: "1.0"
generated_at: "2025-05-18"
keywords: ["refactor", "重构", "优化"]
---

# 代码重构 Rubric

> 最佳实践：重构的前提是「行为不变」，目标是「质量提升」

## 评测项

| ID | 项 | Pass 条件 | 级别 | 最佳实践 |
|----|-----|----------|------|---------|
| R1 | 行为等价 | 重构前后功能一致，输出相同 | BLOCKER | 行为不变原则 |
| R2 | 测试 | 原有测试 0 failures，无测试被删 | BLOCKER | 测试是安全网 |
| R3 | 质量提升 | 代码复杂度下降或可读性提升 | BLOCKER | 重构必须有价值 |
| R4 | 范围 | diff 仅目标模块，无范围蔓延 | normal | 最小变更 |
| R5 | Lint | {LINT_CMD} 0 errors | normal | 清理技术债 |
| R6 | 性能 | 无性能退化（基准测试） | BLOCKER | 性能不劣化 |
| R7 | 文档 | 如涉及 API 变更已更新 | normal | 兼容性说明 |

## 定制说明

- R3: 需提供重构前后的复杂度对比（如圈复杂度）
- R6: 如明确是性能优化重构，需证明性能提升
