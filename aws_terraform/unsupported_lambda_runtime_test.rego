package tests

import data.main as main

test_valid_runtime {
	r := main.deny_invalid_runtime with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_lambda_function",
		"change": {"after": {"package_type": "Zip", "runtime": "python3.11"}},
	}]}

	count(r) == 0
}

test_invalid_runtime {
	r := main.deny_invalid_runtime with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_lambda_function",
		"change": {"after": {"package_type": "Zip", "runtime": "python2.7"}},
	}]}

	r[_] == "Lambda function has invalid runtime: [\"foo\"]"
	count(r) == 1
}

test_container_runtime {
	r := main.deny_invalid_runtime with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_lambda_function",
		"change": {"after": {"package_type": "Image", "runtime": ""}},
	}]}

	count(r) == 0
}
