---
industry: generic
scenario: feature
version: "1.0"
generated_at: "2025-05-18"
keywords: ["feature", "开发", "新功能"]
---

# 新功能开发 Rubric

> 最佳实践：功能交付 = 实现 + 测试 + 文档 + 可观测

## 评测项

| ID | 项 | Pass 条件 | 级别 | 最佳实践 |
|----|-----|----------|------|---------|
| N1 | 规格 | 与需求文档逐条对齐 | BLOCKER | PRD 可追踪 |
| N2 | 测试 | {TEST_CMD} 0 failures，覆盖率 ≥ {COVERAGE}% | BLOCKER | TDD 或后补测试 |
| N3 | 文档 | 公共 API/接口已更新文档 | normal | 文档即代码 |
| N4 | Lint | {LINT_CMD} 0 errors | normal | 代码规范 |
| N5 | 可观测 | 日志/监控/告警已配置 | normal | 可观测性三要素 |
| N6 | 安全 | 无硬编码密钥，输入已校验 | BLOCKER | 安全左移 |
| N7 | 回滚 | 有明确回滚方案 | normal | 发布必备 |
| N8 | 性能 | 性能基准测试通过 | normal | 无性能退化 |

## 占位符

- `{COVERAGE}`: 项目要求，如 80%
- `{PERFORMANCE_THRESHOLD}`: 性能阈值，如 P99 < 100ms

## 定制说明

- N3: 仅公共接口强制，内部实现可选
- N8: 如涉及性能敏感场景，升级为 BLOCKER
