---
name: feature-delivery-chain
description: >-
  Runs a sequential delivery chain: clarify requirements, write plan, execute,
  then verify with evidence. Use when starting a multi-step feature from scratch,
  or when the user asks for end-to-end feature delivery with planning gates.
---

# Feature Delivery Chain

按序执行 **澄清 → 计划 → 实现 → 验证** 的 Prompt Chaining meta-skill。

> 模式文档：[docs/01-prompt-chaining.md](../../../docs/01-prompt-chaining.md)

## 开场白（必须）

「使用 feature-delivery-chain 执行交付链。」

## 硬性门禁

| 步骤 | 进入条件 | 未满足时 |
|------|---------|---------|
| Step 2 计划 | `findings.md` 或等价调研结论已存在 | 回到 Step 1 |
| Step 3 实现 | `plan.md` 已存在 | 回到 Step 2 |
| Step 3 实现 | 用户已确认 plan，或明确声明跳过确认 | 等待确认 |
| Step 4 验证 | 实现步骤已完成 | 继续 Step 3 |
| 宣称完成 | 已运行验证命令且有输出证据 | **禁止**宣称完成 |

## 链顺序

```text
Step 1  brainstorming          → findings.md
Step 2  writing-plans            → plan.md
Step 3  executing-plans          → 代码/配置变更 + progress 更新
Step 4  verification-before-completion → 证据门禁
```

各步细则见 [references/steps.md](references/steps.md)。

## 中间产物（必须落盘）

| 文件 | 用途 |
|------|------|
| `findings.md` | 需求澄清与调研结论 |
| `plan.md` | 可执行方案（任务列表、验收标准） |
| `progress.md` | 当前进度（可选，长任务推荐） |

长链**禁止**仅靠对话历史传递状态。

## 执行流程

1. 检查是否已有 `plan.md` / `findings.md`，决定从哪一步 resume
2. 创建 TodoWrite，每步一项
3. 逐步加载下游 Skill（若环境中已安装）：
   - `brainstorming`
   - `writing-plans`
   - `executing-plans`
   - `verification-before-completion`
4. 若下游 Skill 不可用，按 [references/steps.md](references/steps.md) 内联执行
5. 每步结束更新 `progress.md`，再进入下一步

## 输出格式

每步结束时在对话中输出：

```markdown
## 交付链进度
- 当前步骤：{N}/4 — {step_name}
- 产物：{file paths}
- 下一门禁：{condition}
```

## 禁止

- 跳过 plan.md 直接大规模改代码
- 未运行验证命令即说「已完成」「测试通过」
- 将多步合并为一步以节省 token（除非用户明确要求）
