variable "environment" {
  description = "The environment that the component will be deployed to"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "The region to deploy to"
  type        = string
  default     = "eu-west-1"
}

variable "service_name" {
  description = "Name of the service"
  type        = string
  default     = "voyager-poc"
}

variable "tags" {
  description = "The tags to use for resources"
  type        = map(string)
  default = {
    servicename = "voyager-poc"
  }
}

variable "codepipeline_account_id" {
  description = "The account where codepipeline is"
  type        = string
}
