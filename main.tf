terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2"
    }
  }
}

################################################################################
## security hub
################################################################################


module "security_hub" {
  source  = "cloudposse/security-hub/aws"
  version = "0.10.0"

  name = local.name_prefix

  create_sns_topic  = true
  enabled_standards = var.enabled_standards
  subscribers       = length(var.security_hub_sns_subscribers) > 0 ? var.security_hub_sns_subscribers : local.security_hub_sns_subscribers

  tags = module.tags.tags
}

module "guard_duty" {
  source  = "cloudposse/guardduty/aws"
  version = "0.5.0"

  name                      = local.name_prefix
  create_sns_topic          = false
  findings_notification_arn = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${local.name_prefix}-guard-duty"
  s3_protection_enabled     = var.s3_protection_enabled

  tags = module.tags.tags

  depends_on = [module.sns_guard_duty]
}

module "aws_config_storage" {
  source  = "cloudposse/config-storage/aws"
  version = "1.0.0"

  name          = local.name_prefix
  force_destroy = var.config_storage_bucket_force_destroy

  tags = module.tags.tags
}

module "config" {
  source  = "cloudposse/config/aws"
  version = "1.1.0"

  name = local.name_prefix

  create_sns_topic                 = true
  sns_encryption_key_id            = length(var.cloud_security_kms_key_id) > 0 ? var.cloud_security_kms_key_id : aws_kms_alias.cloud_security.name
  sqs_queue_kms_master_key_id      = length(var.cloud_security_kms_key_id) > 0 ? var.cloud_security_kms_key_id : aws_kms_alias.cloud_security.name
  create_iam_role                  = var.create_config_iam_role
  force_destroy                    = var.force_destroy
  global_resource_collector_region = var.region
  managed_rules                    = length(var.managed_rules) > 0 ? var.managed_rules : local.managed_rules
  s3_bucket_id                     = module.aws_config_storage.bucket_id
  s3_bucket_arn                    = module.aws_config_storage.bucket_arn
  subscribers                      = length(var.aws_config_sns_subscribers) > 0 ? var.aws_config_sns_subscribers : local.aws_config_sns_subscribers

  tags = module.tags.tags

}

module "inspector" {

  source  = "cloudposse/inspector/aws"
  version = "0.4.0"

  enabled = var.create_inspector

  name                          = local.name_prefix
  create_iam_role               = var.create_inspector_iam_role
  enabled_rules                 = var.inspector_enabled_rules
  schedule_expression           = var.inspector_schedule_expression
  assessment_event_subscription = local.assessment_event_subscriptions

  tags = module.tags.tags

  depends_on = [module.sns_inspector]
}

module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.3"

  environment = local.environment
  project     = local.project

  extra_tags = {
    Repo         = "github.com/sourcefuse/terraform-aws-arc-security"
    MonoRepo     = "True"
    MonoRepoPath = "terraform/security"
  }
}

