locals {
  input_path = "${path.module}/../lambda"
  output_path = "${path.module}/lambda.zip"
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = local.input_path
  output_path = local.output_path
}

resource "aws_iam_role" "lambda_role" {
  name_prefix = "macie_lambda_role"

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

resource "aws_iam_policy" "macie_policy" {
  name_prefix = "create_macie_job_policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "macie2:CreateClassificationJob",
      "Resource": "arn:aws:macie2:*:${aws_macie2_account.macie_account.id}:classification-job/*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_macie" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.macie_policy.arn
}

resource "aws_lambda_function" "trigger_macie" {
  filename = local.output_path
  function_name = "trigger_macie"
  handler = "index.handler"
  role = aws_iam_role.lambda_role.arn
  runtime = "nodejs12.x"

  environment {
    variables = {
      ACCOUNT_ID = aws_macie2_account.macie_account.id
      BUCKET_NAME = aws_s3_bucket.code_bucket.bucket
      DATA_IDENTIFIER_ID = aws_macie2_custom_data_identifier.stripe_identifier.id
    }
  }

  depends_on = [ data.archive_file.lambda_zip ]
}