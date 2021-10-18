output "bucket_name" {
  value = aws_s3_bucket.code_bucket.bucket
}

output "user_access_key_id" {
  value = aws_iam_access_key.user_key.id
}

output "user_secret_access_key" {
  value = aws_iam_access_key.user_key.secret
  sensitive = true
}

output "queue_endpoint" {
  value = aws_sqs_queue.trigger_queue.id
}