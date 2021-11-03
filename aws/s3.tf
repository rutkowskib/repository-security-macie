resource "aws_s3_bucket" "code_bucket" {
  bucket_prefix = "repository-security-macie"
  acl    = "private"
}