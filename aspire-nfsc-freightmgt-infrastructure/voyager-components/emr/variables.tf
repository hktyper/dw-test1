##### GENERAL ##############################################################################################

variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "name" {
  type        = string
  description = "Name of the application"
  default     = "voyager"
}

variable "environment" {
  type        = string
  description = "This is the name of the deployment environment. The options are as follows: dev, preprod, prod."
}

variable "project_name" {
  type        = string
  description = "Name of the project."
  default     = "voyager"
}

variable "owner" {
  type        = string
  description = "Owner of the pipeline."
}

variable "email" {
  type        = string
  description = "email of the owner of the pipeline."
}

variable "costcentre" {
  type        = string
  description = "Costcentre code, this controls who gets billed for what resources."
}

variable "live" {
  type        = string
  description = "Is the deployed solution live. e.g yes or no"
  default     = "no"
}

locals {
  tags = {
    "environment"  = var.environment
    "email"        = var.email
    "owner"        = var.owner
    "costcentre"   = var.costcentre
    "live"         = var.live
    "project_name" = var.project_name
  }
}

##### S3.TF ##############################################################################################

variable "access_logs_bucket" {
  type        = string
  description = "The name of the log bucket to place logs into"
}
variable "account_number" {
  type        = string
  description = "The AWS Account Number of this bucket"
}

variable "voyager_artefacts_dir_regex" {
  type        = string
  description = "A regex pattern for the voyager artefacts that should be uploaded to the artefacts bucket."
  default     = ""
}

variable "voyager_artefacts_dir" {
  type        = string
  description = "Local path for a directory that contains the voyager artefacts created via CI/CD"
  default     = ""
}

variable "lambda_environment_variables" {
  type        = map
  description = "Environmental variables to be set within the lambda environment."
  default     = {}
}

variable "lambda_runtime" {
  type        = string
  description = "https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html"
}

variable "lambda_s3_local" {
  type        = string
  description = "The file path to the local lambda-emr.zip file to be send to the artefacts S3 bucket."
  default     = "lambda-emr.zip"
}

variable "lambda_s3_key" {
  type        = string
  description = "Key of object containing Lambda deployment zip"
  default     = "lambda-emr.zip"
}

variable "regex_file_name" {
  type        = string
  description = "Name of the regex map to enable the EMR to utilise the correct config file."
}

variable "enable_s3_failed_file_bucket_creation" {
  type        = bool
  description = "Toggle whether the component creates the S3 failed file bucket"
  default     = false
}

variable "enable_s3_access_log_bucket_creation" {
  type        = bool
  description = "Toggle whether the component creates the S3 access log bucket"
  default     = false
}

##### main.TF ##############################################################################################

variable "vpc_id" {
  type        = string
  description = "The VPC ID to deploy the EMR instance into"
}

variable "subnet_id" {
  type        = string
  description = "The Subnet ID to deploy the EMR instance into"
}

variable "private_route_table_ids" {
  type        = list(string)
  description = "The Private Route Table IDs to deploy the EMR instance into"
}

variable "vpc_cidr" {
  type        = string
  description = "The VPC CIDR range to deploy the EMR instance into"
}

variable "step_concurrency_level" {
  type        = number
  description = "The number of steps that can be executed concurrently. You can specify a maximum of 256 steps. Only valid for EMR clusters with release_label 5.28.0 or greater."
  default     = 256
}

variable "subnet_type" {
  type        = string
  description = "Type of VPC subnet ID where you want the job flow to launch. Supported values are `private` or `public`"
  default     = "private"
}

variable "ebs_root_volume_size" {
  type        = number
  description = "Size in GiB of the EBS root device volume of the Linux AMI that is used for each EC2 instance. Available in Amazon EMR version 4.x and later"
  default     = 10
}

variable "visible_to_all_users" {
  type        = bool
  description = "Whether the job flow is visible to all IAM users of the AWS account associated with the job flow"
  default     = true
}

variable "release_label" {
  type        = string
  description = "The release label for the Amazon EMR release. https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-release-5x.html"
  default     = "emr-5.25.0"
}

variable "applications" {
  type        = list(string)
  description = "A list of applications for the cluster. Valid values are: Flink, Ganglia, Hadoop, HBase, HCatalog, Hive, Hue, JupyterHub, Livy, Mahout, MXNet, Oozie, Phoenix, Pig, Presto, Spark, Sqoop, TensorFlow, Tez, Zeppelin, and ZooKeeper (as of EMR 5.25.0). Case insensitive"
}

variable "custom_ami_id" {
  type        = string
  description = "A custom Amazon Linux AMI for the cluster (instead of an EMR-owned AMI). Available in Amazon EMR version 5.7.0 and later"
}

variable "core_instance_group_instance_type" {
  type        = string
  description = "EC2 instance type for all instances in the Core instance group"
}

variable "core_instance_group_instance_count" {
  type        = number
  description = "Target number of instances for the Core instance group. Must be at least 1"
  default     = 1
}

variable "core_instance_group_ebs_size" {
  type        = number
  description = "Core instances volume size, in gibibytes (GiB)"
}

variable "core_instance_group_ebs_type" {
  type        = string
  description = "Core instances volume type. Valid options are `gp2`, `io1`, `standard` and `st1`"
  default     = "gp2"
}

variable "core_instance_group_ebs_volumes_per_instance" {
  type        = number
  description = "The number of EBS volumes with this configuration to attach to each EC2 instance in the Core instance group"
  default     = 1
}

variable "master_instance_group_instance_type" {
  type        = string
  description = "EC2 instance type for all instances in the Master instance group"
}

variable "master_instance_group_instance_count" {
  type        = number
  description = "Target number of instances for the Master instance group. Must be at least 1"
  default     = 1
}

variable "master_instance_group_ebs_size" {
  type        = number
  description = "Master instances volume size, in gibibytes (GiB)"
}

variable "master_instance_group_ebs_type" {
  type        = string
  description = "Master instances volume type. Valid options are `gp2`, `io1`, `standard` and `st1`"
  default     = "gp2"
}

variable "master_instance_group_ebs_volumes_per_instance" {
  type        = number
  description = "The number of EBS volumes with this configuration to attach to each EC2 instance in the Master instance group"
  default     = 1
}

variable "create_task_instance_group" {
  type        = bool
  description = "Whether to create an instance group for Task nodes. For more info: https://www.terraform.io/docs/providers/aws/r/emr_instance_group.html, https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-master-core-task-nodes.html"
  default     = false
}

variable "log_uri" {
  type        = string
  description = "The path to the Amazon S3 location where logs for this cluster are stored. Only s3n protocol is supported as opposed to s3n and s3a."
  default     = ""
}

variable "regex_prefix" {
  type        = list(string)
  description = "List of kafka topics for the regex prefix used in the pre_deploy.sh hook"
  default     = []
}

variable "enable_kms_access" {
  type        = bool
  description = "This variable allows the EMR to access KMS secrets"
  default     = false
}

variable "enable_cloudwatch" {
  type        = bool
  description = "This variable allows the EMR to access Cloudwatch logs"
  default     = false
}

variable "enable_s3_vpce" {
  type        = bool
  description = "This variable allows the EMR to create VPC endpoint for S3"
  default     = true
}

variable "enable_dynamodb_vpce" {
  type        = bool
  description = "This variable allows the EMR to create VPC endpoint for DynamoDB"
  default     = true
}

variable "emr_secret_names" {
  type        = list(string)
  description = "A list of secrets that the EMR needs access for PII data processing."
  default     = []
}

variable "s3_raw_transfer_bucket_name" {
  type        = string
  description = "The bucket name for the transfer bucket"
}

variable "s3_raw_transfer_bucket_arn" {
  type        = string
  description = "The bucket arn for the transfer bucket"
}

variable "configurations_json" {
  type        = string
  description = "A JSON string for supplying list of configurations for the EMR cluster. See https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-configure-apps.html for more details"
  default     = null
}

##### pre_deploy.sh ##############################################################################################

variable "deploy_voyager_app" {
  type        = bool
  description = "Toggle whether the EMR component deploys voyager-app"
  default     = false
}

variable "voyager_app_repo" {
  type        = string
  description = "Git URL for the voyager-app repo for pre_deploy.sh to clone from"
  default     = "github.com:JSainsburyPLC/voyager-app.git"
}

variable "voyager_app_branch" {
  type        = string
  description = "What branch/version of voyager_app to download from"
  default     = "develop_lime"
}

variable "enable_s3_notification" {
  type        = bool
  description = "Boolean value: choose if you want s3 notification or not"
  default     = true
}
