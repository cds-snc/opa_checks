package tests

import data.main as main

test_no_trailing_commas_in_container_definition {
	r := main.deny_container_definition_template_with_trailing_comma with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_ecs_task_definition",
		"change": {"after": {"container_definitions": "[{\"name\": \"fooBar\"}]"}},
	}]}

	count(r) == 0
}

test_trailing_commas_after_curl_bracket_in_container_definition {
	r := main.deny_container_definition_template_with_trailing_comma with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_ecs_task_definition",
		"change": {"after": {"container_definitions": "[{\"name\": \"foo bar\"},]"}},
	}]}

	count(r) == 1
	r[_] == "Container definition contains trailing commas: [\"foo\"]"
}

test_trailing_commas_after_square_bracket_in_container_definition {
	r := main.deny_container_definition_template_with_trailing_comma with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_ecs_task_definition",
		"change": {"after": {"container_definitions": "[{\"name\": \"foo bar\"}],"}},
	}]}

	count(r) == 1
	r[_] == "Container definition contains trailing commas: [\"foo\"]"
}

test_trailing_commas_after_quote_in_container_definition {
	r := main.deny_container_definition_template_with_trailing_comma with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_ecs_task_definition",
		"change": {"after": {"container_definitions": "[{\"name\": \"foo bar\",}]"}},
	}]}

	count(r) == 1
	r[_] == "Container definition contains trailing commas: [\"foo\"]"
}

test_multiple_trailing_commas_in_container_definition {
	r := main.deny_container_definition_template_with_trailing_comma with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_ecs_task_definition",
		"change": {"after": {"container_definitions": "[{\"name\": \"foo bar baz\"},],"}},
	}]}

	count(r) == 1
	r[_] == "Container definition contains trailing commas: [\"foo\"]"
}
