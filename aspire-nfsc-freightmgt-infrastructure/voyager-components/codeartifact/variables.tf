
variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "codeartifact_domain_key_desc" {
  type        = string
  description = "Description for the KMS key created for the domain"
  default     = "Domain Key for CodeArtifact Module Domain"
}

variable "codeartifact_domain" {
  type        = string
  description = "The codeartifact domain resource to use, defaults to using the resource created by this module"
  default     = ""
}

variable "codeartifact_domain_name" {
  type        = string
  description = "The codeartifact domain name to create"
  default     = "defaultcodeartifactdomain"
}

variable "codeartifact_repository" {
  type        = string
  description = "The codeartifact repository name to create"
}

variable "codeartifact_create_domain" {
  type        = string
  description = "Toggle whether to create a domain resource or not"
  default     = true
}
