output "raw_transfer_bucket_name" {
  value       = module.s3_raw_transfer.s3_bucket_name
  description = "Name of the raw transfer bucket."
}

output "raw_transfer_bucket_arn" {
  value       = module.s3_raw_transfer.s3_bucket_arn
  description = "ARN of the raw transfer bucket"
}

output "sns_topic_arn" {
  value = module.s3_raw_transfer.sns_topic_arn
}
