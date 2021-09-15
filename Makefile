.PHONY: fmt, fmt-ci, default, test

default:
	@echo "fmt    -- auto format all rego fles"
	@echo "fmt-ci -- list files that aren't formatted"
	@echo "test   -- run opa tests"

fmt:
	@echo 📝 formatting rego files
	@opa fmt . -w

fmt-ci:
	@opa fmt . --list

test:
	@opa test -v ./aws_terraform 