package main

waf_duplicate_priority[r] = resources {
	changes := input.resource_changes[r]
	resources := [resource |
		resource := changes.address
		changes.type == "aws_wafv2_web_acl"
		priorities := {priority |
			priority := changes.change.after.rule[_].priority
		}

		count(priorities) != count(changes.change.after.rule)
	]
}

deny_waf_duplicate_priority[msg] {
	resources := waf_duplicate_priority[_]
	resources != []
	msg := sprintf("WAF rules have duplicate priorities: %v", [resources])
}
