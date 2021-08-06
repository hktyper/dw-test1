################################################
# Generic Variables
################################################

variable "tags" {
  default     = {}
  type        = map(string)
  description = "A mapping of tags to assign to all resources."
}

variable "environment" {
  description = "The environment the stack is going to be deployed in e.g. dev/preprod/prod"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

################################################
# SQS Variables
################################################

variable "bucket_name" {
  description = "The AWS bucket you want to apply notification"
  type        = string
}

variable "delay_seconds" {
  description = "The time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes)."
  type        = number
  default     = 90
}

variable "max_message_size" {
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB)"
  type        = number
  default     = 2048
}

variable "message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)"
  type        = number
  default     = 86400
}

variable "receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds)."
  type        = number
  default     = 10
}