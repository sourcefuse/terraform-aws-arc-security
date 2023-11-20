################################################################################
## defaults
################################################################################
terraform {
  required_version = "~> 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.3"

  environment = var.environment
  project     = var.project

  extra_tags = {
    Repo         = "github.com/sourcefuse/refarch-devops-infra"
    MonoRepo     = "True"
    MonoRepoPath = "terraform/security"
  }
}


module "cloud_security" {
  # source      = "git::https://github.com/sourcefuse/terraform-aws-arc-security.git?ref=feature/working-example"
  source      = "../" // local development
  region      = var.region
  environment = var.environment
  namespace   = var.namespace
  project     = var.project

  enable_inspector    = true
  enable_aws_config   = true
  enable_guard_duty   = true
  enable_security_hub = true

  create_config_iam_role = true

  aws_config_sns_subscribers   = local.aws_config_sns_subscribers
  guard_duty_sns_subscribers   = local.guard_duty_sns_subscribers
  security_hub_sns_subscribers = local.security_hub_sns_subscribers

  aws_config_managed_rules = var.aws_config_managed_rules

  create_inspector_iam_role               = var.create_inspector_iam_role
  inspector_enabled_rules                 = var.inspector_enabled_rules
  inspector_schedule_expression           = var.inspector_schedule_expression
  inspector_assessment_event_subscription = var.inspector_assessment_event_subscription

  tags = module.tags.tags
}
