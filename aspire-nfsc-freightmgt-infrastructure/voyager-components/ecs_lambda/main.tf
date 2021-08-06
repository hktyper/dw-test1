/**
 * # Fargate_ECS Lambda Voyager Component
 *
 * This module creates a Lambda function designed to be able to kick off a Voyager ECS task.
 * Note that this is just the infrastructural backbone for the Lambda - the code itself has
 * to be uploaded separately in order to keep it easy to update without forcing a redeploy.
 *
 * Additionally, you have the option of adding a source mapping from SQS to the Lambda
 * to allow the function to be triggered by SQS events.
 * Again, note that this only provides the *skeleton* to plug your own SQS infrastructure into.
*/


module "lambda" {
  source = "git@github.com:JSainsburyPLC/aspire-common-terraform-modules.git//modules/lambda?ref=develop"

  app_name    = var.lambda_app_name
  project     = var.project_name
  environment = var.environment
  tags        = local.tags

  lambda_runtime     = var.lambda_runtime
  lambda_handler     = var.lambda_handler
  lambda_zip_path    = var.lambda_zip_path
  lambda_memory_size = var.lambda_memory_size

  lambda_vpc_id         = var.vpc_id
  lambda_subnet_ids     = var.subnet_ids
  lambda_timeout        = var.lambda_timeout # seconds
  lambda_iam_statements = var.iam_statements

  lambda_environment_variables = var.lambda_environment_variables
}

resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  count            = var.trigger_on_sqs ? 1 : 0
  event_source_arn = var.trigger_sqs_arn
  enabled          = var.trigger_on_sqs
  function_name    = module.lambda.lambda_arn
  batch_size       = var.sqs_trigger_batch_size
}
