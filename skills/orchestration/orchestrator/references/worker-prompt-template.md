# Worker Prompt 模板

```markdown
## 你的任务（完整原文）
{task_full_text}

## 范围
- 只允许修改：{allowed_paths}
- 禁止修改：{forbidden_paths}

## 验收标准
{acceptance_criteria}

## 验证命令（必须运行并贴出输出）
{verify_commands}

## 约束
- 单一职责：仅完成上述任务
- 不要重构范围外代码
- 不要 commit 除非任务明确要求

## 完成后必须按 handoff-format 输出
```

## subagent_type 选型（Cursor）

| 任务性质 | 建议 type |
|---------|-----------|
| 探索代码库 | explore |
| 实现功能 | generalPurpose / executor |
| 修编译错误 | build-fixer |
| 写测试 | test-engineer |
| 安全审查 | security-reviewer |
