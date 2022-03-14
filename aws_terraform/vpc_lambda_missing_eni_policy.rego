package main

vpc_lambdas_missing_eni_policy[r] = resources {
	configurations := input.configuration.root_module.resources[r]
	resources := [resource |
		resource := configurations.address
		configurations.type == "aws_lambda_function"
		configurations.expressions.vpc_config
		configurations.expressions.role.references
		not has_eni_policy_in_role(input, configurations.expressions.role.references)
	]
}

has_eni_policy_in_role(original, role_references) {
	[_, reference] := role_references
	configurations := input.configuration.root_module.resources[r]
	resources := [resource |
		resource := configurations.address
		configurations.type == "aws_iam_role_policy_attachment"
		configurations.expressions.policy_arn.constant_value == "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
		[concat(".", [reference, "name"]), reference] == configurations.expressions.role.references
	]

	count(resources) == 1
}

deny_vpc_lambdas_missing_eni_policy[msg] {
	resources := vpc_lambdas_missing_eni_policy[_]
	resources != []
	msg := sprintf("Lambda attached to VPC is missing ENI policy: %v", [resources])
}
