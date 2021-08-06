##### GENERAL #########################

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
  description = "Costcentre code, this controls who gets billed for what resources."
}

variable "live" {
  type        = string
  description = "Is the deployed solution live. e.g yes or no"
  default     = "no"
}

variable "ticket_ref" {
  type        = string
  description = "Jira ticket reference"
  default     = ""
}


variable "account_number" {
  type        = string
  description = "The AWS Account Number of this bucket"
}

##### Curated Bucket #########################
variable "enable_notification" {
  description = "If true, an SNS notification will be created and will be linked to the created S3 to trigger event notification"
  type        = bool
  default     = false
}

variable "curated_read_write_trusted_arns" {
  description = "List of principles with Read and Write access to the bucket. This parameter might be provided by another component e.g. EMR."
  type        = list(string)
  default     = []
}

variable "curated_read_only_trusted_arns" {
  description = "List of principles with Read-Only access to the bucket. This might be provided by another component e.g. EMR."
  type        = list(string)
  default     = []
}

variable "curated_notification_events" {
  description = "A list of maps of which a single map contains the event which needed to occur to trigger SNS notification from S3 bucket. Each map must have `events` item and the optional items are filter_suffix and filter_prefix."
  type        = list(any)
  default     = [{ events = ["s3:ObjectCreated:*"] }]
}

variable "curated_subrecv_arn_list" {
  description = "ARN of the subscribers, If there is any."
  type        = list(string)
  default     = []
}
