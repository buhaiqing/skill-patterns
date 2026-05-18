# Skills Matrix — 任务类型 → Skill 链

> **定制**：将下游 Skill 名替换为你环境中已安装的技能。

| 类型 ID | 类型名称 | 下游 Skill 链（按序加载） | 备注 |
|---------|---------|--------------------------|------|
| T1 | bugfix | `systematic-debugging` → `eval-optimize-loop` | 先诊断再修复验证 |
| T2 | feature | `feature-delivery-chain` | 完整交付链 |
| T3 | ops | `systematic-debugging` 或领域 ops skill | 视具体子类调整 |
| T4 | question | （无执行链）| 直接回答，不加载实现类 Skill |

## 加载规则

1. 按表格**从左到右**顺序加载
2. 前一 Skill 的 BLOCKER 未解除 → 不加载下一 Skill
3. 链中 Skill 未安装 → 在对话中说明，并询问是否用内联规程替代

## 扩展行模板

```markdown
| T5 | {name} | `skill-a` → `skill-b` | {note} |
```
