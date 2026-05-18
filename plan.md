# Plan — Skills 脚手架验收

## 概述

对 `patterns` 仓库中 6 个 Skill 脚手架做结构、脚本与文档一致性验收（只读 + 轻量修复）。

## 任务列表

- [ ] **Task 1 — SKILL 结构审计**  
  验收：6 个 `SKILL.md` 均含 frontmatter（name/description）、开场白、禁止项、指向 `docs/` 的链接；输出缺失项清单。  
  范围：`skills/**/SKILL.md`（只读）

- [ ] **Task 2 — 脚本 smoke test**  
  验收：`classify.py` 与 `aggregate_votes.py` 各至少 2 组用例运行成功；记录命令与 exit code。  
  范围：`skills/routing/task-router/scripts/`、`skills/parallel/vote-synthesis/scripts/`

- [ ] **Task 3 — 文档交叉引用审计**  
  验收：`summary.md`、`docs/*.md` 中指向 `skills/` 的路径存在且与目录一致；输出断链列表。  
  范围：`summary.md`、`docs/`（只读）

## 验证命令

```bash
python3 skills/routing/task-router/scripts/classify.py --text "fix login 500"
python3 skills/parallel/vote-synthesis/scripts/aggregate_votes.py --votes '["A","B","A"]'
```

## 依赖

- Task 1、2、3 **无相互依赖**，可并行派发。

## 风险

- 本仓库无单元测试框架；以脚本 smoke + 人工清单为主。
