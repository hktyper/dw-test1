variable "environment" {
  description = "The environment that the component will be deployed to"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "The region to deploy to"
  type        = string
  default     = "eu-west-1"
}

variable "service_name" {
  description = "Name of the service"
  type        = string
  default     = "voyager-poc"
}

variable "cross_account_roles" {
  description = "ARNS of Roles that will be assumed from other AWS accounts"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "The tags to use for resources"
  type        = map(string)
  default = {
    servicename = "voyager-poc"
  }
}

variable "repo_name" {
  description = "Name of the service"
  type        = string
  default     = "voyager"
}

variable "application_source_branch" {
  description = "Branch of repository containing source code"
  type        = string
  default     = "integrate-change-api"
}

variable "account_number" {
  description = "AWS account number"
  type        = string
}

variable "deployment_item" {
  description = "Name of the deployment item in service now"
  type        = string
}

variable "assignment_group" {
  description = "Name of the assignment group in service now"
  type        = string
}

variable "github_token" {
  description = "Name of the parameter store item that holds the github token"
  type        = string
}

variable "change_api_key" {
  description = "Name of the parameter store item that holds the change api key"
  type        = string
}

variable "docker_image" {
  description = "The docker image to use for build, test and deploy stages"
  type        = string
  default     = "aws/codebuild/amazonlinux2-x86_64-standard:2.0"
}

variable "codestar_connection_arn" {
  description = "The ARN of the github codestar connection"
  type        = string
}

variable "ecr_url" {
  description = "The ECR url for the docker image to build"
  type        = string
}

variable "test_enable" {
  description = "Feature switch for test job"
  type        = bool
  default     = true
}

variable "build_enable" {
  description = "Feature switch for build job"
  type        = bool
  default     = true
}

variable "approval_enable" {
  description = "Enable wait for manual approval before the Deploy stage"
  type        = bool
  default     = false
}

variable "deploy_enable" {
  description = "Feature switch for deploy job"
  type        = bool
  default     = true
}

variable "post_deploy_enable" {
  description = "Feature switch for post deploy job"
  type        = bool
  default     = true
}

variable "request_change_enable" {
  description = "Feature switch the Change API for non production deploys"
  type        = bool
  default     = false
}


variable "initialise_job_env_variables" {
  description = "Initialise job variables to be passed into job"
  type = list(object({
    name  = string
    value = string
    type  = string
  }))
  default = []
}

variable "build_job_env_variables" {
  description = "Build job variables to be passed into job"
  type = list(object({
    name  = string
    value = string
    type  = string
  }))
  default = []
}

variable "test_job_env_variables" {
  description = "Test job variables to be passed into job"
  type = list(object({
    name  = string
    value = string
    type  = string
  }))
  default = []
}

variable "deploy_job_env_variables" {
  description = "Deploy job variables to be passed into job"
  type = list(object({
    name  = string
    value = string
    type  = string
  }))
  default = []
}

variable "post_deploy_job_env_variables" {
  description = "Post deploy job variables to be passed into job"
  type = list(object({
    name  = string
    value = string
    type  = string
  }))
  default = []
}

variable "build_job_privileged_mode" {
  description = "Start docker daemon in job"
  type        = bool
  default     = false
}

variable "deploy_job_privileged_mode" {
  description = "Start docker daemon in job"
  type        = bool
  default     = true
}

variable "post_deploy_job_privileged_mode" {
  description = "Start docker daemon in job"
  type        = bool
  default     = false
}

variable "git_clone_depth" {
  description = "Git Clone depth for CodeBuild projects. Set to 0 for full clone."
  type        = number
  default     = 1
}

variable "git_submodules" {
  description = "If set to true, fetches Git submodules for the AWS CodeBuild build project. Requires HTTPS submodule URL"
  type        = bool
  default     = false
}

variable "pull_request_enable" {
  description = "If set to true, enable running on Pull Requests"
  type        = bool
  default     = false
}

variable "pull_request_run_test_enable" {
  description = "If set to true, enable running the test job on Pull Requests"
  type        = bool
  default     = false
}

variable "code_analysis_terraform_enable" {
  description = "If set to true, enable running on terraform code analysis in all branches"
  type        = bool
  default     = false
}
