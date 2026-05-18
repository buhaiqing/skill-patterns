# Orchestrator — 任务类型 → Worker 选型

| 任务标签 | subagent_type | 可选专用 Skill |
|---------|---------------|----------------|
| explore | explore | — |
| implement | generalPurpose / executor | — |
| fix-build | build-fixer | — |
| test | test-engineer | — |
| review-spec | — | spec reviewer prompt |
| review-quality | code-reviewer | `code-reviewer` |
| security | security-reviewer | — |

> **定制**：按你团队的 subagent 能力增删行。
