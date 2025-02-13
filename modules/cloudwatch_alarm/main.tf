resource "aws_cloudwatch_log_metric_filter" "error_filter" {
  name           = var.alarm_name
  log_group_name = var.log_group_name
  pattern        = var.filter_pattern

  metric_transformation {
    name      = "errorCount"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "error_alarm" {
  alarm_name          = var.alarm_name
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "errorCount"
  namespace           = "LogMetrics"
  period              = var.period
  statistic           = "Sum"
  threshold           = var.threshold
  alarm_description   = "Triggers when the error count exceeds 10 times in a minute."
  actions_enabled     = true
  alarm_actions       = [var.sns_topic_arn]
}
