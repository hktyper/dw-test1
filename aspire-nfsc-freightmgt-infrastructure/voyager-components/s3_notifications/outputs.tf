output "sqs_arn" {
  description = "ARN of the created SQS queue"
  value       = aws_sqs_queue.sqs_queue.arn
}

output "deadletter_arn" {
  description = "ARN of the created SQS dead letter queue"
  value       = aws_sqs_queue.dead_letter_queue.arn
}
