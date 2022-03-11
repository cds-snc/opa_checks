.PHONY: fmt, fmt-ci, generate-plan, default, test, test-plan

default:
	@echo "fmt    -- auto format all rego fles"
	@echo "fmt-ci -- list files that aren't formatted"
	@echo "generate-plan -- generate a plan for the changes"
	@echo "test   -- run opa tests"
	@echo "test-plan -- run opa tests with the plan"

fmt:
	@echo 📝 formatting rego files
	@opa fmt . -w

fmt-ci:
	@opa fmt . --list

generate-plan:
	cd ./test_inputs && \
	terraform init && \
	terraform plan -no-color -out plan.out && \
	terraform show -json plan.out > test.json

test:
	@opa test -v ./aws_terraform 

test-plan:
	conftest test ./test_inputs/test.json -p ./aws_terraform