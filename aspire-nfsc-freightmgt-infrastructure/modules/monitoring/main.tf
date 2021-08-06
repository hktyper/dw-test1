resource "aws_cloudwatch_dashboard" "downloader" {
  dashboard_name = "${var.environment}-${var.service_name}-monitoring"
  dashboard_body = templatefile(local.dashboard_template,
    { tables    = var.tables,
      env       = var.environment,
      service   = var.service_name,
      log_group = var.log_group
    }
  )
}

resource "aws_cloudwatch_metric_alarm" "table_load" {
  for_each = var.table_config

  alarm_name          = "${var.service_name}-${each.key}-${var.environment}-alarm"
  alarm_description   = "Alerts when Total Rows loaded for ${each.key} is lower than expected or missing"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  threshold           = each.value.row_threshold
  metric_name         = "Total Rows"
  namespace           = var.namespace
  period              = 32400
  statistic           = "Maximum"
  treat_missing_data  = "breaching"

  dimensions = {
    TableName = each.key
  }

  alarm_actions = [aws_sns_topic.sns_failures_topic.arn]

  tags = var.tags
}

resource "aws_sns_topic" "sns_failures_topic" {
  name = "${var.environment}-knn-failures"

  tags = var.tags
}
