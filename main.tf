################################################################################
## security hub
################################################################################
module "security_hub" {
  source  = "cloudposse/security-hub/aws"
  version = "0.12.2"
  enabled = var.enable_security_hub

  name = local.name_prefix

  create_sns_topic  = true
  enabled_standards = local.security_hub_standards
  subscribers       = var.security_hub_sns_subscribers

  tags = var.tags
}

################################################################################
## Guard Duty
################################################################################

module "guard_duty" {
  source  = "cloudposse/guardduty/aws"
  version = "0.6.0"
  count   = var.enable_guard_duty ? 1 : 0

  name = local.name_prefix

  create_sns_topic          = false
  enable_cloudwatch         = true
  s3_protection_enabled     = var.guard_duty_s3_protection_enabled
  findings_notification_arn = "arn:${data.aws_partition.current.partition}:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${local.guard_duty_sns_topic_name}"
  depends_on                = [module.sns_guard_duty]
  tags                      = var.tags
}

################################################################################
## AWS Config
################################################################################

module "aws_config_storage" {
  source  = "cloudposse/config-storage/aws"
  version = "1.0.2"
  enabled = var.enable_aws_config

  name          = local.name_prefix
  force_destroy = var.force_destroy
  tags          = var.tags
}

module "config" {
  source  = "cloudposse/config/aws"
  version = "1.5.2"
  enabled = var.enable_aws_config

  name = local.name_prefix

  create_sns_topic                 = true
  create_iam_role                  = var.create_config_iam_role
  global_resource_collector_region = var.region
  managed_rules                    = length(var.aws_config_managed_rules) > 0 ? var.aws_config_managed_rules : local.aws_config_managed_rules
  s3_bucket_id                     = module.aws_config_storage.bucket_id
  s3_bucket_arn                    = module.aws_config_storage.bucket_arn
  subscribers                      = var.aws_config_sns_subscribers

  tags = var.tags
}

################################################################################
## Inspector
################################################################################

module "inspector" {
  source = "./modules/inspector"

  count = var.enable_inspector ? 1 : 0

  namespace           = var.namespace
  environment         = var.environment
  schedule_expression = var.inspector_schedule_expression

  enable_inspector_at_orgnanization = var.enable_inspector_at_orgnanization

  account_list                  = var.inspector_account_list
  add_inspector_member_accounts = var.add_inspector_member_accounts
  resource_types                = var.inspector_resource_types
  subscribers                   = var.inspector_sns_subscribers

}
