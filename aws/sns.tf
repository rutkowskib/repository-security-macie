resource "aws_cloudwatch_event_rule" "macie_finding" {
  name        = "macie_finding"

  event_pattern = <<EOF
{
  "source": ["aws.macie"],
  "detail-type": ["Macie Finding"]
}
EOF
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.macie_finding.name
  arn       = aws_sns_topic.macie_topic.arn
}

resource "aws_sns_topic" "macie_topic" {
  name = "macie_findings"
}

resource "aws_sns_topic_policy" "policy" {
  arn    = aws_sns_topic.macie_topic.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = [ "SNS:Publish" ]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [ aws_sns_topic.macie_topic.arn ]
  }
}

resource "aws_sns_topic_subscription" "email_topic_subscription" {
  topic_arn = aws_sns_topic.macie_topic.arn
  protocol  = "email"
  endpoint  = var.email
}