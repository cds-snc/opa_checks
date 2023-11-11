resource "aws_ssm_parameter" "foo" {
  name  = "aws_iam_policy"
  type  = "String"
  value = "bar"
}

resource "aws_ssm_parameter" "bar" {
  name  = "ssm_param_name"
  type  = "String"
  value = "foo"
}