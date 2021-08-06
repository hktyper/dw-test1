##### Main.tf #########################

variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
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
  description = "Costcentre code, this controls who gets billed for what resources"
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

variable "vpc_id" {
  type        = string
  description = "An ID for the VPC used by the Lambda."
}

variable "cw_logs_retention" {
  type        = number
  description = "Number of days to retain cloudwatch logs for"
  default     = 7
}

variable "lambda_timeout" {
  type        = number
  description = "Time in seconds before execution times out"
  default     = 600
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets to place Lambda in"
}

variable "iam_statements" {
  type = list(object({
    actions   = list(string)
    resources = list(string)
  }))
  description = "IAM permissions, as a list of pairs of (Actions, Resources) objects. Each object is a list of statements"
  default     = []
}

variable "lambda_app_name" {
  type        = string
  description = "A name for the Lambda function."
}

variable "lambda_runtime" {
  type        = string
  description = "Language version to use when running the code, e.g. 'python3.8'"
  default     = "python3.8"
}

variable "lambda_handler" {
  type        = string
  description = "Module path to the Lambda API handler, e.g. 'package.subpackage.module.function'"
}

variable "lambda_memory_size" {
  type        = number
  description = "Amount of memory available to Lambda, in MB"
  default     = 128
}

variable "lambda_zip_path" {
  type        = string
  description = "Optional lambda zip file location (if omitted, an empty lambda will be deployed)"
  default     = ""
}

variable "lambda_environment_variables" {
  type        = map(string)
  description = "Environment variables to set for the Lambda, as key:value mappings"
  default     = {}
}

# SQS Trigger vars:

variable "trigger_on_sqs" {
  type        = bool
  description = "If true, adds a mapping to trigger the Lambda on SQS events."
  default     = false
}

variable "trigger_sqs_arn" {
  type        = string
  description = "ARN of the SQS queue that will trigger the Lambda."
  default     = false
}

variable "sqs_trigger_batch_size" {
  type        = number
  description = "The largest number of records that Lambda will retrieve from SQS at the time of invocation"
  default     = 10
}
