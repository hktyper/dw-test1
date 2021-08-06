variable "environment" {
  description = "The environment that this component is deployed to"
  type        = string
  default     = "dev"
}

variable "service_name" {
  description = "Name of the service"
  type        = string
  default     = "voyager-poc"
}

variable "tags" {
  description = "The tags to use for the resources"
  type        = map(string)
  default = {
    servicename = "voyager-poc"
  }
}

variable "project_name" {
  description = "Project name for this deployment"
  type        = string
}
