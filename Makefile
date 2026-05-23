# skill-patterns — 常用维护目标
# 用法: make help

EVAL_SKILL := skills/evaluation/eval-optimize-loop
EVAL_SCRIPTS := $(EVAL_SKILL)/scripts

.PHONY: help validate-eval validate-eval-gate validate-eval-registry \
	instantiate-rubric check-round0 gate-rubric-changed match-rubric test-prompts-eval

help:
	@echo "skill-patterns Makefile"
	@echo ""
	@echo "  make validate-eval              全量校验 eval-optimize-loop（同 CI）"
	@echo "  make validate-eval-gate REASON=…  Rubric 规则变更后门禁（复盘应用/改模板等）"
	@echo "  make validate-eval-registry      仅校验注册表 path（快速）"
	@echo "  make gate-rubric-changed REASON=…  validate-eval-gate 的别名"
	@echo ""
	@echo "  make instantiate-rubric TASK_ID=… TEMPLATE_ID=…|default"
	@echo "  make check-round0 TASK_ID=…       Round 0 门禁"
	@echo "  make match-rubric QUERY='…'       L1 确定性 rubric 模板匹配"
	@echo "  make test-prompts-eval            test-prompts.json 中 match 回归"
	@echo ""
	@echo "示例:"
	@echo "  make validate-eval"
	@echo "  make validate-eval-gate REASON=post-retrospective-ops-incident-response"
	@echo "  make instantiate-rubric TASK_ID=T3 TEMPLATE_ID=ops-incident-response"
	@echo "  make check-round0 TASK_ID=T3"

$(EVAL_SCRIPTS):
	@chmod +x $(EVAL_SCRIPTS)/*.sh

validate-eval: $(EVAL_SCRIPTS)
	@$(EVAL_SCRIPTS)/validate_all.sh

validate-eval-gate: $(EVAL_SCRIPTS)
	@test -n "$(REASON)" || (echo "错误: 请指定 REASON，例如 make validate-eval-gate REASON=post-retrospective"; exit 1)
	@$(EVAL_SCRIPTS)/run_rubric_change_gate.sh "$(REASON)"

gate-rubric-changed: validate-eval-gate

validate-eval-registry: $(EVAL_SCRIPTS)
	@$(EVAL_SCRIPTS)/validate_rubric_registry.sh
	@$(EVAL_SCRIPTS)/validate_registry_consistency.sh
	@$(EVAL_SCRIPTS)/validate_registry_metadata.sh

instantiate-rubric: $(EVAL_SCRIPTS)
	@test -n "$(TASK_ID)" || (echo "错误: 请指定 TASK_ID"; exit 1)
	@if [ "$(TEMPLATE_ID)" = "default" ] || [ -z "$(TEMPLATE_ID)" ]; then \
		$(EVAL_SCRIPTS)/instantiate_rubric.sh "$(TASK_ID)" --default; \
	else \
		$(EVAL_SCRIPTS)/instantiate_rubric.sh "$(TASK_ID)" "$(TEMPLATE_ID)"; \
	fi

check-round0: $(EVAL_SCRIPTS)
	@test -n "$(TASK_ID)" || (echo "错误: 请指定 TASK_ID"; exit 1)
	@$(EVAL_SCRIPTS)/check_round0_gate.sh "$(TASK_ID)"

match-rubric: $(EVAL_SCRIPTS)
	@test -n "$(QUERY)" || (echo "错误: 请指定 QUERY，例如 make match-rubric QUERY='修复 bug'"; exit 1)
	@chmod +x $(EVAL_SCRIPTS)/match_rubric_template.py
	@$(EVAL_SCRIPTS)/match_rubric_template.py "$(QUERY)"

test-prompts-eval: $(EVAL_SCRIPTS)
	@chmod +x $(EVAL_SCRIPTS)/validate_test_prompts.sh $(EVAL_SCRIPTS)/match_rubric_template.py
	@$(EVAL_SCRIPTS)/validate_test_prompts.sh
