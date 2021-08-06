module "failed_file_bucket" {
  /*
    This module creates an s3 bucket that receives any file that has failed to be processed in EMR.
  */
  count              = var.enable_s3_failed_file_bucket_creation == true ? 1 : 0
  source             = "git::git@github.com:JSainsburyPLC/voyager-terraform-modules.git//s3_bucket?ref=develop"
  bucket_name        = "${var.environment}-failed-src-${var.project_name}"
  region             = var.region
  access_logs_bucket = var.access_logs_bucket
  account_number     = var.account_number
  email              = var.email
  costcentre         = var.costcentre
  environment        = var.environment
  live               = var.live
}

resource "aws_s3_bucket_object" "voyager-artefacts" {
  /*
    This resource will upload everything from the voyager-artefacts directory from this repo to the voyager-artefacts
    bucket created by terraform module.voyager_artefacts.
  */
  for_each   = var.deploy_voyager_app == true ? fileset(path.module, var.voyager_artefacts_dir_regex) : fileset(path.module, "")
  bucket     = module.batch_lambda_emr_cluster.voyager_artefacts_bucket_name
  key        = trimprefix(each.key, var.voyager_artefacts_dir)
  source     = each.value
  depends_on = [module.batch_lambda_emr_cluster]
}
