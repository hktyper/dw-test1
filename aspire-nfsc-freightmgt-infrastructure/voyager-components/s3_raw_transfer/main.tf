/**
* # S3 Raw Transfer
*
* This component creates an S3 bucket which will contain raw data from data source.
*
* ### Running via CircleCI
*
* For development purpose, you can run the component via CircleCI. 
* You need to create a voyager_variables.yaml file and pass it to the deploy_components.py.
*
*/

module "s3_raw_transfer" {
  source              = "git::git@github.com:JSainsburyPLC/voyager-terraform-modules.git//s3_bucket?ref=v1.1"
  bucket_name         = "${var.environment}-raw-transfer-src-${var.project_name}"
  region              = var.region
  access_logs_bucket  = var.access_logs_bucket
  account_number      = var.account_number
  email               = var.email
  tags                = local.tags
  enable_notification = var.enable_notification
  subrecv_arn_list    = var.subrecv_arn_list
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "snowflake_storage_integration_role" {
  count                = var.enable_snowflake_stage == true ? 1 : 0
  name                 = "${var.project_name}-sf-stage-role-${var.environment}"
  tags                 = local.tags
  permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/ccoe/js-developer"
  assume_role_policy   = file("${path.module}/policies/snowflake_assume_role_policy.json")
}

resource "aws_iam_role_policy" "snowflake_storage_integration_policy" {
  count = var.enable_snowflake_stage == true ? 1 : 0
  name  = "${var.project_name}-sf-stage-policy-${var.environment}"
  role  = aws_iam_role.snowflake_storage_integration_role[0].id
  policy = templatefile(
    "${path.module}/policies/snowflake_role_policy.json.tpl",
    {
      bucket_name = module.s3_raw_transfer.s3_bucket_name
    }
  )
}
