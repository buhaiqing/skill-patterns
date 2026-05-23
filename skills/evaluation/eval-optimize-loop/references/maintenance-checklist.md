# eval-optimize-loop 维护清单（防 P0 复发）

修改本 Skill 的 `references/`、`rubric-templates/` 或 `SKILL.md` 时，**必须**完成下列项。

## 提交前 / Rubric 规则变动后（仓库维护者）

**统一门禁**（与复盘 [应用]、模板进化、registry 变更相同）：

```bash
# 仓库根目录（推荐）
make validate-eval-gate REASON=describe-your-change

# 或进入 Skill 目录
cd skills/evaluation/eval-optimize-loop
chmod +x scripts/*.sh
./scripts/run_rubric_change_gate.sh "describe-your-change"
# 等价于 validate_all.sh，非 0 不得合并或对外宣布可用
```

触发条件一览见 [rubric-change-gate.md](./rubric-change-gate.md)。

含：注册表、模板结构、默认 rubric、规程契约、usage log、运行时冒烟。详见 [scripts/README.md](../scripts/README.md)。

CI 在 PR 中会自动运行同一命令（见仓库 `.github/workflows/validate-eval-optimize-loop.yml`）。

## 新增 Rubric 模板

1. 在 `references/rubric-templates/` 下新增 `rubric-*.md`（含 frontmatter、`## 评测项`、BLOCKER 行、唯一 ID 列）
2. **同步**更新 `_registry.yaml`：`id`、`path`、`keywords`、`version`
3. 运行 `validate_all.sh`（会检出 **死链** 与 **孤儿文件**）
4. 更新 `rubric-templates/README.md` 列表（可选但建议）

**禁止**：只改 `_registry.yaml` 不创建文件，或只加文件不注册。

## 修改 Critic / Handoff 规程

若改动 `critic-prompt-template.md` 或 `generator-handoff.md`，须保持：

- Critic prompt 含 `{rubric_path}`，且以 **实例** 为唯一评测源
- Handoff 含 **Active Rubric** 三节字段
- `validate_skill_integrity.sh` 通过（契约断言）

## 运行时（编排者 / Agent）

| 阶段 | 用脚本代替手工 | 目的 |
|------|----------------|------|
| Round 0 | `instantiate_rubric.sh` + `check_round0_gate.sh` | 防路径/ID 不一致 |
| 循环结束 | `write_usage_log.sh` | 防复盘无日志 |
| 动态新模板 / 复盘应用后 | `run_rubric_change_gate.sh` | 全量一致性（含注册表、契约、冒烟） |

## P0 复发信号（Code Review 时警惕）

- Critic prompt 又出现「读 `references/rubric.md`」作为默认
- Handoff 无 `rubric_path`
- 评测表 ID 与实例表不一致（如实例 B1、反馈写 R1）
- `_registry.yaml` 的 `path` 无对应文件
- 任务结束无 `rubric-usage-logs/*.yaml`
