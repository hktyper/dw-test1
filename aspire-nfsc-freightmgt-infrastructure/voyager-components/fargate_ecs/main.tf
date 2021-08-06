/**
 * # Fargate_ECS Voyager Component
 *
 * This module creates the resources for create a fargate ECS cluster with a dynamic set of tasks and services.
 *
 * Prerequisites:
 * This component requires the templates directory to be populated with the task definition json files for each task you wish to deploy
 *
 */


module "fargate_ecs_cluster" {
  /*
    This module creates a dynamic ECS cluster which allows us to define arbitrary tasks and services.
    This allows multiple tasks and services to be defined for the component as variables.
  */
  source = "git::git@github.com:JSainsburyPLC/voyager-terraform-modules.git//ecs_dynamic_cluster?ref=v1.1"

  # Generic variables
  region       = var.region
  project_name = "${var.project_name}-${var.cluster_suffix}"
  environment  = var.environment
  tags         = local.tags

  # ECS variables
  create_microservices     = var.create_microservices
  fargate_microservices    = var.fargate_microservices
  create_tasks             = var.create_tasks
  ecs_tasks                = var.ecs_tasks
  extra_template_variables = var.extra_template_variables
  vpc_id                   = var.vpc_id
  ecs_service_subnets      = var.ecs_service_subnets # Subnet range provided by networking
  cw_logs_retention        = var.cw_logs_retention
  docker_image             = var.docker_image
  secret_names             = var.secret_names
  s3_bucket_names          = var.s3_bucket_names
  security_groups          = var.security_groups

}
