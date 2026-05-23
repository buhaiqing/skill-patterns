# Rubric 变更门禁 — validate_all

> **原则**：凡改变「评测规则源」或「规则元数据」的操作，完成后**必须**跑 `./scripts/validate_all.sh` 并全绿，再宣布可用或继续下一轮 Eval-Optimize。

## 何时必须跑 validate_all

| 场景 | 是否必须 | 说明 |
|------|----------|------|
| 复盘 **仅分析**（读 log、出报告） | 否 | 只读，未改规则文件 |
| 复盘 **[应用] / [编辑]** 改模板 | **是** | 评测项/ID/BLOCKER 可能变化 |
| 更新 `_registry.yaml`（含 version/keywords/path） | **是** | 元数据与路径契约 |
| 新增/删除 `rubric-templates/**/*.md` | **是** | 防死链与孤儿模板 |
| 修改 `references/rubric.md`（默认母版） | **是** | 影响 fallback 快捷路径 |
| 修改 Critic/Handoff/BLOCKER 规程 | **是** | skill_integrity 契约 |
| 动态生成并沉淀新模板 | **是** | 注册表 + 文件双向一致 |
| 仅 `instantiate_rubric` 单次任务实例 | 否 | 用 `check_round0_gate.sh` 即可 |
| 仅 `write_usage_log.sh` | 否 | 脚本内已校验该条 log |

## 何时不必跑完整 validate_all（但仍有检查）

- **单次任务**改 `rubric-instances/{task-id}-rubric.md`：跑 `check_round0_gate.sh {task-id}`，确保占位符与 confirm。
- **CI** 已在 PR 中自动跑 validate_all；本地改模板后仍需在合并前本地再跑一遍。

## 标准命令

```bash
# 仓库根目录（推荐）
make validate-eval-gate REASON=post-retrospective-ops-incident-response
# 或仅全量校验
make validate-eval

# Skill 目录内
cd skills/evaluation/eval-optimize-loop
chmod +x scripts/*.sh
./scripts/run_rubric_change_gate.sh "post-retrospective-ops-incident-response"
```

**退出码必须为 0**。失败则：

1. 根据输出修复（死链、stats 计数、BLOCKER 行、契约断言等）
2. 重新跑 `./scripts/validate_all.sh`
3. **禁止**在失败状态下标记「复盘完成」或对新任务启用该 rubric

## 与复盘流程的衔接

```text
复盘 Step 1–4: 分析（只读）→ 不必 validate_all
用户 [应用] / [编辑]:
  → 改模板 + registry version
  → Step 5: validate_all（本门禁）
  → 全绿后 → 更新 evolution 记录 / 通知可用
```

## 与「一致性」的关系

| 一致性维度 | validate_all 覆盖 |
|------------|-------------------|
| 注册表 path ↔ 文件 | validate_rubric_registry |
| 注册表 ↔ frontmatter | validate_registry_metadata |
| 模板结构（ID/BLOCKER/评测项） | validate_rubric_templates |
| 默认 rubric | validate_rubric_default |
| Critic 只读实例契约 | validate_skill_integrity |
| 运行时脚本可用 | validate_runtime_smoke |

**不覆盖**：某次任务实例内容与母版差异（属预期定制）；Critic 当轮是否严格遵守实例 ID（靠规程 + 人工 spot check）。

## 编排者输出（变更后对用户）

```markdown
**Rubric 变更门禁**：已运行 `validate_all.sh` — 通过 / 失败（附首条错误）
```

未附上述声明且规则文件有改动 → 视为流程未完成。
