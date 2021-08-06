##### Main.tf #########################

variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "cluster_suffix" {
  type        = string
  description = "Suffix to append to the end of the project name to use for the cluster to make it unique"
  default     = "devcluster"
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

locals {
  tags = {
    "environment"  = var.environment
    "email"        = var.email
    "owner"        = var.owner
    "costcentre"   = var.costcentre
    "live"         = var.live
    "project_name" = var.project_name
  }
}
variable "create_microservices" {
  type        = bool
  description = "Boolean variable used to determine whether or not you'd like to define microservices"
  default     = false
}

variable "fargate_microservices" {
  description = "Map of variables to define a fargate microservice"
  type = map(object({
    name                   = string
    task_definition        = string
    desired_count          = string
    launch_type            = string
    security_group_mapping = string
  }))
  default = {}
}

variable "create_tasks" {
  type        = bool
  description = "Boolean variable used to determine whether or not you'd like to define tasks"
  default     = false
}

variable "ecs_tasks" {
  description = "Map of variables to define an ECS task"
  type = map(object({
    family               = string
    container_definition = string
    cpu                  = string
    memory               = string
    container_port       = string
  }))
}

variable "extra_template_variables" {
  type        = map(any)
  description = "Extra parameters required to define the environment of the image"
}

variable "vpc_id" {
  type        = string
  description = "An id for the VPC utlised by ECS."
}

variable "ecs_service_subnets" {
  type        = list(string)
  description = "VPC subnets utlised by ECS."
}

variable "cw_logs_retention" {
  type        = number
  description = "Number of days to retain cloudwatch logs for"
  default     = 7
}

variable "docker_image" {
  type        = string
  description = "Docker image used to run the tasks"
}

variable "secret_names" {
  type        = list(string)
  description = "A list of secret names that the ecs cluster is allowed to access within voyager."
}

variable "s3_bucket_names" {
  type        = list(string)
  description = "A list of s3 buckets that the ecs cluster is allowed to access within voyager."
  default     = []
}

variable "security_groups" {
  type = map(object({
    ingress_port        = string
    ingress_protocol    = string
    ingress_cidr_blocks = list(string)
    egress_port         = string
    egress_protocol     = string
    egress_cidr_blocks  = list(string)
  }))
  description = "Security group configurations for respective services"
}