package tests

import data.main as main

test_scoped_service_principals {
	r := main.warn_policy_documents_with_service_principals_and_no_account_conditions with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_iam_policy",
		"change": {"after": {"policy": "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Sid\":\"\",\"Effect\":\"Allow\",\"Action\":\"kms:*\",\"Principal\":{\"Service\":\"s3.amazonaws.com\"},\"Condition\":{\"StringLike\":{\"AWS:SourceAccount\":\"account\"}}}]}"}},
	}]}

	count(r) == 0
}

test_unscoped_service_principals {
	r := main.warn_policy_documents_with_service_principals_and_no_account_conditions with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_iam_policy",
		"change": {"after": {"policy": "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Sid\":\"\",\"Effect\":\"Allow\",\"Action\":\"kms:*\",\"Principal\":{\"Service\":\"s3.amazonaws.com\"}}]}"}},
	}]}

	count(r) == 1
	r[_] == "IAM policies with service principals and no account condition: [\"foo\"]"
}

test_unscoped_service_principals_sts_type {
	r := main.warn_policy_documents_with_service_principals_and_no_account_conditions with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_iam_policy",
		"change": {"after": {"policy": "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Sid\":\"\",\"Effect\":\"Allow\",\"Action\":\"sts:AssumeRole\",\"Principal\":{\"Service\":\"s3.amazonaws.com\"}}]}"}},
	}]}

	count(r) == 0
}
