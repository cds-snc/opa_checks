package main

import input as tfplan

# Any KMS key (customer managed or the AWS managed alias/aws/sns) satisfies the check.
# A key created in the same plan is unknown until apply, so it is treated as set.
sns_topic_encrypted(resource) {
	key := object.get(resource.change.after, "kms_master_key_id", "")
	key != null
	key != ""
}

sns_topic_encrypted(resource) {
	resource.change.after_unknown.kms_master_key_id == true
}

deny_sns_topic_unencrypted[msg] {
	resource := tfplan.resource_changes[_]
	resource.type == "aws_sns_topic"

	# after is null when the topic is being destroyed
	resource.change.after != null
	not sns_topic_encrypted(resource)
	msg = sprintf("SNS topic '%s' must be encrypted by setting kms_master_key_id to a customer managed or AWS managed KMS key.", [resource.address])
}
