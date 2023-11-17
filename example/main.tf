################################################################################
## defaults
################################################################################
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2"
    }
  }
}
provider "aws" {
  region = var.region
}

module "cloud_security" {
  source = "git::https://github.com/sourcefuse/terraform-aws-arc-security.git?ref=bugfix/sns-encrypt-cmk"
  # source      = "../" // local testing
  region      = var.region
  environment = var.environment
  namespace   = var.namespace
  project     = var.project

  create_sns_topic                    = true
  create_config_iam_role              = true
  force_destroy                       = true
  config_storage_bucket_force_destroy = var.config_storage_bucket_force_destroy

  managed_rules                = var.managed_rules
  aws_config_sns_subscribers   = var.aws_config_sns_subscribers
  guard_duty_sns_subscribers   = var.guard_duty_sns_subscribers
  security_hub_sns_subscribers = var.security_hub_sns_subscribers
  enabled_standards            = var.enabled_standards

  create_inspector              = var.create_inspector
  create_inspector_iam_role     = var.create_inspector_iam_role
  inspector_enabled_rules       = var.inspector_enabled_rules
  inspector_schedule_expression = var.inspector_schedule_expression
  # inspector_assessment_events = var.inspector_assessment_events

  cloud_security_kms_key_id = var.cloud_security_kms_key_id
}


