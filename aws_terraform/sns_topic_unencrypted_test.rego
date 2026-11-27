package tests

import data.main as main

# Customer managed key -> no violation
test_sns_topic_customer_managed_key {
	r := main.deny_sns_topic_unencrypted with input as {"resource_changes": [{
		"type": "aws_sns_topic",
		"address": "aws_sns_topic.example",
		"change": {"after": {"kms_master_key_id": "arn:aws:kms:us-east-1:123456789012:key/1234abcd-12ab-34cd-56ef-1234567890ab"}},
	}]}

	count(r) == 0
}

# AWS managed key -> no violation
test_sns_topic_aws_managed_key {
	r := main.deny_sns_topic_unencrypted with input as {"resource_changes": [{
		"type": "aws_sns_topic",
		"address": "aws_sns_topic.example",
		"change": {"after": {"kms_master_key_id": "alias/aws/sns"}},
	}]}

	count(r) == 0
}

# Key created in the same plan (unknown until apply) -> no violation
test_sns_topic_key_known_after_apply {
	r := main.deny_sns_topic_unencrypted with input as {"resource_changes": [{
		"type": "aws_sns_topic",
		"address": "aws_sns_topic.example",
		"change": {
			"after": {},
			"after_unknown": {"kms_master_key_id": true},
		},
	}]}

	count(r) == 0
}

# No kms_master_key_id -> violation
test_sns_topic_missing_key {
	r := main.deny_sns_topic_unencrypted with input as {"resource_changes": [{
		"type": "aws_sns_topic",
		"address": "aws_sns_topic.example",
		"change": {"after": {"name": "example"}},
	}]}

	count(r) == 1
	r[_] == "SNS topic 'aws_sns_topic.example' must be encrypted by setting kms_master_key_id to a customer managed or AWS managed KMS key."
}

# Null kms_master_key_id -> violation
test_sns_topic_null_key {
	r := main.deny_sns_topic_unencrypted with input as {"resource_changes": [{
		"type": "aws_sns_topic",
		"address": "aws_sns_topic.example",
		"change": {"after": {"kms_master_key_id": null}},
	}]}

	count(r) == 1
}

# Empty kms_master_key_id -> violation
test_sns_topic_empty_key {
	r := main.deny_sns_topic_unencrypted with input as {"resource_changes": [{
		"type": "aws_sns_topic",
		"address": "aws_sns_topic.example",
		"change": {"after": {"kms_master_key_id": ""}},
	}]}

	count(r) == 1
}

# Other resource types are ignored
test_non_sns_resource_ignored {
	r := main.deny_sns_topic_unencrypted with input as {"resource_changes": [{
		"type": "aws_sqs_queue",
		"address": "aws_sqs_queue.example",
		"change": {"after": {}},
	}]}

	count(r) == 0
}

# Topic being destroyed (after is null) -> no violation
test_sns_topic_being_deleted {
	r := main.deny_sns_topic_unencrypted with input as {"resource_changes": [{
		"type": "aws_sns_topic",
		"address": "aws_sns_topic.example",
		"change": {
			"actions": ["delete"],
			"before": {"name": "example"},
			"after": null,
			"after_unknown": {},
		},
	}]}

	count(r) == 0
}

# Only the unencrypted topic is reported when several are present
test_sns_topic_mixed {
	r := main.deny_sns_topic_unencrypted with input as {"resource_changes": [
		{
			"type": "aws_sns_topic",
			"address": "aws_sns_topic.good",
			"change": {"after": {"kms_master_key_id": "alias/aws/sns"}},
		},
		{
			"type": "aws_sns_topic",
			"address": "aws_sns_topic.bad",
			"change": {"after": {"name": "bad"}},
		},
	]}

	count(r) == 1
	r[_] == "SNS topic 'aws_sns_topic.bad' must be encrypted by setting kms_master_key_id to a customer managed or AWS managed KMS key."
}
