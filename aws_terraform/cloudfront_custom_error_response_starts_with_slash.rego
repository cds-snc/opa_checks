package main

import input as tfplan

# Violation message
deny_cloudfront_response_page_path_starts_without_slash[msg] {
	resource := tfplan.resource_changes[_]
	resource.type == "aws_cloudfront_distribution"
	custom_error_response := resource.change.after.custom_error_response[_]
	response_path := custom_error_response.response_page_path
	not startswith(response_path, "/")
	msg = sprintf("Cloudfront custom error response's response_page_path must start with a '/'. Found: %s", [response_path])
}
