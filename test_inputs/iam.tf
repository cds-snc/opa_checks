data "aws_iam_policy_document" "lambda_service_principal" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "AssumeRole_passes" {
  name        = "AssumeRole_passes"
  path        = "/"
  description = "Assume roles don't need a account condition"
  policy = data.aws_iam_policy_document.lambda_service_principal.json
  tags = {
    CostCentre = "tf-acc-test-iam-policy"
    Terraform = "test"
  }
}

data "aws_iam_policy_document" "s3_service_principal" {
  statement {
    effect = "Allow"

    actions = ["kms:*"]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "s3_service_principal_fails" {
  name        = "Service_principal_fails"
  path        = "/"
  description = "Fails without an account condition"
  policy = data.aws_iam_policy_document.s3_service_principal.json
  tags = {
    CostCentre = "tf-acc-test-iam-policy"
    Terraform = "test"
  }
}

data "aws_iam_policy_document" "s3_service_principal_with_account" {
  statement {
    effect = "Allow"

    actions = ["kms:*"]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "AWS:SourceAccount"

      values = [
        "account"
      ]
    }
  }
}

resource "aws_iam_policy" "s3_service_principal_passes" {
  name        = "Service_principal_passes"
  path        = "/"
  description = "Passes with an account condition"
  policy = data.aws_iam_policy_document.s3_service_principal_with_account.json
  tags = {
    CostCentre = "tf-acc-test-iam-policy"
    Terraform = "test"
  }
}

data "aws_iam_policy_document" "not_a_service_prinicpal" {
  statement {
    effect = "Allow"

    actions = ["kms:*"]

    principals {
      type        = "AWS"
      identifiers = ["123456789012","555555555555" ]
    }
  }
}

resource "aws_iam_policy" "not_a_service_prinicpal_passes" {
  name        = "not_a_service_prinicpal_passes"
  path        = "/"
  description = "Passes without a service principal"
  policy = data.aws_iam_policy_document.not_a_service_prinicpal.json
  tags = {
    CostCentre = "tf-acc-test-iam-policy"
    Terraform = "test"
  }
}