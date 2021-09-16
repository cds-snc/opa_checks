package main

valid_effects = {
	"Allow",
	"Deny",
}

policy_documents_with_invalid_names[r] = resources {
	changes := input.resource_changes[r]
	resources := [resource |
		resource := changes.address
		changes.type == "aws_iam_policy_document"
		not valid_effects[changes.change.after.statement[r].effect]
	]
}

deny_invalid_effect[msg] {
	resources := policy_documents_with_invalid_names[_]
	resources != []
	msg := sprintf("Policy document has invalid effect: %v", [resources])
}
