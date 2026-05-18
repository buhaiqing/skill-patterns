# 迭代上限与 Escalate 规则

| 参数 | 默认值 | 说明 |
|------|--------|------|
| MAX_ITER | 3 | Generate-Evaluate 最大轮数 |
| BLOCKER | 立即终止 | 安全/测试全挂等 |

## 轮次行为

| 轮次 | 预期 |
|------|------|
| 1 | 完整实现 + 首次评测 |
| 2 | 仅修 fail 项 |
| 3 | 最后一轮机会 |
| >3 | **禁止** — 必须 escalate |

## Escalate 条件

- Round 3 结束仍有 BLOCKER fail
- 同一 R 项连续 3 轮 fail（可能 spec 有问题）
- Critic 与 Generator 对 BLOCKER 认定冲突
- Critic 违反只评不改（改了文件）→ 该轮作废，不计入 MAX_ITER 时可重派 Critic

## Escalate 后

- 输出 [escalate-template.md](./escalate-template.md)
- 不 commit / 不 merge
- 请求人工介入或澄清 spec
