package tests

import data.main as main

test_no_spaces_in_container_definition_name {
	r := main.deny_container_definition_name_with_spaces with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_ecs_task_definition",
		"change": {"after": {"container_definitions": "[{\"name\": \"fooBar\"}]"}},
	}]}

	count(r) == 0
}

test_spaces_in_container_definition_name {
	r := main.deny_container_definition_name_with_spaces with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_ecs_task_definition",
		"change": {"after": {"container_definitions": "[{\"name\": \"foo bar\"}]"}},
	}]}

	count(r) == 1
	r[_] == "Container definition contains spaces: [\"foo\"]"
}

test_multiple_spaces_in_container_definition_name {
	r := main.deny_container_definition_name_with_spaces with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_ecs_task_definition",
		"change": {"after": {"container_definitions": "[{\"name\": \"foo bar baz\"}]"}},
	}]}

	count(r) == 1
	r[_] == "Container definition contains spaces: [\"foo\"]"
}

test_empty_spaces_in_container_definition_name {
	r := main.deny_container_definition_name_with_spaces with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_ecs_task_definition",
		"change": {"after": {"container_definitions": "[{\"name\": \" \"}]"}},
	}]}

	count(r) == 1
	r[_] == "Container definition contains spaces: [\"foo\"]"
}

test_multiple_container_definition_name {
	r := main.deny_container_definition_name_with_spaces with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_ecs_task_definition",
		"change": {"after": {"container_definitions": "[{\"name\": \" \"}, {\"name\": \"fooBar\"}]"}},
	}]}

	count(r) == 1
	r[_] == "Container definition contains spaces: [\"foo\"]"
}
