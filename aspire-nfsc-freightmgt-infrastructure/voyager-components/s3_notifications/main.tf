/**
 * # S3 File Notifications Pipeline Components
 *
 * This component creates the infrastructure for an event processing pipeline from
 * S3 Bucket Event -> SNS Topic Notification -> SQS queue + dead-letter queue.
 *
 * The queue can then be wired up as an event source for a Lambda function;
 * however, you will need to pass in the ARN of the SQS queue to the Lambda
 * component yourself, separately.
*/

# SQS
resource "aws_sqs_queue" "sqs_queue" {
  name                       = var.sqs_name
  delay_seconds              = var.sqs_delay_seconds
  max_message_size           = var.sqs_max_message_size
  message_retention_seconds  = var.sqs_message_retention_seconds
  receive_wait_time_seconds  = var.sqs_receive_wait_time_seconds
  visibility_timeout_seconds = var.sqs_timeout_seconds
  redrive_policy             = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.dead_letter_queue.arn}\",\"maxReceiveCount\":${var.sqs_max_receive_count}}"
  tags                       = local.tags
}

resource "aws_sqs_queue_policy" "sqs_queue_policy" {
  queue_url = aws_sqs_queue.sqs_queue.id
  policy    = data.aws_iam_policy_document.sqs_queue_policy_document.json
}

data "aws_iam_policy_document" "sqs_queue_policy_document" {
  statement {
    actions = [
      "sqs:SendMessage",
    ]
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"

      values = var.sns_source_topic_arns[*]
    }
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = [
      aws_sqs_queue.sqs_queue.arn,
    ]
    sid = "__default_statement_ID"
  }
}

resource "aws_sqs_queue" "dead_letter_queue" {
  name = local.sqs_dead_letter_queue_name
  tags = local.tags
}


# SNS Subscriptions
resource "aws_sns_topic_subscription" "sqs_subcription_to_sns" {
  for_each = toset(var.sns_source_topic_arns)

  topic_arn            = each.value
  protocol             = "sqs"
  endpoint             = aws_sqs_queue.sqs_queue.arn
  filter_policy        = var.sns_filter_policy
  raw_message_delivery = var.sqs_raw_message_delivery
}
