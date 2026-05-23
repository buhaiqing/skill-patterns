# BLOCKER 条件

任一触发 → **本轮 Critic 结论为未通过**；部分项 → **立即终止整个循环**（不再消耗 MAX_ITER）。

## Rubric BLOCKER 项 fail

见 **当前 Active Rubric 实例**（[rubric-resolution.md](./rubric-resolution.md)）中级别为 BLOCKER 的所有 `rubric_id`。
不得以固定 R1/R2/R5 代替；行业实例常见 ID 为 B1、O1、D1 等。

## 立即终止整个循环（不进入下一轮 Generate）

| 条件 | 动作 |
|------|------|
| 安全漏洞可利用（注入、泄露密钥） | escalate，禁止 merge |
| spec 与实现根本矛盾且用户未澄清 | escalate |
| 同一 BLOCKER 项连续 3 轮 fail | escalate（可能 spec 错误） |
| Critic 与 Generator 对 BLOCKER 认定冲突且无法复现 | escalate，附双方证据 |

## 会话级禁止（触发即违规）

| 禁止行为 | 视为 |
|---------|------|
| Generator 无 Critic 输出即宣称 pass | 流程违规 |
| Critic 修改了仓库文件 | 角色混用，本轮作废 |
| 无验证命令却对依赖命令/evidence 的 rubric 项标 pass | Critic 无效，需重派 |

## 与 max-iterations 的关系

- **单轮 BLOCKER fail**：可进入 Optimize（若未命中「立即终止」表）
- **Round == MAX_ITER 仍有 BLOCKER fail**：escalate（见 escalate-template.md）
