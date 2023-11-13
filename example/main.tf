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
  source = "git::https://github.com/sourcefuse/terraform-aws-arc-security.git?ref=feature/working-example"
  region      = var.region
  environment = var.environment
  namespace   = var.namespace
  project     = var.project

  create_sns_topic = true
  create_iam_role  = true
  force_destroy    = true

  managed_rules = var.managed_rules
  aws_config_sns_subscribers = var.aws_config_sns_subscribers
  guard_duty_sns_subscribers = var.guard_duty_sns_subscribers
  security_hub_sns_subscribers = var.security_hub_sns_subscribers
  enabled_standards = var.enabled_standards
}


