package main

main_password_invalid_chars[r] = resources {
	changes := input.resource_changes[r]
	resources := [address |
		address := changes.address
		regex.match("[/\"@]+", changes.change.after.master_password)
	]
}

deny_postgres_main_password_invalid_chars[msg] {
	address := main_password_invalid_chars[_]
	address != []
	msg := sprintf("Postgresql main password must not contain / @ or \": %v", [address])
}

main_password_too_short[r] = resources {
	changes := input.resource_changes[r]
	resources := [address |
		address := changes.address
		changes.type == "aws_rds_cluster"

		# needs to be 9 to account for the end of the string
		count(changes.change.after.master_password) < 9
	]
}

deny_postgres_main_password_too_short[msg] {
	address := main_password_too_short[_]
	address != []
	msg := sprintf("Postgresql main password > 8 characters: %v", [address])
}

main_password_reserved_words[r] = resources {
	changes := input.resource_changes[r]
	resources := [address |
		address := changes.address
		changes.type == "aws_rds_cluster"
		reserved_words[upper(changes.change.after.master_password)]
	]
}

deny_postgres_main_password_reserved[msg] {
	address := main_password_reserved_words[_]
	address != []
	msg := sprintf("Postgresql main password cannot be reserved word: %v", [address])
}
