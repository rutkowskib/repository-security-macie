resource "aws_s3_bucket" "code_bucket" {
  bucket_prefix = "repository-security-macie"
  acl    = "private"
}

data "aws_iam_account_alias" "account" {}

resource "aws_macie2_account" "macie_account" {}

resource "aws_macie2_custom_data_identifier" "stripe_identifier" {
  name                   = "Stripe secret"
  regex                  = "STRIPE_SECRET"

  depends_on = [ aws_macie2_account.macie_account ]
}

resource "aws_macie2_classification_job" "classification" {
  job_type = "ONE_TIME"
  name     = "repo_security"
  s3_job_definition {
    bucket_definitions {
      account_id = aws_macie2_account.macie_account.id
      buckets    = [ aws_s3_bucket.code_bucket.bucket ]
    }
  }
  depends_on = [ aws_macie2_account.macie_account ]
}