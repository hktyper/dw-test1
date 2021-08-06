###############################################################################
# Generic
###############################################################################

locals {
  tags = {
    costcentre  = var.costcentre
    email       = var.email
    environment = var.environment
    live        = var.live
  }
}

variable "region" {
  description = "The region to deploy to"
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  description = "Name of the deployment environment. The options are: dev, preprod, prod"
  type        = string
}

variable "costcentre" {
  type        = string
  description = "Cost-centre code - controls who gets billed for what resources."
}

variable "email" {
  type        = string
  description = "email of the owner of the pipeline."
}

variable "live" {
  type        = string
  description = "Is the deployed solution live. e.g yes or no"
  default     = "no"
}

###############################################################################
# Notifications
###############################################################################

variable "sns_filter_policy" {
  type        = string
  default     = ""
  description = "A JSON definition for routing events to different SNS subscribers. See: https://docs.aws.amazon.com/sns/latest/dg/sns-message-filtering.html"
}

variable "sns_source_topic_arns" {
  type        = list(string)
  default     = []
  description = ""
}

###############################################################################
# SQS
###############################################################################

variable "sqs_name" {
  type        = string
  description = "Name of the SQS queue handling the file notifications."
}

locals {
  sqs_dead_letter_queue_name = "${var.sqs_name}-dead-letter-queue"
}

variable "sqs_delay_seconds" {
  type        = number
  default     = 0
  description = "See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue#delay_seconds"
}

variable "sqs_max_message_size" {
  type        = number
  default     = 262144
  description = "See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue#max_message_size"
}

variable "sqs_timeout_seconds" {
  type        = number
  default     = 30
  description = "The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)"
}

variable "sqs_message_retention_seconds" {
  type        = number
  default     = 1209600
  description = "See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue#message_retention_seconds"
}

variable "sqs_receive_wait_time_seconds" {
  type        = number
  default     = 10
  description = "See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue#receive_wait_time_seconds"
}

variable "sqs_raw_message_delivery" {
  type        = string
  default     = "true"
  description = "See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription#raw_message_delivery"
}

variable "sqs_max_receive_count" {
  type        = number
  default     = 5
  description = "Maximum number of times a message may be received from SQS without being deleted before it's moved to the dead letter queue"
}
