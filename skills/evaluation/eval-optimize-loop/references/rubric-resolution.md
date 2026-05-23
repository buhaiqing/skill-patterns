# Active Rubric 解析（Critic / Generator 共用）

Round 0 结束后，**本轮 Eval-Optimize 的唯一评测标准**是 rubric **实例**文件，不是模板库里的母版。

## 解析顺序

```text
1. Handoff 中「Active Rubric」声明的 rubric_path（最高优先级）
2. 若存在 references/rubric-instances/{task-id}-rubric.md → 使用该文件
3. 否则 fallback：references/rubric.md（须在 Handoff 注明 template_id: generic-default）
```

**禁止**：Critic 读取 `rubric-templates/` 下母版直接打分（母版含未填充占位符）。

## Round 0 必须产出实例

```text
有行业匹配:
  复制 rubric-templates/{path} → rubric-instances/{task-id}-rubric.md
  填充占位符 + 写入实例头（template_id、template_version）

无匹配 / 用户要求默认:
  复制 references/rubric.md → rubric-instances/{task-id}-rubric.md
  template_id: generic-default

动态生成新模板后:
  仍须实例化到 rubric-instances/ 再开始 Round 1
```

`task-id`：plan 任务 ID、issue 号、或 `{YYYYMMDD}-{slug}`。

## Handoff 必填字段

见 [generator-handoff.md](./generator-handoff.md) 中 **Active Rubric** 小节。

## Critic 必读

派发 Critic 时，prompt 中 `rubric_path` 必须为上述解析结果；评测表 `rubric_id` **必须与实例表中 ID 列一致**（如 B1、O1、D1，不得混用 R1 除非实例来自 rubric.md）。

## 与 blocker-conditions 的关系

BLOCKER 项 = **当前 active rubric 实例**中「级别」列为 BLOCKER 的所有 `rubric_id`，不以 rubric.md 的 R1/R2/R5 为默认。
