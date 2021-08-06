locals {
  permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/ccoe/js-developer"
}

resource "aws_iam_role" "ecs_events" {
  name                 = "${var.environment}-${var.ecs_task_name}-ecs-events-role"
  assume_role_policy   = data.aws_iam_policy_document.ecs_events_assume_role_policy.json
  permissions_boundary = local.permissions_boundary
  tags                 = var.tags
}

resource "aws_iam_role" "ecs_execution_role" {
  name                 = "${var.environment}-${var.ecs_task_name}-ecs-execution-role"
  assume_role_policy   = data.aws_iam_policy_document.ecs_task_assume_role_policy.json
  permissions_boundary = local.permissions_boundary
  tags                 = var.tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_execution_role.name
}

resource "aws_iam_role_policy_attachment" "ecs_execution_cw_policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role       = aws_iam_role.ecs_execution_role.name
}

resource "aws_iam_role_policy_attachment" "ecs_events_policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
  role       = aws_iam_role.ecs_events.name
}
