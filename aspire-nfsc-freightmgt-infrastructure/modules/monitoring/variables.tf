variable "tags" {
  default     = {}
  type        = map(string)
  description = "Default project tags."
}

variable "service_name" {
  type        = string
  description = "Name of the service being monitored"
}

variable "environment" {
  type        = string
  description = "The environment the stack is going to be deployed in e.g. dev/preprod/prod"
}

variable "tables" {
  type        = list(string)
  description = "List of tables to monitor"
}

variable "table_config" {
  type        = map(map(string))
  description = "A mapping of the configuration for the tables, whereby the keys are name of the table and the values are a mapping which includes row_threshold as a key"
}

variable "log_group" {
  type        = string
  description = "Log group for the ECS cluster"
}

variable "namespace" {
  type        = string
  description = "The namespace for the alarm's associated metric"
}

locals {
  dashboard_template = "${path.module}/templates/dashboard.tmpl"
}
