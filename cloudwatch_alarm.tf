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

resource "aws_cloudwatch_log_group" "app_log_group" {
  name = "/aws/lambda/my-app-log-group"
}

resource "aws_cloudwatch_log_metric_filter" "error_filter" {
  name           = "error-metric"
  pattern        = "ERROR"
  log_group_name = aws_cloudwatch_log_group.app_log_group.name # Ensure this resource exists

  metric_transformation {
    name      = "ErrorCount"
    namespace = "LogMetrics"
    value     = "1"
  }
}
