/**
 * # CodePipeline Terraform Module
 *
 * This module creates the resources for create a CodeBuild/CodePipeline setup
 * for voyager.
 *
 * This needs to be run as part of the bootstrap process for the first time so
 * that the pipeline can be created and used for any subsequent runs. Following
 * that initial deployment, you can use this module to update your Pipeline.
 *
 * Some manual steps are required for deployment:
 *
 * 1. Add a private ssh key to a parameter store secure string and set it in your buildspec
 * 2. Add a github token to a parameter store secure string and set it in a var
 * 3. Add your change api key to parameter store and set the name as part of the buildspec
 * 4. Setup a codestar connection in the project where codepipeline will run and pass it as tfvar
 * 5. If using this component for pull requests, you will need to authenticate
 * the pull request code build job manually against Github so it can clone the
 * repo
 *
 * #### Extra Vars
 *
 * | Name                 | Description                                  | Default   |
 * | -------------------- | -------------------------------------------- | --------- |
 * | build_docker_image   | Boolean on whether to build a docker image   | True      |
 */

locals {
  build_job_env_variables = contains(
    var.build_job_env_variables[*].name, "github_token") ? var.build_job_env_variables : concat(
    [
      {
        name  = "github_token"
        value = var.github_token
        type  = "PARAMETER_STORE"
      }
  ], var.build_job_env_variables)
  image_registry_credentials = "SERVICE_ROLE"
  pull_request_job_filters = [
    {
      type                    = "EVENT"
      pattern                 = "PULL_REQUEST_CREATED, PULL_REQUEST_UPDATED, PULL_REQUEST_REOPENED"
      exclude_matched_pattern = false
    },
    {
      type                    = "BASE_REF"
      pattern                 = "master"
      exclude_matched_pattern = false
    }
  ]
}

data "aws_caller_identity" "current" {}

module "titan" {
  source = "git@github.com:JSainsburyPLC/titan.git//packages/modules/titan_infra?ref=1.2.1"

  # General config
  account_number                 = var.account_number
  service_name                   = var.service_name
  repo_name                      = var.repo_name
  environment                    = var.environment
  application_source_branch      = var.application_source_branch
  codepipeline_github_token_name = var.github_token
  tags                           = var.tags
  pull_request_job_filters       = local.pull_request_job_filters

  # Change API
  service_now_api_key_secret_name = var.change_api_key
  assignment_group                = var.assignment_group
  deployment_item                 = var.deployment_item

  # Docker images
  initialise_job_app_image   = var.docker_image
  deploy_job_app_image       = var.docker_image
  test_job_app_image         = var.docker_image
  build_job_app_image        = var.docker_image
  post_deploy_job_app_image  = var.docker_image
  pull_request_job_app_image = var.docker_image

  image_registry_credentials = local.image_registry_credentials
  codestar_connection_arn    = var.codestar_connection_arn
  git_clone_depth            = var.git_clone_depth
  git_submodules             = var.git_submodules

  # Stage feature switches
  test_enable                    = var.test_enable
  build_enable                   = var.build_enable
  approval_enable                = var.approval_enable
  deploy_enable                  = var.deploy_enable
  post_deploy_enable             = var.post_deploy_enable
  request_change_enable          = var.request_change_enable
  pull_request_enable            = var.pull_request_enable
  pull_request_run_test_enable   = var.pull_request_run_test_enable
  code_analysis_terraform_enable = var.code_analysis_terraform_enable

  # Environment variables
  build_job_env_variables       = local.build_job_env_variables
  test_job_env_variables        = var.test_job_env_variables
  deploy_job_env_variables      = var.deploy_job_env_variables
  post_deploy_job_env_variables = var.post_deploy_job_env_variables

  # Privileged mode feature switch
  build_job_privileged_mode       = var.build_job_privileged_mode
  deploy_job_privileged_mode      = var.deploy_job_privileged_mode
  post_deploy_job_privileged_mode = var.post_deploy_job_privileged_mode

  # Custom role assignment
  pipeline_role   = aws_iam_role.codepipeline_custom_role.arn
  build_job_role  = aws_iam_role.codebuild_custom_role.arn
  deploy_job_role = aws_iam_role.codebuild_custom_role.arn
}

resource "aws_iam_role_policy" "codebuild_cross_account_policies" {
  count = length(var.cross_account_roles)
  name  = "${var.service_name}-${var.environment}-cicd-custom-iam-codebuild-${count.index}"
  role  = aws_iam_role.codebuild_custom_role.id
  policy = templatefile(
    "${path.module}/policies/codebuild_cross_account_policy.json.tpl",
    {
      cross_account_role = var.cross_account_roles[count.index]
    }
  )
}

resource "aws_iam_role" "codebuild_custom_role" {
  name                 = "${var.service_name}-${var.environment}-cicd-custom-iam-codebuild"
  tags                 = var.tags
  permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/ccoe/js-developer"
  assume_role_policy   = file("${path.module}/policies/codebuild_role.json")
}

resource "aws_iam_role" "codepipeline_custom_role" {
  name                 = "${var.service_name}-${var.environment}-cicd-custom-iam-codepipeline"
  tags                 = var.tags
  permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/ccoe/js-developer"
  assume_role_policy   = file("${path.module}/policies/codepipeline_role.json")
}

resource "aws_iam_role_policy" "codebuild_terraform_policy" {
  name = "${var.service_name}-${var.environment}-cicd-custom-iam-codebuild"
  role = aws_iam_role.codebuild_custom_role.id
  policy = templatefile(
    "${path.module}/policies/codebuild_policy.json",
    {
      codestar_connection_arn = var.codestar_connection_arn
    }
  )
}

resource "aws_iam_role_policy" "codepipeline_terraform_policy" {
  name = "${var.service_name}-${var.environment}-cicd-custom-iam-codepipeline"
  role = aws_iam_role.codepipeline_custom_role.id
  policy = templatefile(
    "${path.module}/policies/codepipeline_policy.json",
    {
      service_name            = var.service_name
      environment             = var.environment
      codestar_connection_arn = var.codestar_connection_arn
    }
  )
}
