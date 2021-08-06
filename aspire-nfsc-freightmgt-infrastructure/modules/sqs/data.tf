data "aws_iam_policy_document" "sqs_queue_policy" {
  statement {
    sid     = "enable_s3_sqs_queue"
    effect  = "Allow"
    actions = ["sqs:SendMessage"]
    resources = [
      aws_sqs_queue.sqs_queue.arn,
    ]
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    condition {
      test     = "ArnLike"
      variable = "AWS:SourceArn"

      values = [
        "arn:aws:s3:::${var.bucket_name}",
      ]
    }
  }
}
