output "security_hub_enabled_subscriptions" {
  description = "A list of subscriptions that have been enabled"
  value       = module.cloud_security.security_hub_enabled_subscriptions
}

output "guard_duty_detector" {
  description = "GuardDuty detector"
  value       = module.cloud_security.guard_duty_detector
}

output "aws_config_configuration_recorder_id" {
  value       = module.cloud_security.aws_config_configuration_recorder_id
  description = "The ID of the AWS Config Recorder"
}
