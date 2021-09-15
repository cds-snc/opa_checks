package main

reserved_words = {
	"ALL",
	"ANALYSE",
	"ANALYZE",
	"AND",
	"ANY",
	"ARRAY",
	"AS",
	"ASC",
	"ASYMMETRIC",
	"BOTH",
	"CASE",
	"CAST",
	"CHECK",
	"COLLATE",
	"COLUMN",
	"CONSTRAINT",
	"CREATE",
	"CURRENT_CATALOG",
	"CURRENT_DATE",
	"CURRENT_ROLE",
	"CURRENT_TIME",
	"CURRENT_TIMESTAMP",
	"CURRENT_USER",
	"DEFAULT",
	"DEFERRABLE",
	"DESC",
	"DISTINCT",
	"DO",
	"ELSE",
	"END",
	"EXCEPT",
	"FALSE",
	"FETCH",
	"FOR",
	"FOREIGN",
	"FROM",
	"GRANT",
	"GROUP",
	"HAVING",
	"IN",
	"INITIALLY",
	"INTERSECT",
	"INTO",
	"LATERAL",
	"LEADING",
	"LIMIT",
	"LOCALTIME",
	"LOCALTIMESTAMP",
	"NOT",
	"NULL",
	"OFFSET",
	"ON",
	"ONLY",
	"OR",
	"ORDER",
	"PLACING",
	"PRIMARY",
	"REFERENCES",
	"RETURNING",
	"SELECT",
	"SESSION_USER",
	"SOME",
	"SYMMETRIC",
	"TABLE",
	"THEN",
	"TO",
	"TRAILING",
	"TRUE",
	"UNION",
	"UNIQUE",
	"USER",
	"USING",
	"VARIADIC",
	"WHEN",
	"WHERE",
	"WINDOW",
	"WITH",
	"AUTHORIZATION",
	"BINARY",
	"COLLATION",
	"CONCURRENTLY",
	"CROSS",
	"CURRENT_SCHEMA",
	"FREEZE",
	"FULL",
	"ILIKE",
	"INNER",
	"IS",
	"ISNULL",
	"JOIN",
	"LEFT",
	"LIKE",
	"NATURAL",
	"NOTNULL",
	"OUTER",
	"OVERLAPS",
	"RIGHT",
	"SIMILAR",
	"TABLESAMPLE",
	"VERBOSE",
}

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
