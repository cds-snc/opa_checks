resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "test_lambda_with_good_runtime" {
  filename      = "mocks/test.zip"
  function_name = "test_lambda_with_good_runtime"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.test"

  source_code_hash = filebase64sha256("mocks/test.zip")

  runtime = "nodejs12.x"
}

resource "aws_lambda_function" "test_lambda_with_bad_runtime" {
  filename      = "mocks/test.zip"
  function_name = "test_lambda_with_bad_runtime"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.test"

  source_code_hash = filebase64sha256("mocks/test.zip")

  runtime = "nodejs10.x"
}

resource "aws_iam_role" "iam_for_lambda_with_eni" {
  name = "iam_for_lambda_with_eni"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.iam_for_lambda_with_eni.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_lambda_function" "test_vpc_lambda_with_eni_policy" {
  filename      = "mocks/test.zip"
  function_name = "test_vpc_lambda_with_eni_policy"
  role          = aws_iam_role.iam_for_lambda_with_eni.arn
  handler       = "index.test"

  source_code_hash = filebase64sha256("mocks/test.zip")

  runtime = "nodejs12.x"

  vpc_config {
    security_group_ids = []
    subnet_ids         = []
  }
}

resource "aws_lambda_function" "test_vpc_lambda_with_missing_eni_policy" {
  filename      = "mocks/test.zip"
  function_name = "test_vpc_lambda_with_missing_eni_policy"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.test"

  source_code_hash = filebase64sha256("mocks/test.zip")

  runtime = "nodejs12.x"

  vpc_config {
    security_group_ids = []
    subnet_ids         = []
  }
}