# Delivery Chain — 分步细则

## Step 1：brainstorming / 需求澄清

**目标**：弄清用户要什么、约束是什么、有哪些未知。

**产出**：`findings.md`

```markdown
# Findings

## 目标
## 约束
## 已确认事实
## 待澄清问题（若有）
## 建议方案方向（可选）
```

**完成标准**：无未闭合的 BLOCKER 级问题，或已记录用户选择。

---

## Step 2：writing-plans / 写计划

**目标**：可执行任务列表 + 验收标准。

**产出**：`plan.md`

```markdown
# Plan

## 概述
## 任务列表
- [ ] Task 1 — 验收：…
- [ ] Task 2 — 验收：…

## 验证命令
- `npm test` / `go test ./...` / …

## 风险
```

**完成标准**：`plan.md` 存在；用户确认或明确跳过。

---

## Step 3：executing-plans / 执行

**目标**：按 plan 逐项实现，每项可独立验证。

**规则**：
- 一次聚焦一个任务
- 每完成一项在 plan 中勾选
- 更新 `progress.md`

---

## Step 4：verification-before-completion / 验证

**目标**：用**新鲜**命令输出证明 claim。

**门禁函数**：
1. IDENTIFY — 什么命令能证明？
2. RUN — 完整执行
3. READ — 读全输出、exit code
4. VERIFY — 输出是否支持结论？
5. ONLY THEN — 才能宣称完成

参见 `verification-before-completion` Skill（若已安装）。
