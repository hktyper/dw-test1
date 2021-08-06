# Outputs of the main.tf script are defined here

output "curated_sns_topic_arn" {
  description = "If enable_notification is true, the ARN of the created SNS will be the output"
  value       = module.curated_datalake_bucket.topic_arn
}

output "curated_bucket_name" {
  description = "Name of the generated bucket. This value will be list(str)"
  value       = module.curated_datalake_bucket.bucket-name
}
