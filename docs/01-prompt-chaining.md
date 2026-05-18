# Pattern 1：Prompt Chaining（提示链）

> [← 返回总览](../summary.md) · 适配度：⭐⭐⭐⭐⭐ · **Skill 主战场**

---

## 原理

上一步的输出作为下一步的输入，形成固定流水线。每一步有明确的产出物格式，下一步只消费上一步的结构化结果。

## 为何适合 Agent Skill

| 优势 | 说明 |
|------|------|
| 规程即 Skill 正文 | 分步指令 + 每步产出物格式天然契合 SKILL.md |
| 渐进披露 | 长链主 Skill 只链到 `references/step-N.md` |
| 可组合 | meta-skill 按序加载其他 Skill |
| 可版本化 | 链变更走 Git / SkillOps CI |

## 生态内范例

Superpowers 交付链：

```text
brainstorming
  → writing-plans
  → executing-plans
  → verification-before-completion
```

## 推荐实现形态

### 文档结构

```text
chaining/
└── delivery-chain/
    ├── SKILL.md              # meta-skill：链顺序与门禁
    └── references/
        ├── step-1-brainstorm.md
        ├── step-2-plan.md
        └── step-3-verify.md
```

### meta-skill 流程示例

```text
meta-skill: feature-delivery-chain
  Step 1: 加载 brainstorming
  Step 2: 加载 writing-plans（必须产出 plan.md）
  Step 3: 加载 executing-plans（每步验证）
  Step 4: 加载 verification-before-completion（禁止无证据宣称完成）
```

### SKILL.md 骨架要点

```markdown
---
name: feature-delivery-chain
description: >-
  按序执行需求澄清→计划→实现→验证的交付链。
  Use when starting a multi-step feature from scratch.
---

## 硬性门禁
- Step 2 开始前：必须存在 plan.md
- Step 3 开始前：用户已确认 plan（或明确跳过）
- Step 4：未运行验证命令不得宣称完成

## 链顺序
1. brainstorming → 产出 findings
2. writing-plans → 产出 plan.md
3. executing-plans → 按 plan 逐步实现
4. verification-before-completion → 证据门禁
```

## 中间产物（文件型状态）

长链会消耗 context，**必须用文件承载中间态**：

| 文件 | 用途 |
|------|------|
| `task_plan.md` | 计划与进度 |
| `findings.md` | 调研结论 |
| `plan.md` | 可执行方案 |
| `progress.md` | 会话恢复 |

参考：`planning-with-files` Skill。

## 局限与缓解

| 局限 | 缓解 |
|------|------|
| 无 DAG 硬边，模型可能跳步 | 每步写 BLOCKER；检查中间文件是否存在 |
| 长链 context 膨胀 | 渐进披露 + 文件型中间态 |
| 软遵从 | 配合 `verification-before-completion` 等硬门禁 Skill |

## 还需什么（除 Skill 外）

- **步骤门禁**：检查文件/状态再进入下一步
- **中间产物文件**：避免全靠对话历史传递

## 结论

**Prompt Chaining 是 Agent Skill 的最佳落地点，应优先用 Skill 实现。**

---

**相关文档**：[02 - Routing](./02-routing.md) · [05 - Evaluator-Optimizer](./05-evaluator-optimizer.md)
