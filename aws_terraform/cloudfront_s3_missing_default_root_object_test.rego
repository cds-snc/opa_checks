package tests

import data.main as main

# S3-backed distribution with a default_root_object set -> no violation
test_s3_origin_with_default_root_object {
	r := main.deny_cloudfront_s3_missing_default_root_object with input as {"resource_changes": [{
		"type": "aws_cloudfront_distribution",
		"address": "aws_cloudfront_distribution.example",
		"change": {"after": {
			"default_root_object": "index.html",
			"origin": [{"s3_origin_config": [{"origin_access_identity": "origin-access-identity/cloudfront/EXAMPLE"}]}],
		}},
	}]}

	count(r) == 0
}

# S3-backed distribution missing default_root_object -> violation
test_s3_origin_missing_default_root_object {
	r := main.deny_cloudfront_s3_missing_default_root_object with input as {"resource_changes": [{
		"type": "aws_cloudfront_distribution",
		"address": "aws_cloudfront_distribution.example",
		"change": {"after": {"origin": [{"s3_origin_config": [{"origin_access_identity": "origin-access-identity/cloudfront/EXAMPLE"}]}]}},
	}]}

	count(r) == 1
	r[_] == "CloudFront distribution 'aws_cloudfront_distribution.example' is served by an S3 bucket and must set a default_root_object to avoid exposing the contents of the distribution."
}

# S3-backed distribution with an empty default_root_object -> violation
test_s3_origin_empty_default_root_object {
	r := main.deny_cloudfront_s3_missing_default_root_object with input as {"resource_changes": [{
		"type": "aws_cloudfront_distribution",
		"address": "aws_cloudfront_distribution.example",
		"change": {"after": {
			"default_root_object": "",
			"origin": [{"s3_origin_config": [{"origin_access_identity": "origin-access-identity/cloudfront/EXAMPLE"}]}],
		}},
	}]}

	count(r) == 1
}

# Distribution served by a custom origin (e.g. load balancer) missing default_root_object -> no violation
test_custom_origin_missing_default_root_object {
	r := main.deny_cloudfront_s3_missing_default_root_object with input as {"resource_changes": [{
		"type": "aws_cloudfront_distribution",
		"address": "aws_cloudfront_distribution.example",
		"change": {"after": {"origin": [{"custom_origin_config": [{"origin_protocol_policy": "https-only"}]}]}},
	}]}

	count(r) == 0
}

# Distribution fronting a Lambda function URL (custom origin) missing default_root_object -> no violation
test_lambda_origin_missing_default_root_object {
	r := main.deny_cloudfront_s3_missing_default_root_object with input as {"resource_changes": [{
		"type": "aws_cloudfront_distribution",
		"address": "aws_cloudfront_distribution.example",
		"change": {"after": {"origin": [{
			"domain_name": "example.lambda-url.us-east-1.on.aws",
			"custom_origin_config": [{"origin_protocol_policy": "https-only"}],
		}]}},
	}]}

	count(r) == 0
}
