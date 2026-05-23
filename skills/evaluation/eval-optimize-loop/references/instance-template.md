---
# Rubric 实例化模板
# 由 rubric-templates/{industry}/rubric-{scenario}.md 生成
---

任务信息:
  任务ID: {TASK_ID}
  创建时间: {TIMESTAMP}
  template_id: {REGISTRY_ID}
  基于模板: {TEMPLATE_PATH}
  模板版本: {TEMPLATE_VERSION}

实例化记录:
  - 占位符: {PLACEHOLDER_1} → 实际值: {VALUE_1}
  - 占位符: {PLACEHOLDER_2} → 实际值: {VALUE_2}
  # ...

用户修改:
  - 修改项: {ITEM_ID} → 修改内容: {MODIFICATION}
  # ...

确认状态: [ ] 待确认 / [x] 已确认
确认人: {USER}
确认时间: {CONFIRM_TIME}

---

# {任务名称} Rubric 实例

> 基于 {行业}-{场景} 模板 v{版本} 实例化

## 评测项

| ID | 项 | Pass 条件 | 级别 | 证据要求 |
|----|-----|----------|------|---------|
| {X}1 | {名称} | {实际Pass条件} | {级别} | {证据} |
| ... | ... | ... | ... | ... |

## 执行记录

### Round 1
- Generator: {实现描述}
- Critic: {评测结果}
- 结论: {通过/未通过}
- BLOCKER: {列表}
- 待修: {rubric_id列表}

### Round 2
- Generator: {修复描述}
- Critic: {评测结果}
- 结论: {通过/未通过}

### Round 3 (如适用)
...

## 最终结果

- 状态: {成功 / 失败 / Escalate}
- 总轮次: {N}
- 用户评分: {1-5}
- 反馈: {用户反馈}

## 沉淀建议

使用此实例后，建议：
- [ ] 沉淀为新的 rubric 模板
- [ ] 优化现有 rubric 模板
- [ ] 无需沉淀
