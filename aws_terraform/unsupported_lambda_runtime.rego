package main

valid_runtimes = {
	"dotnet7",
	"dotnet6",
	"nodejs22.x",
	"nodejs20.x",
	"nodejs18.x",
	"python3.13",
	"python3.12",
	"python3.11",
	"python3.10",
	"python3.9",
	"ruby3.2",
	"ruby2.7",
	"java21",
	"java17",
	"java11",
	"java8.al2",
	"java8",
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
