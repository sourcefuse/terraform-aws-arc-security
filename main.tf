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

  environment = var.environment
  namespace   = var.namespace
  name        = "${var.environment}-${var.namespace}-security-hub"

  create_sns_topic  = var.create_sns_topic
  enabled_standards = var.enabled_standards
  subscribers       = length(var.security_hub_sns_subscribers) > 0 ? var.security_hub_sns_subscribers : local.security_hub_sns_subscribers

  tags = module.tags.tags
}

module "guard_duty" {
  source  = "cloudposse/guardduty/aws"
  version = "0.5.0"

  environment = var.environment
  namespace   = var.namespace
  name        = "${var.environment}-${var.namespace}-guard-duty"

  create_sns_topic      = var.create_sns_topic
  enable_cloudwatch     = var.enable_cloudwatch
  s3_protection_enabled = var.s3_protection_enabled
  subscribers           = length(var.guard_duty_sns_subscribers) > 0 ? var.guard_duty_sns_subscribers : local.guard_duty_sns_subscribers

  tags = module.tags.tags
}

module "aws_config_storage" {
  source  = "cloudposse/config-storage/aws"
  version = "1.0.0"

  environment   = var.environment
  namespace     = var.namespace
  name          = "${var.environment}-${var.namespace}-aws-config-storage"
  force_destroy = var.force_destroy

  tags = module.tags.tags
}

module "config" {
  source  = "cloudposse/config/aws"
  version = "1.1.0"

  environment = var.environment
  namespace   = var.namespace
  name        = "${var.environment}-${var.namespace}-aws-config"

  create_sns_topic                 = var.create_sns_topic
  create_iam_role                  = var.create_iam_role
  force_destroy                    = var.force_destroy
  global_resource_collector_region = var.region
  managed_rules                    = length(var.managed_rules) > 0 ? var.managed_rules : local.managed_rules
  s3_bucket_id                     = module.aws_config_storage.bucket_id
  s3_bucket_arn                    = module.aws_config_storage.bucket_arn
  subscribers           = length(var.aws_config_sns_subscribers) > 0 ? var.aws_config_sns_subscribers : local.aws_config_sns_subscribers

  tags = module.tags.tags
}

module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.3"

  environment = var.environment
  project     = var.project

  extra_tags = {
    Repo         = "github.com/sourcefuse/terraform-aws-arc-security"
    MonoRepo     = "True"
    MonoRepoPath = "terraform/security"
  }
}

