package tests

import data.main as main

test_database_uses_reserved_name {
	r := main.deny_postgres_name with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_rds_cluster",
		"change": {"after": {"database_name": "verbose"}},
	}]}

	r[_] == "Postgresql Database cannot use a reserved word as a name: [\"foo\"]"
	count(r) == 1
}

test_database_has_valid_name {
	r := main.deny_postgres_name with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_rds_cluster",
		"change": {"after": {"database_name": "valid"}},
	}]}

	count(r) == 0
}

test_passes_with_no_database {
	r := main.deny_postgres_name with input as {}
	count(r) == 0
}
