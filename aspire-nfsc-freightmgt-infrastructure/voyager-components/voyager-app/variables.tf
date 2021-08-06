# These vars are used in the pre-deploy script but are passed through from
# terraform outputs
variable "vpc_id" {
  description = "The vpc id for building the ami"
  type        = string
  default     = "vpc-00000000000"
}

variable "vpc_subnet" {
  description = "The vpc subnet for building the ami"
  type        = string
  default     = "subnet-00000000000"
}

variable "codeartifact_repo" {
  description = "The codeartifact repo for storing the library"
  type        = string
  default     = "voyager"
}

variable "codeartifact_domain" {
  description = "The codeartifact domain of the repo"
  type        = string
  default     = "voyager"
}

variable "ecr_url" {
  description = "The URL for ECR"
  type        = string
  default     = ""
}
