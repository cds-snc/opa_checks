package main

lambda_permissions_with_public_principal[r] = resources {
	changes := input.resource_changes[r]
	resources := [resource |
		resource := changes.address
		changes.type == "aws_lambda_permission"
		changes.change.after.principal == "*"
	]
}

deny_lambda_permission_public_principal[msg] {
	resources := lambda_permissions_with_public_principal[_]
	resources != []
	msg := sprintf("Lambda permission has public principal: %v", [resources])
}
