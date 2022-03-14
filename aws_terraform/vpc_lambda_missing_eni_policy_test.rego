package tests

import data.main as main

test_lambda_with_no_vpc {
	r := main.deny_vpc_lambdas_missing_eni_policy with input as {"configuration": {"root_module": {"resources": [{
		"address": "foo",
		"type": "aws_lambda_function",
		"expressions": {"role": {"references": [
			"aws_iam_role.iam_for_lambda_with_eni.arn",
			"aws_iam_role.iam_for_lambda_with_eni",
		]}},
	}]}}}

	count(r) == 0
}

test_lambda_with_vpc_and_eni_policy {
	r := main.deny_vpc_lambdas_missing_eni_policy with input as {"configuration": {"root_module": {"resources": [
		{
			"address": "bar",
			"type": "aws_iam_role_policy_attachment",
			"expressions": {
				"policy_arn": {"constant_value": "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"},
				"role": {"references": [
					"aws_iam_role.iam_for_lambda_with_eni.name",
					"aws_iam_role.iam_for_lambda_with_eni",
				]},
			},
		},
		{
			"address": "foo",
			"type": "aws_lambda_function",
			"expressions": {
				"role": {"references": [
					"aws_iam_role.iam_for_lambda_with_eni.arn",
					"aws_iam_role.iam_for_lambda_with_eni",
				]},
				"vpc_config": [{
					"security_group_ids": {"constant_value": []},
					"subnet_ids": {"constant_value": []},
				}],
			},
		},
	]}}}

	count(r) == 0
}

test_lambda_with_vpc_and_missing_eni_policy {
	r := main.deny_vpc_lambdas_missing_eni_policy with input as {"configuration": {"root_module": {"resources": [{
		"address": "foo",
		"type": "aws_lambda_function",
		"expressions": {
			"role": {"references": [
				"aws_iam_role.iam_for_lambda_with_eni.arn",
				"aws_iam_role.iam_for_lambda_with_eni",
			]},
			"vpc_config": [{
				"security_group_ids": {"constant_value": []},
				"subnet_ids": {"constant_value": []},
			}],
		},
	}]}}}

	r[_] == "Lambda attached to VPC is missing ENI policy: [\"foo\"]"
	count(r) == 1
}
