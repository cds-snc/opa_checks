package tests

import data.main as main

test_missing_uri_on_aws_proxy {
	r := main.deny_api_gateway_integration_uri with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_api_gateway_integration",
		"change": {"after": {
			"type": "AWS_PROXY",
			"uri": null,
		}},
	}]}

	count(r) == 1
	r[_] == "API gateway integration has invalid uri: [\"foo\"]"
}

test_malformed_uri_on_aws_proxy {
	r := main.deny_api_gateway_integration_uri with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_api_gateway_integration",
		"change": {"after": {
			"type": "AWS_PROXY",
			"uri": "fooBar",
		}},
	}]}

	count(r) == 1
	r[_] == "API gateway integration has invalid uri: [\"foo\"]"
}

test_correct_uri_on_aws_proxy {
	r := main.deny_api_gateway_integration_uri with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_api_gateway_integration",
		"change": {"after": {
			"type": "AWS_PROXY",
			"uri": "arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:012345678901:function:my-func/invocations",
		}},
	}]}

	count(r) == 0
}

test_missing_uri_on_http_proxy {
	r := main.deny_api_gateway_integration_uri with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_api_gateway_integration",
		"change": {"after": {
			"type": "HTTP_PROXY",
			"uri": null,
		}},
	}]}

	count(r) == 1
	r[_] == "API gateway integration has invalid uri: [\"foo\"]"
}

test_malformed_uri_on_http_proxy {
	r := main.deny_api_gateway_integration_uri with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_api_gateway_integration",
		"change": {"after": {
			"type": "HTTP_PROXY",
			"uri": "arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:012345678901:function:my-func/invocations",
		}},
	}]}

	count(r) == 1
	r[_] == "API gateway integration has invalid uri: [\"foo\"]"
}

test_correct_uri_on_http_proxy {
	r := main.deny_api_gateway_integration_uri with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_api_gateway_integration",
		"change": {"after": {
			"type": "HTTP_PROXY",
			"uri": "https://www.ietf.org/rfc/rfc2396.txt",
		}},
	}]}

	count(r) == 0
}
