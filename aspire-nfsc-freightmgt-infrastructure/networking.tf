module "flowlogs_s3" {
  source             = "git@github.com:JSainsburyPLC/aspire-common-terraform-modules.git//modules/s3_bucket?ref=v2.23.3"
  bucket_name        = "aspire-nfsc-freightmgt-infrastructure-${var.environment[terraform.workspace]}-vpc-flowlogs"
  description        = "Flow logs bucket for NFSC Freight Management"
  account_number     = data.aws_caller_identity.current.account_id
  access_logs_bucket = "${data.aws_caller_identity.current.account_id}-s3-access-logs"

  tags =  local.common_tags
}

module "vpc" {
  source = "git@github.com:JSainsburyPLC/aspire-common-terraform-modules.git//modules/vpc?ref=v3.0.4"

  vpc_name               = "aspire-nfsc-freightmgt-${var.environment[terraform.workspace]}-vpc"
  vpc_description        = "VPC for NFSC Freight Management K+N as part of the Argos Tactical Migration Project in ${var.environment[terraform.workspace]}"
  vpc_cidr               = var.vpc_cidr[terraform.workspace]
  vpc_azs                = ["eu-west-1a", "eu-west-1b"]
  vpc_private_subnets    = var.vpc_private_subnets[terraform.workspace]
  vpc_public_subnets     = var.vpc_public_subnets[terraform.workspace]
  vpc_enable_nat_gateway = true

  vpc_flowlogs_s3_bucket = module.flowlogs_s3.s3_bucket_name

  region       = var.region[terraform.workspace]
  project_name = var.project
  environment  = var.environment[terraform.workspace]
  tags         = local.common_tags
}