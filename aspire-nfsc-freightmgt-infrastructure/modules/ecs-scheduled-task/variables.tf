# GENERIC VARIABLES
variable "tags" {
  default     = {}
  type        = map(string)
  description = "Default project tags."
}

# ECS TASK VARIABLES

variable "ecs_task_name" {
  type        = string
  description = "The name of ECS task."
}

variable "ecs_cluster_arn" {
  type        = string
  description = "ARN of the ECS Cluster"
}

variable "container_definitions" {
  type        = string
  description = "A list of valid container definitions provided as a single valid JSON document"
}

variable "ecs_task_role_arn" {
  type        = string
  description = "The ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services."
}

variable "cpu" {
  type        = string
  description = "The number of cpu units used by the task."
}

variable "memory" {
  type        = string
  description = "The amount (in MiB) of memory used by the task."
}

variable "launch_type" {
  type        = string
  description = "Specifies the launch type on which your task is running. Valid values are EC2 or FARGATE."
}

# CLOUDWATCH EVENT VARIABLES

variable "event_schedule_expression" {
  type        = string
  description = "The scheduling expression. For example, cron(0 20 * * ? *) or rate(5 minutes). At least one of schedule_expression or event_pattern is required. Can only be used on the default event bus."
}

variable "task_count" {
  default     = 1
  type        = string
  description = "The number of tasks to create based on the TaskDefinition."
}

variable "platform_version" {
  default     = "LATEST"
  type        = string
  description = "Specifies the platform version for the task."
}

variable "assign_public_ip" {
  type        = string
  description = "Assign a public IP address to the ENI (Fargate launch type only)."
}

variable "ecs_subnets" {
  type        = list(string)
  description = "The subnets associated with the task or service."
}

variable "enable_scheduling" {
  default     = true
  type        = bool
  description = "Boolean to enable scheduled tasks"
}

variable "environment" {
  type = string
}