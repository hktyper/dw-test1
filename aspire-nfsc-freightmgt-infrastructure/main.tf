terraform {
  backend "s3" {
    bucket               = "grada-nfsc-terraform-state"
    workspace_key_prefix = "k_n"
    key                  = "k_n/k_n-terraform.tfstate"
    region               = "eu-west-1"
    session_name         = "terraform"
    encrypt              = true
  }
}

module "baseline_account" {
  source         = "git@github.com:JSainsburyPLC/aspire-common-terraform-modules.git//modules/baseline_account?ref=v3.0.4"
  enable         = contains(["preprod", "prod"], var.environment[terraform.workspace])
  aws_account_id = data.aws_caller_identity.current.account_id
  region         = var.region[terraform.workspace]
  project_name   = local.common_tags.project
  environment    = var.environment[terraform.workspace]

  audit_aws_account_id           = var.aws_audit_account_id[terraform.workspace]
  audit_vpc_flowlogs_s3_bucket   = module.flowlogs_s3.s3_bucket_name
  audit_s3_access_logs_s3_bucket = "${data.aws_caller_identity.current.account_id}-s3-access-logs"

  tags = local.common_tags
}


resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = "aspire-nfsc-freightmgt-cloudwatch-${var.environment[terraform.workspace]}-log-group"
  retention_in_days = var.logs_retention
  tags              = local.common_tags
}

resource "aws_ecs_cluster" "freightmgt_ecs_cluster" {
  name = "aspire-nfsc-freightmgt-${var.environment[terraform.workspace]}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = local.common_tags
}

module "ecs-scheduled-task" {
  source      = "./modules/ecs-scheduled-task"
  for_each    = local.knn_table_config
  environment = terraform.workspace

  ecs_cluster_arn = aws_ecs_cluster.freightmgt_ecs_cluster.arn

  ecs_task_name     = "${each.key}-${var.environment[terraform.workspace]}-task"
  ecs_task_role_arn = aws_iam_role.ecs_task_role.arn
  task_count        = "1"
  ecs_subnets       = module.vpc.private_subnet_ids
  launch_type       = var.launch_type
  cpu               = each.value.cpu
  memory            = each.value.memory
  assign_public_ip  = false

  container_definitions = templatefile("${path.module}/templates/container_definition.tmpl",
    {
      name                  = each.key,
      image                 = var.ecr_image_url[terraform.workspace],
      knn_service_url       = var.knn_service_url,
      table_name            = each.key,
      target_bucket         = var.local_landing_bucket[terraform.workspace],
      secret_name           = var.secret_name,
      rlimit                = each.value.rlimit,
      cw_namespace          = local.cw_namespace,
      awslogs-group         = aws_cloudwatch_log_group.cloudwatch_log_group.name,
      awslogs-stream-prefix = "api-downloader"
    }
  )

  enable_scheduling         = var.enable_task_scheduling[terraform.workspace]
  event_schedule_expression = "cron(0 5,10,13 * * ? *)"

  tags = local.common_tags
  #  ECS task role depends on this IAM policy being created and then attached to the role.
  depends_on = [aws_iam_policy.ecs_task_policy]
}

resource "aws_ecs_service" "api-downloader" {
  for_each = local.knn_table_config

  name            = "${var.service_name}-${each.key}"
  cluster         = aws_ecs_cluster.freightmgt_ecs_cluster.arn
  task_definition = module.ecs-scheduled-task[each.key].ecs_task_definition_arn
  launch_type     = var.launch_type

  network_configuration {
    subnets          = module.vpc.private_subnet_ids
    assign_public_ip = false
  }

  tags = local.common_tags
  #  Task definition depends on the ECS task role which depends on this IAM policy being created and then attached to the role.
  depends_on = [aws_iam_policy.ecs_task_policy]
}

module "sqs" {
  source = "./modules/sqs"

  project_name = "aspire-nfsc-freightmgt"
  bucket_name  = var.local_landing_bucket[terraform.workspace]
  environment  = var.environment[terraform.workspace]

  tags = local.common_tags
}

module "monitoring_and_alerting" {
  source       = "./modules/monitoring"
  environment  = var.environment[terraform.workspace]
  service_name = var.service_name
  tables       = local.knn_table_list
  table_config = local.knn_table_config
  log_group    = aws_cloudwatch_log_group.cloudwatch_log_group.name
  namespace    = local.cw_namespace
  tags         = local.common_tags
}
