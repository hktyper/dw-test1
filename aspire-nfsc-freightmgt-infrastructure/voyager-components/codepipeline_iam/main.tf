/**
 * # CodePipeline IAM Module
 *
 * Deploy IAM roles in a specific account to be assumed by CodeBuild. This will
 * allow resources to be deployed into multiple accounts from a single file.
 *
 * This will need to be deployed locally first as the pipeline won't have
 * permissions to deploy these to other accounts.
 */

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "codebuild_custom_role" {
  name                 = "${var.service_name}-${var.environment}-cicd-custom-iam-codebuild"
  tags                 = var.tags
  permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/ccoe/js-developer"
  assume_role_policy = templatefile(
    "${path.module}/policies/codebuild_role.json.tpl",
    {
      codepipeline_account_id = var.codepipeline_account_id
    }
  )
}

resource "aws_iam_role_policy" "codebuild_terraform_policy" {
  name   = "${var.service_name}-${var.environment}-cicd-custom-iam-codebuild"
  role   = aws_iam_role.codebuild_custom_role.id
  policy = file("${path.module}/policies/codebuild_policy.json")
}
