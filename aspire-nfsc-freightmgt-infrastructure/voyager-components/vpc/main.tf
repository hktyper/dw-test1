/**
*
* # VPC Component
*
* This component sets up a VPC and will provide a set of outputs that other components can then use as inputs
*
* ## Example Usage
*
* See examples directory for example configuration
*
*/

module "vpc" {
  source                          = "git::git@github.com:JSainsburyPLC/voyager-terraform-modules.git//vpc?ref=v1.1"
  project_name                    = var.project_name
  environment                     = var.environment
  owner                           = var.owner
  email                           = var.email
  costcentre                      = var.costcentre
  live                            = var.live
  vpc_name                        = "${var.project_name}-${var.environment}-vpc"
  vpc_cidr                        = var.vpc_cidr
  vpc_secondary_cidr_blocks       = var.vpc_secondary_cidr_blocks
  region                          = var.region
  vpc_azs                         = var.availability_zones
  vpc_private_subnets             = var.private_subnets
  vpc_public_subnets              = var.public_subnets
  vpc_flowlogs_s3_bucket          = var.vpc_flowlogs_s3_bucket
  single_nat_gateway              = var.single_nat_gateway
  vpc_enable_nat_gateway          = var.enable_nat_gateway
  vpc_description                 = var.vpc_description
  vpc_interface_endpoint_services = var.vpc_interface_endpoint_services
}
