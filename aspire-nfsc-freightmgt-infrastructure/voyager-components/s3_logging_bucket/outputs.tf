output "logging_bucket_name" {
  description = "The name of the bucket for access logs"
  value       = module.s3_access_logging_bucket.bucket_name
}
