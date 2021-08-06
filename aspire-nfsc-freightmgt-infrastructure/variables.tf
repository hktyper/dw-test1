################################################
# Generic Variables
################################################
variable "environment" {
  description = "The environment the stack is going to be deployed in e.g. dev/test/preprod/prd"
  type        = map(string)
}

variable "live" {
  description = "live. in non prod it is a no"
  type        = map(string)
}

variable "region" {
  description = "AWS region"
  type        = map(string)
}

################################################
# Baseline bootstrap new account module
################################################
variable "aws_audit_account_id" {
  description = "Baseline bootstrap new account module"
  type        = map(string)
}

################################################
# VPC Variables
# References docs https://github.com/JSainsburyPLC/aspire-common-terraform-modules/tree/master/modules/vpc
################################################
variable "vpc_cidr" {
  description = "Allocated VPC CIDR range(s)"
  type        = map(string)
}

variable "vpc_private_subnets" {
  description = "List of the CIDR block for the private subnets within the VPC"
  type        = map(list(string))
}

variable "vpc_public_subnets" {
  description = "List of the CIDR block for the public subnets within the VPC"
  type        = map(list(string))
}

################################################
# ECS Variables
################################################

variable "dpp_bucket" {
  type        = map(string)
  description = "The DPP bucket in which CSV files are published to."
}

variable "service_name" {
  default     = "api-downloader"
  type        = string
  description = "Name of the service to be run on ECS. In this case, this is the API Downloader python application used to download data from the K+N API"
}

variable "knn_service_url" {
  default     = "https://esp.kuehne-nagel.com/report/odata/v2/reporting/"
  type        = string
  description = "The URL of the service to download data from. In this case, this is the K+N API."
}

variable "launch_type" {
  default     = "FARGATE"
  type        = string
  description = "A set of launch types required by the task. The valid values are EC2 and FARGATE."
}

variable "enable_task_scheduling" {
  type        = map(string)
  description = "Boolean to enable scheduled tasks"
}

variable "ecr_image_url" {
  type        = map(string)
  description = "ECR image URL to used for the ECS task"
}

################################################
# IAM Variables
################################################

variable "local_landing_bucket" {
  type        = map(string)
  description = "The local landing bucket in which json files from the K+N API are published to."
}

variable "secret_name" {
  default     = "kn_api"
  type        = string
  description = "The name of the secret stored in AWS Secrets Manager for K+N API authentication."
}

################################################
# CLOUDWATCH LOGS VARIABLES
################################################
variable "logs_retention" {
  default     = 7
  type        = number
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
}