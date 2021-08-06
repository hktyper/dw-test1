
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

variable "vpc_flowlogs_s3_bucket" {
  type        = string
  default     = ""
  description = "S3 bucket name where vpc flowlogs are written to."
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC."
}

variable "availability_zones" {
  type        = list(string)
  default     = ["eu-west-1a"]
  description = "A list of availability zones attributed to a VPC."
}

variable "private_subnets" {
  type        = list(string)
  description = "A list of CIDR ranges for your private subnets."
}

variable "public_subnets" {
  type        = list(string)
  description = "List of the CIDR block for the public subnets within the VPC"
  default     = []
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "subnet_type" {
  type        = string
  description = "Type of VPC subnet ID where you want the job flow to launch. Supported values are `private` or `public`"
  default     = "private"
}

variable "vpc_description" {
  type        = string
  description = "Description for a VPC."
}

variable "vpc_interface_endpoint_services" {
  type        = list(string)
  description = "List of AWS-managed VPC Endpoint Interface services"
  default     = []
}

variable "vpc_secondary_cidr_blocks" {
  type        = list(string)
  description = "The secondary CIDR block of the VPC"
  default     = []
}

variable "single_nat_gateway" {
  type    = string
  default = false
}

variable "vpc_enable_nat_gateway" {
  type        = string
  description = "Toggle to enable a nat gateway on vpc creation"
  default     = true
}
