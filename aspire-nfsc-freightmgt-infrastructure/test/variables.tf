variable "email" {
  description = "The email of the owner"
  type        = string
  default     = "natalie.smith@sainsburys.co.uk"
}

variable "owner" {
  description = "The owner of the resources that will be created"
  type        = string
  default     = "Natalie Smith"
}

variable "costcentre" {
  description = "The name of the costcentre"
  type        = string
  default     = "PD7455"
}

variable "technical_contact" {
  description = "technical contact for dms poc project"
  type        = string
  default     = "gdp_apple@sainsburys.co.uk"
}
variable "project" {
  description = "project name"
  type        = string
  default     = "grada-apple"
}

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