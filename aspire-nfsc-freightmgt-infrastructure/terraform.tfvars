environment = {
  dev     = "dev"
  preprod = "preprod"
  prod    = "prod"
}

live = {
  dev     = "no"
  preprod = "no"
  prod    = "yes"
}

region = {
  dev     = "eu-west-1"
  preprod = "eu-west-1"
  prod    = "eu-west-1"
}

################################################
# Baseline bootstrap new account module
################################################

aws_audit_account_id = {
  dev     = "302718774358"
  preprod = "302718774358"
  prod    = "141651631005"
}

#################################
# VPC Variables
#################################

vpc_cidr = {
  dev     = "10.0.0.0/21"
  preprod = "10.8.0.0/21"
  prod    = "10.0.0.0/21"
}

vpc_private_subnets = {
  dev     = ["10.0.0.0/23", "10.0.2.0/23"]
  preprod = ["10.8.0.0/23", "10.8.2.0/23"]
  prod    = ["10.0.0.0/23", "10.0.2.0/23"]
}

vpc_public_subnets = {
  dev     = ["10.0.4.0/23", "10.0.6.0/23"]
  preprod = ["10.8.4.0/23", "10.8.6.0/23"]
  prod    = ["10.0.4.0/23", "10.0.6.0/23"]
}


#################################
# ECS Variables
#################################
dpp_bucket = {
  dev     = "dpp-dev-raw-src-freight-mgmt"
  preprod = "dpp-preprd-raw-src-freight-mgmt"
  prod    = "dpp2-prd-raw-src-freight-mgmt"
}

local_landing_bucket = {
  dev     = "dev-raw-src-freightmgt-local"
  preprod = "preprod-raw-src-freightmgt-local"
  prod    = "prod-raw-src-freightmgt-local"
}

enable_task_scheduling = {
  dev     = false
  preprod = false
  prod    = true
}

ecr_image_url = {
  dev     = "302718774358.dkr.ecr.eu-west-1.amazonaws.com/aspire-nfsc-freightmgt-api-downloader:1.1.3"
  preprod = "302718774358.dkr.ecr.eu-west-1.amazonaws.com/aspire-nfsc-freightmgt-api-downloader:1.1.3"
  prod    = "141651631005.dkr.ecr.eu-west-1.amazonaws.com/aspire-nfsc-freightmgt-api-downloader:1.1.3"
}