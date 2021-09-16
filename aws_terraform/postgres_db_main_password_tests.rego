package tests

import data.main as main

test_password_not_reserved {
	r := main.deny_postgres_main_password_reserved with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_rds_cluster",
		"change": {"after": {"master_password": "bar"}},
	}]}

	count(r) == 0
}

test_password_reserved {
	r := main.deny_postgres_main_password_reserved with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_rds_cluster",
		"change": {"after": {"master_password": "asYmmetric"}},
	}]}

	count(r) == 1
	r[_] == "Postgresql main password cannot be reserved word: [\"foo\"]"
}

test_password_too_short {
	r := main.deny_postgres_main_password_too_short with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_rds_cluster",
		"change": {"after": {"master_password": "12345678"}},
	}]}

	count(r) == 1
	r[_] == "Postgresql main password > 8 characters: [\"foo\"]"
}

test_password_valid_length {
	r := main.deny_postgres_main_password_too_short with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_rds_cluster",
		"change": {"after": {"master_password": "123456789"}},
	}]}

	count(r) == 0
}

test_password_invalid_char_at {
	r := main.deny_postgres_main_password_invalid_chars with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_rds_cluster",
		"change": {"after": {"master_password": "@"}},
	}]}

	count(r) == 1
	r[_] == "Postgresql main password must not contain / @ or \": [\"foo\"]"
}

test_password_invalid_char_slash {
	r := main.deny_postgres_main_password_invalid_chars with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_rds_cluster",
		"change": {"after": {"master_password": "/"}},
	}]}

	count(r) == 1
	r[_] == "Postgresql main password must not contain / @ or \": [\"foo\"]"
}

test_password_invalid_char_quotation_mark {
	r := main.deny_postgres_main_password_invalid_chars with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_rds_cluster",
		"change": {"after": {"master_password": "\""}},
	}]}

	count(r) == 1
	r[_] == "Postgresql main password must not contain / @ or \": [\"foo\"]"
}

test_password_valid_char {
	r := main.deny_postgres_main_password_invalid_chars with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_rds_cluster",
		"change": {"after": {"master_password": "asdfoasd"}},
	}]}

	count(r) == 0
}
