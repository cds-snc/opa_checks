package tests

import data.main as main

test_lambda_permission_with_cloudfront_principal {
	r := main.deny_lambda_permission_public_principal with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_lambda_permission",
		"change": {"after": {"principal": "cloudfront.amazonaws.com"}},
	}]}

	count(r) == 0
}

test_lambda_permission_with_public_principal {
	r := main.deny_lambda_permission_public_principal with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_lambda_permission",
		"change": {"after": {"principal": "*"}},
	}]}

	count(r) == 1
	r[_] == "Lambda permission has public principal: [\"foo\"]"
}

test_non_lambda_permission_with_public_principal {
	r := main.deny_lambda_permission_public_principal with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_iam_policy",
		"change": {"after": {"principal": "*"}},
	}]}

	count(r) == 0
}
