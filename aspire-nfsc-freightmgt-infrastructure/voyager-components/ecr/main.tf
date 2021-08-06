/**
 * # ECR Terraform Component
 *
 * This component creates an ECR resource to push a docker image too
 *
 */

module "ecr" {
  source = "git@github.com:JSainsburyPLC/aspire-common-terraform-modules.git//modules/ecr?ref=v3.3.1"

  app_name     = var.service_name
  environment  = var.environment
  project_name = var.project_name
  tags         = var.tags
}
