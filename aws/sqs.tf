resource "aws_sqs_queue" "trigger_queue" {
  name_prefix = "macie_trigger_queue"
}