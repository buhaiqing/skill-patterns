# 任务分型 — 关键词评分（模板）

> **定制**：将 `T1`–`T4` 替换为你项目的真实任务类型。

## 类型定义

| ID | 名称 | 说明 |
|----|------|------|
| T1 | bugfix | 缺陷修复、报错、回归 |
| T2 | feature | 新功能、增强 |
| T3 | ops | 部署、配置、巡检、运维 |
| T4 | question | 咨询、文档、解释，无代码变更 |

## 评分规则

每个类型独立计分：关键词命中 +2，正则命中 +3，标题/标签精确匹配 +5。

```text
T1 关键词: bug, fix, error, 报错, 异常, regression, failed test
T2 关键词: feature, 新功能, add, implement, 需求
T3 关键词: deploy, 部署, config, 巡检, ops, k8s, release
T4 关键词: how, why, explain, 是什么, 怎么用, document
```

## 决策

1. 取最高分类型为候选
2. `confidence = top_score / (top_score + second_score + 1)`，上限 1.0
3. 若 top_score < 2 → **无法归类**
4. 若 confidence < 0.6 → **低置信度**，请用户确认

## 输出示例

```text
候选: T1 bugfix, score=7, confidence=0.78
次选: T3 ops, score=2
```
