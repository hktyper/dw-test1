/**
* # Snowflake PrivateLink
*
* Module that creates VPC Endpoints and DNS configurations to allow connection to Snowflake via PrivateLink
*
*
* ## Example Usage
*
* ```
* module "snowflake_privatelink" {
*  source                     = "git::git@github.com:JSainsburyPLC/voyager-terraform-modules.git//snowflake_privatelink?ref=v1.1"
*  private_subnet_ids         = module.vpc.private_subnet_ids
*  account_number             = var.account_number
*  region                     = var.aws_region
*  vpc_id                     = module.vpc.id
*  vpce_snowflake_address_id  = var.vpce_snowflake_address_id
*  vpc_endpoint_ingress_cidrs = [var.vpc_cidr]
* }
* ```
*/

module "snowflake_privatelink" {
  source                     = "git::git@github.com:JSainsburyPLC/voyager-terraform-modules.git//snowflake_privatelink?ref=v1.1"
  account_number             = var.account_number
  vpc_endpoint_ingress_cidrs = var.vpc_endpoint_ingress_cidrs
  vpc_id                     = var.vpc_id
  vpce_snowflake_address_id  = var.vpce_snowflake_address_id
  private_subnet_ids         = var.private_subnet_ids
  region                     = var.region
}