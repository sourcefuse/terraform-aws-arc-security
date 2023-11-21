output "security_hub_enabled_subscriptions" {
  description = "A list of subscriptions that have been enabled"
  value       = module.security_hub.enabled_subscriptions
}

output "security_hub_sns_topic" {
  description = "The SNS topic that was created"
  value       = module.security_hub.sns_topic
}

output "security_hub_sns_topic_subscriptions" {
  description = "The SNS topic that was created"
  value       = module.security_hub.sns_topic_subscriptions
}

output "guard_duty_detector" {
  description = "GuardDuty detector"
  value       = module.guard_duty.guardduty_detector
}

output "guard_duty_sns_topic" {
  description = "SNS topic"
  value       = module.guard_duty.sns_topic
}

output "guard_duty_sns_topic_subscriptions" {
  description = "SNS topic subscriptions"
  value       = module.guard_duty.sns_topic_subscriptions
}

output "aws_config_configuration_recorder_id" {
  value       = module.config.aws_config_configuration_recorder_id
  description = "The ID of the AWS Config Recorder"
}

output "aws_config_iam_role" {
  description = <<-DOC
  IAM Role used to make read or write requests to the delivery channel and to describe the AWS resources associated with
  the account.
  DOC
  value       = module.config.iam_role
}

output "aws_config_sns_topic" {
  description = "SNS topic"
  value       = module.config.sns_topic
}

output "aws_config_sns_topic_subscriptions" {
  description = "SNS topic subscriptions"
  value       = module.config.sns_topic_subscriptions
}

output "inspector_assessment_target" {
  description = "The AWS Inspector assessment target"
  value       = module.inspector.inspector_assessment_target
}

output "aws_inspector_assessment_template" {
  description = "The AWS Inspector assessment template"
  value       = module.inspector.aws_inspector_assessment_template
}

output "inspector_aws_cloudwatch_event_rule" {
  description = "The AWS Inspector event rule"
  value       = module.inspector.aws_cloudwatch_event_rule
}

output "inspector_aws_cloudwatch_event_target" {
  description = "The AWS Inspector event target"
  value       = module.inspector.aws_cloudwatch_event_target
}
