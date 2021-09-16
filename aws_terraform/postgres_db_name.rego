package main


databases_with_invalid_names[r] = resources {
	some r

	changes := input.resource_changes[r]
	resources := [address |
		address := changes.address
		changes.type == "aws_rds_cluster"
		reserved_words[upper(changes.change.after.database_name)]
	]
}

deny_postgres_name[msg] {
	address := databases_with_invalid_names[_]
	address != []
	msg := sprintf("Postgresql Database cannot use a reserved word as a name: %v", [address])
}
