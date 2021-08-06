variable "account_number" {
  type        = string
  description = "The account number to use in the bucket name and policy"
}

variable "s3_logging_enforced_acl" {
  description = "Canned ACL to enforce by bucket policy (https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl)"
  default     = "log-delivery-write"
}

variable "environment" {
  type        = string
  description = "This is the name of the deployment environment. The options are as follows: dev, preprod, prod."
}

variable "project_name" {
  type        = string
  description = "Name of the project."
  default     = "voyager"
}

variable "owner" {
  type        = string
  description = "Owner of the pipeline."
}

variable "email" {
  type        = string
  description = "email of the owner of the pipeline."
}

variable "costcentre" {
  type        = string
  description = "Costcentre code, this controls who gets billed for what resources."
}

variable "live" {
  type        = string
  description = "Is the deployed solution live. e.g yes or no"
  default     = "no"
}


locals {
  tags = {
    "environment"  = var.environment
    "email"        = var.email
    "owner"        = var.owner
    "costcentre"   = var.costcentre
    "live"         = var.live
    "project_name" = var.project_name
  }
}

