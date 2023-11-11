package tests

import data.main as main

# Test data where response_page_path starts with '/'
test_response_page_path_starts_with_slash {
	r := main.deny_cloudfront_response_page_path_starts_without_slash with input as {"resource_changes": [{
		"type": "aws_cloudfront_distribution",
		"change": {"after": {"custom_error_response": [{"response_page_path": "/index.html"}]}},
	}]}

	count(r) == 0
}

# Test data where response_page_path does not start with '/'
test_response_page_path_not_starting_with_slash {
	r := main.deny_cloudfront_response_page_path_starts_without_slash with input as {"resource_changes": [{
		"type": "aws_cloudfront_distribution",
		"change": {"after": {"custom_error_response": [{"response_page_path": "index.html"}]}},
	}]}

	count(r) == 1
	r[_] == "Cloudfront custom error response's response_page_path must start with a '/'. Found: index.html"
}

# Test data where custom_error_response does not exist
test_response_page_path_starts_with_slash {
	r := main.deny_cloudfront_response_page_path_starts_without_slash with input as {"resource_changes": [{
		"type": "aws_cloudfront_distribution",
		"change": {"after": {}},
	}]}

	count(r) == 0
}
