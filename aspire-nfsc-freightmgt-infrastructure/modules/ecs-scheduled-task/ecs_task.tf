resource "aws_ecs_task_definition" "ecs_task_definition" {
  family             = var.ecs_task_name
  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = var.ecs_task_role_arn

  container_definitions = var.container_definitions

  cpu                      = var.cpu
  memory                   = var.memory
  requires_compatibilities = [var.launch_type]
  network_mode             = "awsvpc"
  tags                     = var.tags

  #  Task execution IAM role must have the following policies attached to it
  depends_on = [
    aws_iam_role_policy_attachment.ecs_task_execution_policy_attach,
    aws_iam_role_policy_attachment.ecs_execution_cw_policy_attach
  ]
}
