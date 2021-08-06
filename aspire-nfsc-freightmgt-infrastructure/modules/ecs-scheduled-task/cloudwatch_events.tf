resource "aws_cloudwatch_event_rule" "cloudwatch_event_rule" {
  count = var.enable_scheduling == true ? 1 : 0

  name                = var.ecs_task_name
  schedule_expression = var.event_schedule_expression
  tags                = var.tags
}

resource "aws_cloudwatch_event_target" "cloudwatch_event_target" {
  count = var.enable_scheduling == true ? 1 : 0

  rule      = aws_cloudwatch_event_rule.cloudwatch_event_rule[count.index].name
  target_id = var.ecs_task_name
  arn       = var.ecs_cluster_arn
  role_arn  = aws_iam_role.ecs_events.arn

  ecs_target {
    launch_type         = var.launch_type
    task_count          = var.task_count
    task_definition_arn = aws_ecs_task_definition.ecs_task_definition.arn
    platform_version    = var.launch_type == "FARGATE" ? var.platform_version : null

    network_configuration {
      assign_public_ip = var.assign_public_ip
      subnets          = var.ecs_subnets
    }
  }

  #  Events IAM role must have this policy attached to it
  depends_on = [aws_iam_role_policy_attachment.ecs_events_policy_attach]
}
