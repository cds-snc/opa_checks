package main

container_definition_name_with_spaces[r] = resources {
	changes := input.resource_changes[r]
	resources := [resource |
		resource := changes.address
		changes.type == "aws_ecs_task_definition"
		container := json.unmarshal(changes.change.after.container_definitions)
		regex.match(`^(.*\s+.*)+$`, container[_].name)
	]
}

deny_container_definition_name_with_spaces[msg] {
	resources := container_definition_name_with_spaces[_]
	resources != []
	msg := sprintf("Container definition contains spaces: %v", [resources])
}
