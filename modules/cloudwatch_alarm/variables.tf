variable "log_group_name" {
  description = "The name of the CloudWatch log group to monitor"
  type        = string
}

variable "filter_pattern" {
  description = "The filter pattern to match log events"
  type        = string
}

variable "threshold" {
  description = "The number of occurrences before triggering an alarm"
  type        = number
}

variable "period" {
  description = "The evaluation period in seconds"
  type        = number
}

variable "alarm_name" {
  description = "The name of the CloudWatch alarm"
  type        = string
}

variable "sns_topic_arn" {
  description = "The SNS topic ARN for alarm notifications"
  type        = string
}
