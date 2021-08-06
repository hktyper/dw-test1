/**
 * # EMR Component
 *
 * This component sets up an EMR cluster and bundles the capabilities to setup the required pre-requisites such as the S3 resources and Lambda and voyager-app parts if required. It will then provide outputs that can be re-used for other components. 
 *
 * ## Example Usage
 *
 * Note: This version of component has been tested and verified working against AMI ID ami-0bcd3e1d48f694928
 *
 * The component currently supports two methods of deployment: 
 *
 * ### Method 1 (Isolated deployment): 
 *
 * This method allows you to run the emr component in isolation from other components and run terraform directly against the component's resources. This requires you to plug in a tf_vars.json file with all of the component's required variable values and a other_vars.json which plugs in all of the backend and provider variables (See setup.sh to find out specifically what keys/vars are required). Once these are available, you can run the following steps:
 *
 * ```
 * cd emr
 * ./setup.sh 
 * ```
 *
 * ### Method 2 (Terragrunt and integrated component deployment):
 *
 * This method allows the EMR component to be deployed in conjunction with other components with the use of Terragrunt. This requires the use of a the deploy_components.py found in the root of the voyager-components repo and the use of a voyager_variables.yaml and terragrunt.hcl file. An example_terragrount_config.yaml file has been supplied to get you up and running with deploying EMR integrated with the other components. 
 *
 * Additionally if you are deploying the EMR component with S3 and Voyager App toggles enabled, you need to make sure that the pre_deploy.sh and voyager_bash_functions.sh scripts exist and that a script_vars.json file is also present with your ETL configuration. 
 *
 * Once these are present, you will be able to run the following steps: 
 *
 * ```
 * cd ../
 * python deploy_components.py
 * ```
 *
 * <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
 * ## Requirements
 *
 * For method 1 ensure that the following packages/dependencies are available in your pipeline: 
 *
 * ```
 * Terraform
 * Jq
 * yq
 * ```
 *
 *
 * For method 2 ensure that the following packages/dependencies are available in your pipeline (Python packages are required if deploying with deploy_voyager_app toggle enabled and for deploy_components.py): 
 *
 * ```
 * Terraform
 * Terragrunt (https://github.com/gruntwork-io/terragrunt/releases/)
 * Jq
 * yq
 * python3
 * py-pip
 * pyyaml
 * ```
 *
 * If deploying with the deploy-voyager-app toggle enabled, you will also need to ensure that you pass an appropriate script_vars.json file to be picked up by the pre_deploy.sh hook (see example_terragrunt_config.yaml for example of the hook and config). You will need to make sure that you populate this with the appropriate json schema configuration required to create the voyager-artefacts. Currently pre_deploy.sh looks for keys in both the terragrunt configuration and in script_vars.json, the terragrunt keys are as follows (Should already be declared in your configuration ):
 *
 * ```
 * .inputs.deploy_voyager_app
 * .inputs.project_name
 * .inputs.environment
 * .inputs.voyager_app_repo
 * .inputs.voyager_app_branch
 * .inputs.lambda_environment_variables
 * .inputs.regex_prefix
 * ```
 *
 * The other keys that are required in the file called script_vars.json are as follows (The pre_deploy.sh and functions can be modified to meet your use case): 
 *
 * ```
 * .etl_config 
 * .schema
 * ```
 *
 * ## Component Requirements
 *
 * The following components this module requires.
 *
 * | Name | Reason | Required outputs provided |
 * |------|--------|---------------------------|
 * | vpc | To provide necessary networking setup | Yes |
 * | privatelink | To enable EMR to write out to Snowflake within deployed VPC | Yes |
 *
 *
 * ## Known Issues:
 * 
 * https://github.com/JSainsburyPLC/voyager-components/issues?q=emr
 *
 *
 *
 * ## Terraform Version~~~~
 *
 * Terraform version tested against and compatible.
 *
 * | Name      | Version |
 * | --------- | ------- |
 * | terraform | >=0.13  |
 *
 * ## Terragrunt Version~~~~
 *
 * Terragrunt version tested against and compatible.
 *
 * | Name       | Version  |
 * | ---------- | -------- |
 * | terragrunt | >=0.26.X |
 *
 *
*/
module "batch_lambda_emr_cluster" {

  source = "git::git@github.com:JSainsburyPLC/voyager-terraform-modules.git//emr_lambda?ref=v1.1"

  # Generic variables
  namespace          = var.project_name
  stage              = var.environment
  name               = var.name
  region             = var.region
  tags               = local.tags
  access_logs_bucket = var.access_logs_bucket
  account_number     = var.account_number
  email              = var.email
  costcentre         = var.costcentre
  environment        = var.environment
  live               = var.live
  project_name       = var.project_name
  owner              = var.owner

  # EMR variables
  vpc_id                                         = var.vpc_id
  subnet_id                                      = var.subnet_id
  route_table_ids                                = var.private_route_table_ids
  subnet_type                                    = var.subnet_type
  ebs_root_volume_size                           = var.ebs_root_volume_size
  visible_to_all_users                           = var.visible_to_all_users
  release_label                                  = var.release_label
  applications                                   = var.applications
  custom_ami_id                                  = var.custom_ami_id
  core_instance_group_instance_type              = var.core_instance_group_instance_type
  core_instance_group_instance_count             = var.core_instance_group_instance_count
  core_instance_group_ebs_size                   = var.core_instance_group_ebs_size
  core_instance_group_ebs_type                   = var.core_instance_group_ebs_type
  core_instance_group_ebs_volumes_per_instance   = var.core_instance_group_ebs_volumes_per_instance
  master_instance_group_instance_type            = var.master_instance_group_instance_type
  master_instance_group_instance_count           = var.master_instance_group_instance_count
  master_instance_group_ebs_size                 = var.master_instance_group_ebs_size
  master_instance_group_ebs_type                 = var.master_instance_group_ebs_type
  master_instance_group_ebs_volumes_per_instance = var.master_instance_group_ebs_volumes_per_instance
  create_task_instance_group                     = var.create_task_instance_group
  cidr_blocks                                    = [var.vpc_cidr]
  log_uri                                        = "${var.log_uri}/${var.environment}/"
  step_concurrency_level                         = var.step_concurrency_level
  configurations_json                            = var.configurations_json

  # Lambda variables
  lambda_s3_key                = var.lambda_s3_key
  lambda_name                  = "${var.environment}-${var.project_name}-lambda"
  lambda_runtime               = var.lambda_runtime
  lambda_trigger_s3_bucket_arn = var.s3_raw_transfer_bucket_arn
  lambda_trigger_s3_bucket_id  = var.s3_raw_transfer_bucket_name
  lambda_environment_variables = var.lambda_environment_variables
  lambda_s3_local              = var.lambda_s3_local
  regex_file_name              = var.regex_file_name

  # SQS variables
  sqs_name = "${var.environment}-${var.project_name}-sqs"

  # SNS variables
  sns_name = "${var.environment}-${var.project_name}-sns"

  enable_kms_access    = var.enable_kms_access
  enable_cloudwatch    = var.enable_cloudwatch
  enable_s3_vpce       = var.enable_s3_vpce
  enable_dynamodb_vpce = var.enable_dynamodb_vpce
  emr_secret_names     = var.emr_secret_names
  enable_notification  = var.enable_s3_notification
}

