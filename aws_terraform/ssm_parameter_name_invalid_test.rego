package tests

import data.main as main

# Test cases for SSM parameter names not starting with 'aws' or 'ssm'

test_ssm_name_starts_with_aws {
	# Expected to produce a violation message
	r := main.deny_ssm_name_that_starts_with_aws_or_ssm with input as {"resource_changes": [{
		"type": "aws_ssm_parameter",
		"change": {"after": {"name": "aws_param_name"}},
	}]}

	count(r) == 1
	r[_] == "SSM parameter name 'aws_param_name' should not start with 'aws' or 'ssm"
}

test_ssm_name_starts_with_ssm {
	# Expected to produce a violation message
	r := main.deny_ssm_name_that_starts_with_aws_or_ssm with input as {"resource_changes": [{
		"type": "aws_ssm_parameter",
		"change": {"after": {"name": "ssm_param_name"}},
	}]}

	count(r) == 1
	r[_] == "SSM parameter name 'ssm_param_name' should not start with 'aws' or 'ssm"
}

test_ssm_name_does_not_start_with_aws_or_ssm {
	# Expected not to produce a violation message
	r := main.deny_ssm_name_that_starts_with_aws_or_ssm with input as {"resource_changes": [{
		"type": "aws_ssm_parameter",
		"change": {"after": {"name": "param_name"}},
	}]}

	count(r) == 0
}

test_ssm_name_starts_with_other {
	# Expected not to produce a violation message
	r := main.deny_ssm_name_that_starts_with_aws_or_ssm with input as {"resource_changes": [{
		"type": "aws_ssm_parameter",
		"change": {"after": {"name": "other_param_name"}},
	}]}

	count(r) == 0
}

test_ssm_name_is_empty {
	# Expected not to produce a violation message
	r := main.deny_ssm_name_that_starts_with_aws_or_ssm with input as {"resource_changes": [{
		"type": "aws_ssm_parameter",
		"change": {"after": {"name": ""}},
	}]}

	count(r) == 0
}
