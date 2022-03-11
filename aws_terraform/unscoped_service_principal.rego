package main

policy_documents_with_service_principals_and_no_account_conditions[r] = resources {
	changes := input.resource_changes[r]
	resources := [resource |
		changes.type == "aws_iam_policy"
		resource := changes.address
		policy := json.unmarshal(changes.change.after.policy)
		statements := policy.Statement[_]
		statements.Principal.Service
		not statements.Action == "sts:AssumeRole"
		k := "AWS:SourceAccount"
		not statements.Condition.StringLike[k]
	]
}

warn_policy_documents_with_service_principals_and_no_account_conditions[msg] {
	resources := policy_documents_with_service_principals_and_no_account_conditions[_]
	resources != []
	msg := sprintf("IAM policies with service principals and no account condition: %v", [resources])
}
