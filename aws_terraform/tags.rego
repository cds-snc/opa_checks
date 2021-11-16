package main

# Check to see if the resource is tagged with the required tags. 
# This is heavily opinionated and doesn't really matter so it should only be a warning.

minimum_tags = {
	"CostCentre",
	"Terraform",
}

tags_contain_proper_keys(tags) {
	keys := {key | tags[key]}
	leftover := minimum_tags - keys
	leftover == set()
}

default_tags_matching_required = default_tags {
	default_tags := [tag |
		tag := input.configuration.provider_config.aws.expressions.default_tags[_].tags.constant_value
	]
}

tags_contain_minimum_set[i] = resources {
	tags := input.resource_changes[i].change.after.tags
	resources := [resource |
		resource := input.resource_changes[i].address
		not tags_contain_proper_keys(tags)
	]
}

warn_tags[msg] {
	resources := tags_contain_minimum_set[_]
	default_tags := default_tags_matching_required
	not tags_contain_proper_keys(default_tags)
	resources != []
	msg := sprintf("Missing Common Tags: %v", [resources])
}
