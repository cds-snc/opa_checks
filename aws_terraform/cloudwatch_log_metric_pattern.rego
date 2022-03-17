package main

invalid_pattern(parts) {
	# Unbalanced quotes
	count(parts) % 2 == 0
}

invalid_pattern(parts) {
	# Invalid characters outside of quotes
	indexes := [idx |
		x := parts[i]
		i % 2 == 0
		idx := i
		regex.match(`[^[:alnum:],_,\s]`, x)
	]

	count(indexes) > 0
}

invalid_pattern(parts) {
	# Double quotes
	pattern := concat("\"", parts)
	regex.match(`\"\"`, pattern)
}

cloudwatch_log_metric_pattern[r] = resources {
	changes := input.resource_changes[r]
	resources := [resource |
		resource := changes.address
		changes.type == "aws_cloudwatch_log_metric_filter"

		pattern := changes.change.after.pattern
		pattern = replace(pattern, "\\\"", "＂")

		regex.match(`[^[:alnum:],_,\s]`, pattern)
		not regex.match(`(^{.+}$|^\[.+\]$)`, pattern)
		parts := split(pattern, "\"")
		invalid_pattern(parts)
	]
}

warn_cloudwatch_log_metric_pattern[msg] {
	resources := cloudwatch_log_metric_pattern[_]
	resources != []
	msg := sprintf("Cloudwatch log metric pattern is invalid: %v", [resources])
}
