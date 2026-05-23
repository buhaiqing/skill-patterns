# Eval-Optimize — 默认 Rubric（fallback 母版）

> **Critic 不直接读本文件**。Round 0 须复制为 `rubric-instances/{task-id}-rubric.md`（或走快捷路径），Critic 只评 **实例**。见 [rubric-resolution.md](./rubric-resolution.md)。
>
> **定制**：按项目增删行。由 **Critic subagent** 填写评测表，Generator 不得最终裁定。

## 评测项

| ID | 项 | Pass 条件 | 级别 | Critic 证据要求 |
|----|-----|----------|------|----------------|
| R1 | 测试 | 约定测试命令 0 failures | BLOCKER | 命令 + exit code + 失败用例定位 |
| R2 | 规格 | 与 plan.md / issue 逐条对齐 | BLOCKER | 逐条引用 spec 章节 |
| R3 | Lint | linter 0 errors（项目约定命令） | normal | lint 命令输出 |
| R4 | 范围 | diff 仅含任务相关文件 | normal | 越界文件路径列表 |
| R5 | 安全 | 无硬编码密钥、无危险 API 误用 | BLOCKER | 文件:行 或 BLOCKER 见 blocker-conditions |
| R6 | 文档 | 公共 API 变更已更新文档（若适用） | normal | 文档路径或 N/A |

## Critic 评测规则

1. 先评 BLOCKER — 任一 fail → **本轮未通过**（Generator 不可宣布 pass）
2. normal fail → 写入 critic-feedback-format，Generator 下轮仅修这些 ID
3. 证据列不可为空；缺 handoff 验证输出 → 依赖命令的项标 fail
4. Generator 自检仅供参考，**不得**作为 pass 依据

## 项目验证命令（占位）

```text
测试：{TEST_CMD}
Lint：{LINT_CMD}
构建：{BUILD_CMD}
```
