package tests

import data.main as main

test_valid_effect_deny {
	r := main.deny_invalid_effect with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_iam_policy_document",
		"change": {"after": {"statement": [{"effect": "Deny"}]}},
	}]}

	count(r) == 0
}

test_valid_effect_allow {
	r := main.deny_invalid_effect with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_iam_policy_document",
		"change": {"after": {"statement": [{"effect": "Allow"}]}},
	}]}

	count(r) == 0
}

test_invalid_effect {
	r := main.deny_invalid_effect with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_iam_policy_document",
		"change": {"after": {"statement": [{"effect": "bar"}]}},
	}]}

	r[_] == "Policy document has invalid effect: [\"foo\"]"
	count(r) == 1
}
