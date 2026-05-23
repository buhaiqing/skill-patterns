# Round 0：Rubric 选择 / 生成 / 实例化

> 从 `SKILL.md` 渐进披露。进入 Round 1 前必须完成实例化与 [round-0-gate.md](./round-0-gate.md)。

## 快捷路径（跳过工厂匹配）

用户明确说「**默认 rubric**」或 **trivial** 任务（单行文案/极小 diff）：

```bash
./scripts/instantiate_rubric.sh {task-id} --default
# 编辑占位符 → confirm_status: confirmed
./scripts/check_round0_gate.sh {task-id}
```

## 标准路径

### Step 1：L1 匹配（确定性，优先于 Agent 自算相似度）

```bash
./scripts/match_rubric_template.py "用户任务描述原文"
# 或: make match-rubric QUERY='修复订单金额 bug'
```

输出 `action`：`direct` | `confirm` | `generate` 与 `template_id`、`score`。

| action | 含义 |
|--------|------|
| `direct` | score ≥ 0.8，可直接实例化 |
| `confirm` | 0.5 ≤ score < 0.8，展示 Top3 让用户选 |
| `generate` | score < 0.5，走动态生成 |

细则与关键词表见 [rubric-selector.md](./rubric-selector.md)。

### Step 2：意图识别（L1 不足时）

提取：行业（ops/finance/quant/generic/software-dev）、场景、安全/合规/性能需求。

### Step 3：实例化（Round 1 唯一评测源）

见 [rubric-resolution.md](./rubric-resolution.md)。

```bash
./scripts/instantiate_rubric.sh {task-id} {template-id}
# 填充占位符 → confirm_status: confirmed
./scripts/check_round0_gate.sh {task-id}
```

### Step 4：动态生成（`action=generate`）

触发 [rubric-generator/generator-prompt.md](./rubric-generator/generator-prompt.md) → 更新 `_registry.yaml` →：

```bash
./scripts/run_rubric_change_gate.sh "new-template"
```

再实例化 → 用户确认 → Round 1。
