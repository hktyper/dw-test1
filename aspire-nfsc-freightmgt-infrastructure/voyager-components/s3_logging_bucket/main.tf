/*
* # S3 Logging Bucket
*
* This component creates a bucket. For putting logs into. When buckets were accessed.
*/
module "s3_access_logging_bucket" {
  # This module creates the s3 access log bucket"
  source = "git::git@github.com:JSainsburyPLC/voyager-terraform-modules.git//s3_logging_buckets?ref=v1.1"

  bucket_name = "${var.account_number}-s3-access-logs"
  read_only_arns = [
    "arn:aws:iam::${var.account_number}:root"
  ]
  delete_only_arns = [
    "arn:aws:iam::${var.account_number}:root"
  ]
  write_only_arns = [
    "arn:aws:iam::${var.account_number}:root"
  ]
  enforced_acl = var.s3_logging_enforced_acl
  tags = merge({
    Name        = "${var.account_number}-s3-access-logs"
    Description = "S3 Access Logs for:${var.account_number}"
    },
    local.tags
  )
}
