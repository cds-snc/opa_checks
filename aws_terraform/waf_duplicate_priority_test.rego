package tests

import data.main as main

test_waf_no_duplicate_priorities {
	r := main.deny_waf_duplicate_priority with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_wafv2_web_acl",
		"change": {"after": {"rule": [{"priority": 1}, {"priority": 2}]}},
	}]}
}

test_waf_duplicate_priorities {
	r := main.deny_waf_duplicate_priority with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_wafv2_web_acl",
		"change": {"after": {"rule": [{"priority": 1}, {"priority": 1}]}},
	}]}

	count(r) == 1
	r[_] == "WAF rules have duplicate priorities: [\"foo\"]"
}

test_waf_duplicate_priorities_longer {
	r := main.deny_waf_duplicate_priority with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_wafv2_web_acl",
		"change": {"after": {"rule": [{"priority": 1}, {"priority": 1}, {"priority": 2}, {"priority": 3}]}},
	}]}

	count(r) == 1
	r[_] == "WAF rules have duplicate priorities: [\"foo\"]"
}

test_waf_no_rules {
	r := main.deny_waf_duplicate_priority with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_wafv2_web_acl",
		"change": {"after": {"rule": []}},
	}]}
}
