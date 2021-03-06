package tests

import data.main as main

test_unbalanced_quotes {
	r := main.warn_cloudwatch_log_metric_pattern with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_cloudwatch_log_metric_filter",
		"change": {"after": {"pattern": "\" foo"}},
	}]}

	count(r) == 1
	r[_] == "Cloudwatch log metric pattern is invalid: [\"foo\"]"
}

test_dissallowed_characters_outside_quotes {
	r := main.warn_cloudwatch_log_metric_pattern with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_cloudwatch_log_metric_filter",
		"change": {"after": {"pattern": "! \" foo \""}},
	}]}

	count(r) == 1
	r[_] == "Cloudwatch log metric pattern is invalid: [\"foo\"]"
}

test_consecutive_quotes {
	r := main.warn_cloudwatch_log_metric_pattern with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_cloudwatch_log_metric_filter",
		"change": {"after": {"pattern": "foo \"\" bar"}},
	}]}

	count(r) == 1
	r[_] == "Cloudwatch log metric pattern is invalid: [\"foo\"]"
}

test_original_case {
	r := main.warn_cloudwatch_log_metric_pattern with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_cloudwatch_log_metric_filter",
		"change": {"after": {"pattern": "/\"levelname\": \"ERROR\"/"}},
	}]}

	count(r) == 1
	r[_] == "Cloudwatch log metric pattern is invalid: [\"foo\"]"
}

test_dissallowed_characters_inside_quotes {
	r := main.warn_cloudwatch_log_metric_pattern with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_cloudwatch_log_metric_filter",
		"change": {"after": {"pattern": "\" !foo \""}},
	}]}

	count(r) == 0
}

test_no_dissallowed_characters {
	r := main.warn_cloudwatch_log_metric_pattern with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_cloudwatch_log_metric_filter",
		"change": {"after": {"pattern": "hello this has no disallowed characters even _"}},
	}]}

	count(r) == 0
}

test_no_pattern {
	r := main.warn_cloudwatch_log_metric_pattern with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_cloudwatch_log_metric_filter",
		"change": {"after": {}},
	}]}

	count(r) == 0
}

test_curly_braces {
	r := main.warn_cloudwatch_log_metric_pattern with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_cloudwatch_log_metric_filter",
		"change": {"after": {"pattern": "{ $.delivery.providerResponse = \"Blocked as spam by phone carrier\" }"}},
	}]}

	count(r) == 0
}

test_brackets {
	r := main.warn_cloudwatch_log_metric_pattern with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_cloudwatch_log_metric_filter",
		"change": {"after": {"pattern": "[ foo ]"}},
	}]}

	count(r) == 0
}
