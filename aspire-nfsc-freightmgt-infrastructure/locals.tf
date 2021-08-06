locals {
  workspace       = "prod" == terraform.workspace || "preprod" == terraform.workspace ? terraform.workspace : "dev"
  short_workspace = substr("${terraform.workspace}", 0, min(length("${terraform.workspace}"), 10))

  common_tags = {
    "environment"       = var.environment[terraform.workspace]
    "email"             = var.email
    "owner"             = var.owner
    "costcentre"        = var.costcentre
    "live"              = var.live[terraform.workspace]
    "technical-contact" = var.technical_contact
    "project"           = var.project
    "prefix"            = "${var.environment[terraform.workspace]}-${var.project}"
    "dataRetention"       = "4-years"
    "dataClassification"  = "highlySensitivePersonal"
  }
  knn_table_config = yamldecode(file("configs/table-config.yml"))
  knn_table_list   = keys(local.knn_table_config)
  cw_namespace     = "${var.environment[terraform.workspace]}/${var.service_name}"
  prod             = terraform.workspace == "prod" ? "r5.xlarge" : ""
  dev              = terraform.workspace == "dev" ? "t3.xlarge" : ""
  preprod          = terraform.workspace != "prod" && terraform.workspace != "dev" ? "t3.xlarge" : ""
  size             = coalesce(local.prod, local.dev, local.preprod)
}