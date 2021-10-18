resource "aws_iam_user" "github_user" {
  name = "github_upload_code_user"
}

resource "aws_iam_user_policy" "user_policy" {
  name_prefix = "github_upload_code_user"
  user = aws_iam_user.github_user.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*",
                "s3:PutObject*"
            ],
            "Resource": "${aws_s3_bucket.code_bucket.arn}/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": "${aws_s3_bucket.code_bucket.arn}"
        },
        {
            "Effect": "Allow",
            "Action": [
                "sqs:SendMessage"
            ],
            "Resource": "${aws_sqs_queue.trigger_queue.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_access_key" "user_key" {
  user = aws_iam_user.github_user.name
}