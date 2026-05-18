---
name: eval-optimize-loop
description: >-
  Critic-Generator loop: Generator implements, independent Critic subagent
  evaluates against rubric with iteration limits and BLOCKER gates. Use before
  claiming work complete, merging PRs, or when quality must pass explicit criteria.
---

# Eval-Optimize Loop（Critic-Generator）

Evaluator-Optimizer / **Critic-Generator** 模式 Skill。

> 模式文档：[docs/05-evaluator-optimizer.md](../../../docs/05-evaluator-optimizer.md)

## 开场白（必须）

「使用 eval-optimize-loop：Generator 实现，独立 Critic subagent 按 rubric 评测。」

## 角色（不可混用）

| 角色 | 会话内主体 | 职责 |
|------|-----------|------|
| **Generator** | 主 Agent 或 `executor` subagent | Generate / Optimize：实现与按反馈修复 |
| **Critic** | **必须** Task 派发的独立 subagent | Evaluate：只评不改，`readonly: true` |

编排者（父 Agent）负责派发 Critic、传递 handoff、禁止 Generator 自评即通过。

## 循环协议

```text
MAX_ITER = 3（见 references/max-iterations.md）

for round in 1..MAX_ITER:
  1. Generate  — Generator 按 spec 实现 / 仅修上轮 Critic 指出的项
  2. Handoff   — 按 references/generator-handoff.md 打包
  3. Evaluate  — Task 派发 Critic（references/critic-prompt-template.md）
  4. 全 pass   — 退出循环 → verification-before-completion（若已安装）
  5. fail      — Generator 读 critic-feedback-format，仅修列出的项
  6. round == MAX_ITER 且仍 fail → escalate

禁止：Generator 在同一轮既实现又填写「评测表」并宣布通过。
```

## Critic 派发（必须）

1. Read [critic-prompt-template.md](references/critic-prompt-template.md)
2. 填充 handoff、`{round}`、`{allowed_paths}`
3. 调用 Task：

```text
description: "Critic round {n} — rubric eval"
subagent_type: code-reviewer | quality-reviewer | security-reviewer（按 rubric 选）
readonly: true
prompt: {filled critic template}
```

4. 等待 Critic 输出 [critic-feedback-format.md](references/critic-feedback-format.md)
5. 将「评测表」记入会话；**不得**由 Generator 代填 Critic 结论

## Generator Optimize 规则

- 只处理 Critic 反馈中 `severity: BLOCKER|normal` 且 `status: fail` 的项
- 每项修复注明 `rubric_id` + 变更路径
- **禁止** scope creep、「顺便重构」
- 修复后进入下一轮 Handoff → Critic（不可跳过 Evaluate）

## 硬性门禁

| 门禁 | 规则 |
|------|------|
| 角色 | Critic 禁止改代码；Generator 禁止自评 pass |
| 证据 | 未运行验证命令 → Critic 不得对 R1/R3 等项标 pass |
| BLOCKER | 见 [blocker-conditions.md](references/blocker-conditions.md) |
| 措辞 | 禁止「应该能通过」「大概没问题」 |
| 轮次 | 超过 MAX_ITER 禁止静默重试 |

## 编排者输出（每轮）

Critic 返回后，编排者向用户展示摘要：

```markdown
## Eval-Optimize — Round {n}/{MAX_ITER}

**Critic**：{subagent_type} · readonly
**结论**：通过 / 未通过
**BLOCKER**：{list or 无}
**待修**：{rubric_id 列表}
```

完整评测表以 Critic 输出为准（见 critic-feedback-format）。

## Escalate

见 [escalate-template.md](references/escalate-template.md)。

## 与 Orchestrator 组合

Worker 完成后由编排者触发本 Skill；handoff 转为 generator-handoff，**每任务独立 MAX_ITER**。

- 规程：[composition-orchestrator.md](references/composition-orchestrator.md)
- 端到端示例：[docs/examples/01-orchestrator-eval-optimize.md](../../../docs/examples/01-orchestrator-eval-optimize.md)

## 与 CI / Evals-as-Code

```text
Orchestrator 每任务 Critic 循环 → 集成 Critic → PR → CI evalset → merge
```

## 禁止

- Generator 单方面宣布通过
- Critic 直接改仓库或 commit
- 同一 context 下 Generator 扮演 Critic
- 超过 MAX_ITER 仍静默重试
- 无 rubric ID 的模糊反馈（「再看看」「不够好」）
