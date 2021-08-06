provider "aws" {
  region = "eu-west-1"
}

resource "aws_sqs_queue" "sqs_queue" {
  name                      = "${var.project_name}-${var.environment}-main-queue"
  delay_seconds             = var.delay_seconds
  max_message_size          = var.max_message_size
  message_retention_seconds = var.message_retention_seconds
  receive_wait_time_seconds = var.receive_wait_time_seconds
  redrive_policy            = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.dead-letter-queue.arn}\",\"maxReceiveCount\":4}"

  tags = var.tags
}

resource "aws_sqs_queue_policy" "sqs_queue_policy" {
  queue_url = aws_sqs_queue.sqs_queue.id
  policy    = data.aws_iam_policy_document.sqs_queue_policy.json
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "${var.bucket_name}"

  queue {
    queue_arn     = aws_sqs_queue.sqs_queue.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".json"
  }
}


