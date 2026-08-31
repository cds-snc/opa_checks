package main

valid_runtimes = {
	"dotnet6",
	"dotnet8",
	"go1.x",
	"provided",
	"nodejs18.x",
	"python3.10",
	"java17",
	"ruby3.2",
	"python3.11",
	"nodejs20.x",
	"provided.al2023",
	"python3.12",
	"java21",
	"python3.13",
	"nodejs22.x",
	"nodejs24.x",
	"python3.14",
	"java25",
	"dotnet10",
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
