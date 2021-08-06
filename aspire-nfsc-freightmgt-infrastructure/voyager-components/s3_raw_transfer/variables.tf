##### GENERAL #########################

variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "name" {
  type        = string
  description = "Name of the application"
  default     = "voyager"
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

# Tags
variable "costcentre" {
  type        = string
  description = "The PD code for costing which the resource is allocated to"
  default     = ""
}

variable "email" {
  type        = string
  description = "The email address of the owner of the resource, usually PO"
  default     = ""

}

variable "live" {
  type        = string
  description = "Non-production resources should always have the live tag set to no. Production resources should have the live tag set to no before they go live, but after they go live it should be set to yes."
  default     = "No"
  validation {
    condition     = can(regex("(?i)yes|(?i)no", var.live))
    error_message = "ERROR: Must either be yes or no."
  }
}


variable "service_catalogue_id" {
  type        = string
  description = "Way of identifying application resources by the recognised reference number held in ServiceNow and MEGA"
  default     = ""
}

variable "service_name" {
  type        = string
  description = "Way of identifying application resources in Non-Prod prior to issue of Service Catalogue ID for production resources."
  default     = ""
}

variable "data_retention" {
  type        = string
  description = "To determine how long data should be retained within a particular datastore"
  default     = ""
}

variable "data_classification" {
  type        = string
  description = "To determine how the data held or flowing through a resource should be treated"
  default     = ""
}

variable "tags" {
  description = "The tags to use for the resources"
  type        = map(string)
  default     = {}
}

locals {
  tags = merge({
    email              = var.email
    costcentre         = var.costcentre
    live               = var.live
    environment        = var.environment
    servicecatalogueID = var.service_catalogue_id
    servicename        = var.service_name
    dataRetention      = var.data_retention
    dataClassification = var.data_classification
  }, var.tags)
}

variable "access_logs_bucket" {
  type        = string
  description = "The name of the log bucket to place logs into"
}
variable "account_number" {
  type        = string
  description = "The AWS Account Number of this bucket"
}

variable "enable_notification" {
  type        = bool
  description = "If true, an SNS notification will be created and will be linked to the created S3 to trigger event notification"
  default     = false
}

variable "subrecv_arn_list" {
  description = "If there is any cross-account subscription, provide principle arn."
  type        = list(any)
  default     = []
}

variable "enable_snowflake_stage" {
  description = "Flag to determine whether to create Snowflake Stage IAM policies"
  type        = bool
  default     = false
}