package main

container_definition_template_with_trailing_comma[r] = resources {
	changes := input.resource_changes[r]
	resources := [resource |
		resource := changes.address
		changes.type == "aws_ecs_task_definition"
		regex.match(`}\s*,+\s*]|]\s*,+\s*}|}\s*,+\s*}|}\s*,+\s*\z|]\s*,+\s*\z|"\s*,+\s*]|"\s*,+\s*}|"\s*,+\s*\z`, changes.change.after.container_definitions)
	]
}

deny_container_definition_template_with_trailing_comma[msg] {
	resources := container_definition_template_with_trailing_comma[_]
	resources != []
	msg := sprintf("Container definition contains trailing commas: %v", [resources])
}
