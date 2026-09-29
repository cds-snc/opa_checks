package main

import input as tfplan

# Deny CloudFront distributions backed by an S3 bucket that do not set a default_root_object.
# S3-backed origins are identified by the presence of s3_origin_config on an origin block.
deny_cloudfront_s3_missing_default_root_object[msg] {
	resource := tfplan.resource_changes[_]
	resource.type == "aws_cloudfront_distribution"

	# Origin is served by an S3 bucket
	resource.change.after.origin[_].s3_origin_config

	# default_root_object is missing or empty
	root_object := object.get(resource.change.after, "default_root_object", "")
	root_object == ""

	msg = sprintf("CloudFront distribution '%s' is served by an S3 bucket and must set a default_root_object to avoid exposing the contents of the distribution.", [resource.address])
}
