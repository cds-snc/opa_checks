package tests

import data.main as main

test_username_not_reserved {
	r := main.deny_postgres_main_username_reserved with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_rds_cluster",
		"change": {"after": {"master_username": "bar"}},
	}]}

	count(r) == 0
}

test_username_reserved {
	r := main.deny_postgres_main_username_reserved with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_rds_cluster",
		"change": {"after": {"master_username": "asYmmetric"}},
	}]}

	count(r) == 1
	r[_] == "Postgresql main username cannot be reserved word: [\"foo\"]"
}

test_username_long {
	r := main.deny_postgres_main_username_too_long with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_rds_cluster",
		"change": {"after": {"master_username": "1234567890123456789012345678901234567890123456789012345678901234"}},
	}]}

	count(r) == 1
	r[_] == "Postgresql main username > 63 characters: [\"foo\"]"
}

test_username_valid_length {
	r := main.deny_postgres_main_username_too_long with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_rds_cluster",
		"change": {"after": {"master_username": "1234567890123456"}},
	}]}

	count(r) == 0
}

test_username_invalid_start {
	r := main.deny_postgres_main_username_alpha with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_rds_cluster",
		"change": {"after": {"master_username": "1"}},
	}]}

	count(r) == 1
	r[_] == "Postgresql main username must start with a letter: [\"foo\"]"
}

test_username_valid_start {
	r := main.deny_postgres_main_username_alpha with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_rds_cluster",
		"change": {"after": {"master_username": "a"}},
	}]}

	count(r) == 0
}
