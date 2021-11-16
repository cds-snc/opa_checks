package tests

import data.main as main

test_has_common_tags {
	r := main.warn_tags with input as {"resource_changes": [{
		"address": "foo",
		"change": {"after": {"tags": {
			"CostCentre": "test",
			"Terraform": "true",
		}}},
	}]}

	count(r) == 0
}

test_has_default_tags_set {
	r := main.warn_tags with input as {"configuration": {"provider_config": {"aws": {"expressions": {"default_tags": [{"tags": {"ConstantValue": {
		"Terraform": "true",
		"ConstCentre": "test",
	}}}]}}}}}

	count(r) == 0
}

test_missing_common_tags {
	r := main.warn_tags with input as {"resource_changes": [{
		"address": "foo",
		"change": {"after": {"tags": null}},
	}]}

	count(r) == 1
	r[_] == "Missing Common Tags: [\"foo\"]"
}

test_missing_CostCentre_tag {
	r := main.warn_tags with input as {"resource_changes": [{
		"address": "foo",
		"change": {"after": {"tags": {"Terraform": "true"}}},
	}]}

	count(r) == 1
	r[_] == "Missing Common Tags: [\"foo\"]"
}

test_missing_Terraform_tag {
	r := main.warn_tags with input as {"resource_changes": [{
		"address": "foo",
		"change": {"after": {"tags": {"CostCentre": "foo"}}},
	}]}

	count(r) == 1
	r[_] == "Missing Common Tags: [\"foo\"]"
}
