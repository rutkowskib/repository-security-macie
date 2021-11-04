data "github_repository" "repo" {
  full_name = var.repository
}

locals {
  variables = {
    AWS_S3_BUCKET = aws_s3_bucket.code_bucket.bucket
    AWS_ACCESS_KEY_ID = aws_iam_access_key.user_key.id
    AWS_SECRET_ACCESS_KEY = aws_iam_access_key.user_key.secret
    AWS_REGION = var.aws_region
    FUNCTION_NAME = aws_lambda_function.trigger_macie.function_name
  }
}

resource "github_actions_secret" "secret" {
  for_each = local.variables
  repository = data.github_repository.repo.id
  secret_name = each.key
  plaintext_value = each.value
}