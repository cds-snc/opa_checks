package main

main_username_invalid_first_char[r] = resources {
	changes := input.resource_changes[r]
	resources := [address |
		address := changes.address
		not regex.match("^[A-Za-z]+", changes.change.after.master_username)
	]
}

deny_postgres_main_username_alpha[msg] {
	address := main_username_invalid_first_char[_]
	address != []
	msg := sprintf("Postgresql main username must start with a letter: %v", [address])
}

main_username_too_long[r] = resources {
	changes := input.resource_changes[r]
	resources := [address |
		address := changes.address
		changes.type == "aws_rds_cluster"

		# needs to be 64 to account for end of the string
		count(changes.change.after.master_username) >= 64
	]
}

deny_postgres_main_username_too_long[msg] {
	address := main_username_too_long[_]
	address != []
	msg := sprintf("Postgresql main username > 63 characters: %v", [address])
}

main_username_reserved_words[r] = resources {
	changes := input.resource_changes[r]
	resources := [address |
		address := changes.address
		changes.type == "aws_rds_cluster"
		reserved_words[upper(changes.change.after.master_username)]
	]
}

deny_postgres_main_username_reserved[msg] {
	address := main_username_reserved_words[_]
	address != []
	msg := sprintf("Postgresql main username cannot be reserved word: %v", [address])
}
