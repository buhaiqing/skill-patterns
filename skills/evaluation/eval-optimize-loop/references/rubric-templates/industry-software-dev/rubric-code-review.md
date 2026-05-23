---
industry: software-dev
scenario: code-review
version: "1.0"
generated_at: "2025-05-18"
keywords: ["code-review", "代码审查", "PR", "pull-request"]
---

# 代码审查 Rubric

> 最佳实践：代码审查是质量的守门员，不是挑刺

## 评测项

| ID | 项 | Pass 条件 | 级别 | 最佳实践 |
|----|-----|----------|------|---------|
| S1 | 功能 | 功能实现正确，与需求对齐 | BLOCKER | 审查首要目标 |
| S2 | 测试 | 新增测试覆盖率 ≥ {COVERAGE}% | BLOCKER | 测试即文档 |
| S3 | 规范 | {LINT_CMD} 0 errors | normal | Clean Code |
| S4 | 可读性 | 命名清晰，注释必要，结构合理 | normal | 可读性 >  clever |
| S5 | 安全 | 无注入风险，无硬编码密钥 | BLOCKER | 安全红线 |
| S6 | 性能 | 无明显性能问题 | normal | 避免 N+1 查询等 |
| S7 | 范围 | 单一职责，不混合无关变更 | normal | 一个 PR 一件事 |
| S8 | 文档 | 公共 API 已更新文档 | normal | 文档同步 |

## 审查标准

| 结论 | 条件 |
|------|------|
| Approve | 无 BLOCKER，normal ≤ 2 个 fail |
| Comment | 无 BLOCKER，normal 3-5 个 fail |
| Request Changes | 有 BLOCKER 或 > 5 个 normal fail |

## 占位符

- `{COVERAGE}`: 项目要求，如 80%
- `{LINT_CMD}`: 代码检查命令

## 审查原则

- 对事不对人
- 解释「为什么」，不只是「是什么」
- 小 PR 优先（< 400 行）
- 24 小时内响应
