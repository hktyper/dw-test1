resource "aws_sqs_queue" "dead-letter-queue" {
  name = "${var.project_name}-${var.environment}-dead-letter-queue"

  tags = var.tags
}


