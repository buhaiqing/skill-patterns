# eval-optimize-loop 校验脚本

## 一键全量（CI / 提交前 / Rubric 规则变更后）

```bash
./validate_all.sh
# 或带原因说明（复盘应用、模板进化等）:
./run_rubric_change_gate.sh "post-retrospective-ops-incident-response"
```

**何时必须跑**：见 [../references/rubric-change-gate.md](../references/rubric-change-gate.md)（只读复盘不必；改模板/registry/规程 必须）。

## 分层检测矩阵

| 脚本 | 检测对象 | 防什么问题 |
|------|----------|------------|
| `validate_rubric_registry.sh` | `_registry.yaml` → 文件 | 注册表死链（P0） |
| `validate_registry_consistency.sh` | 注册表 ↔ 模板目录 | 孤儿模板、重复 id、缺 keywords |
| `validate_registry_metadata.sh` | stats 计数、industry/scenario | 元数据与 frontmatter 不一致 |
| `validate_rubric_templates.sh` | 行业模板 `.md` | 无评测项、无 BLOCKER、ID 重复、级别非法 |
| `validate_rubric_default.sh` | `references/rubric.md` | 默认 rubric 结构残缺 |
| `validate_skill_integrity.sh` | Critic/Handoff/SKILL 契约 | Critic 读错 rubric、断链 |
| `validate_usage_logs.sh` | `rubric-usage-logs/*.yaml` | 复盘日志缺字段、非法 outcome |
| `validate_runtime_smoke.sh` | 实例化+门禁+写日志 | 运行时脚本端到端不可用 |
| `validate_match_rubric_fixtures.py` | match 回归 fixtures | L1 匹配漂移 |
| `validate_test_prompts.sh` | test-prompts.json | 效果回归用例 |
| `bump_registry_usage.py` | usage_count +1 | 复盘计数（write_usage_log 默认调用） |

## 运行时辅助（非 CI 必跑，编排者使用）

| 脚本 | 用途 |
|------|------|
| `match_rubric_template.py` | Round 0 L1 关键词匹配（确定性） |
| `instantiate_rubric.sh` | Round 0 生成实例 |
| `check_round0_gate.sh` | Round 1 前门禁 |
| `write_usage_log.sh` | 写日志并自动 `validate_usage_logs` |

## 单独运行示例

```bash
./validate_usage_logs.sh references/rubric-usage-logs/generic-bug-fix-20260101-120000.yaml
./check_round0_gate.sh T3
```
