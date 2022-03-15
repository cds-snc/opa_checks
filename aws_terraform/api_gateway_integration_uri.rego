package main

aws_types = {
	"AWS",
	"AWS_PROXY",
}

http_types = {
	"HTTP",
	"HTTP_PROXY",
}

api_gateway_integration_uri_with_aws_type[r] = resources {
	changes := input.resource_changes[r]
	resources := [resource |
		resource := changes.address
		changes.type == "aws_api_gateway_integration"
		aws_types[changes.change.after.type]
		not regex.match(`^arn:aws:apigateway:[[:alnum:],-]+:[[:alnum:],-]+:[[:alnum:],-]+/.+$`, changes.change.after.uri)
	]
}

api_gateway_integration_uri_with_http_type[r] = resources {
	changes := input.resource_changes[r]
	resources := [resource |
		resource := changes.address
		changes.type == "aws_api_gateway_integration"
		http_types[changes.change.after.type]
		not regex.match(`^(http|https)://.+$`, changes.change.after.uri)
	]
}

deny_api_gateway_integration_uri[msg] {
	resources := array.concat(api_gateway_integration_uri_with_aws_type[_], api_gateway_integration_uri_with_http_type[_])
	resources != []
	msg := sprintf("API gateway integration has invalid uri: %v", [resources])
}
