module "cloudwatch_alarm" {
  source         = "./modules/cloudwatch_alarm"
  log_group_name = "cat-gif-app-log"
  filter_pattern = "ERROR"
  threshold      = 10
  period         = 60
  alarm_name     = "high-error-rate"
  sns_topic_arn  = aws_sns_topic.alarm_notifications.arn
}

resource "aws_sns_topic" "alarm_notifications" {
  name = "alarm-notifications"
}

resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.alarm_notifications.arn
  protocol  = "email"
  endpoint  = "jogesh.bandaru@gmail.com" # Replace with actual email
}

resource "aws_cloudwatch_log_metric_filter" "error_filter" {
  name           = "error-count-filter"
  log_group_name = "cat-gif-app-log"
  pattern        = "ERROR"

  metric_transformation {
    name      = "errorCount"
    namespace = "LogMetrics"
    value     = "1"
  }
}
