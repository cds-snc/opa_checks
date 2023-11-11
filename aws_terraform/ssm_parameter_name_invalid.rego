package main

import input as tfplan

# Violation message
deny_ssm_name_that_starts_with_aws_or_ssm[msg] {
	resource := tfplan.resource_changes[_]
	resource.type == "aws_ssm_parameter"
	name := input.resource_changes[_].change.after.name
	any([startswith(name, "aws") == true, startswith(name, "ssm") == true])
	msg = sprintf("SSM parameter name '%s' should not start with 'aws' or 'ssm", [name])
}
