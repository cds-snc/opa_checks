package main

valid_runtimes = {
	"nodejs18.x",
	"nodejs16.x",
	"nodejs14.x",
	"python3.11",
	"python3.10",
	"python3.9",
	"python3.8",
	"python3.7",
	"ruby2.7",
	"java11",
	"go1.x",
}

lambdas_with_invalid_runtimes[r] = resources {
	changes := input.resource_changes[r]
	resources := [resource |
		resource := changes.address
		changes.type == "aws_lambda_function"
		changes.change.after.package_type == "Zip"
		not valid_runtimes[changes.change.after.runtime]
	]
}

deny_invalid_runtime[msg] {
	resources := lambdas_with_invalid_runtimes[_]
	resources != []
	msg := sprintf("Lambda function has invalid runtime: %v", [resources])
}
