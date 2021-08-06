terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}


locals {
  workspace       = "${"prod" == terraform.workspace || "preprod" == terraform.workspace ? terraform.workspace : "dev"}"
  short_workspace = "${substr("${terraform.workspace}", 0, min(length("${terraform.workspace}"), 10))}"
  common_tags = {
    "environment"       = var.environment[terraform.workspace]
    "email"             = var.email
    "owner"             = var.owner
    "costcentre"        = var.costcentre
    "live"              = var.live[terraform.workspace]
    "technical-contact" = var.technical_contact
    "project"           = var.project
    "prefix"            = "${var.environment[terraform.workspace]}-${var.project}"
  }
}

terraform {
  backend "s3" {
    key            = "voyager-snowflake-privatelink/voyager-snowflake-privatelink.tfstate"
    profile        = "freightmgmt-nonprod"
    region         = "eu-west-1"
    bucket         = "grada-nfsc-terraform-state"
    dynamodb_table = "grada-nfsc-terraform-dynamodb"
    encrypt        = true
    role_arn = "arn:aws:iam::918049921384:role/ccoe/CrossAccountDynamoDB"
  }
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = "testing-dynamodb-backend-log-group"
  retention_in_days = 7
  tags              = local.common_tags
}