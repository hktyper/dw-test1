data "aws_iam_policy_document" "ecs_task_role" {
  statement {
    effect = "Allow"
    actions = [
      "sqs:GetQueueUrl",
      "sqs:ReceiveMessage",
      "sqs:GetQueueAttributes",
      "sqs:ListQueueTags",
      "sqs:ListDeadLetterSourceQueues",
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetSecretValue",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObjectAcl",
      "s3:GetObject",
      "s3:AbortMultipartUpload",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::${var.dpp_bucket[terraform.workspace]}/*",
      "arn:aws:s3:::${var.local_landing_bucket[terraform.workspace]}/*",
      "arn:aws:sqs:${var.region[terraform.workspace]}:${data.aws_caller_identity.current.account_id}:*",
      "arn:aws:secretsmanager:${var.region[terraform.workspace]}:${data.aws_caller_identity.current.account_id}:secret:*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "sqs:ListQueues",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucket",
      "cloudwatch:PutMetricData"
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ecs_task_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "ecs_task_policy" {
  name   = "${terraform.workspace}-nfsc-freightmgt-ecs-task-policy"
  policy = data.aws_iam_policy_document.ecs_task_role.json
}

resource "aws_iam_role" "ecs_task_role" {
  name                 = "${terraform.workspace}-nfsc-freightmgt-ecs-task-role"
  assume_role_policy   = data.aws_iam_policy_document.ecs_task_assume_role_policy.json
  permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/ccoe/js-developer"

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policy_attach" {
  policy_arn = aws_iam_policy.ecs_task_policy.arn
  role       = aws_iam_role.ecs_task_role.name
}
