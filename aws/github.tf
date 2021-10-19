data "github_repository" "repo" {
  full_name = var.repository
}

locals {
  variables = {
    AWS_S3_BUCKET = aws_s3_bucket.code_bucket.bucket
    AWS_ACCESS_KEY_ID = aws_iam_access_key.user_key.id
    AWS_SECRET_ACCESS_KEY = aws_iam_access_key.user_key.secret
    SQS_URL = aws_sqs_queue.trigger_queue.id
  }
}

resource "github_actions_secret" "secret" {
  for_each = local.variables
  repository = data.github_repository.repo.id
  secret_name = each.key
  plaintext_value = each.value
}