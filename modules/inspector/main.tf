terraform {
  required_version = "~> 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

resource "aws_inspector2_organization_configuration" "this" {
  count = var.enable_inspector_at_orgnanization ? 1 : 0
  auto_enable {
    ec2         = local.resource_types_to_in_org.ec2
    ecr         = local.resource_types_to_in_org.ecr
    lambda      = local.resource_types_to_in_org.lambda
    lambda_code = local.resource_types_to_in_org.lambda_code
  }
}

resource "aws_inspector2_member_association" "this" {
  for_each   = var.add_inspector_member_accounts ? toset(var.account_list) : toset([])
  account_id = each.value
}

resource "aws_inspector2_enabler" "this" {
  count          = var.enable_inspector_at_orgnanization ? 0 : 1
  account_ids    = var.account_list
  resource_types = var.resource_types

  timeouts {
    create = "30m"
    delete = "30m"
  }
}

resource "aws_cloudwatch_event_rule" "this" {
  name        = "detect-inspector-finding"
  description = "An EventBridge/CloudWatch Event Rule that triggers on Amazon Inspector findings. The Event Rule can be used to trigger notifications or remediative actions using AWS Lambda."
  event_pattern = jsonencode({
    detail-type = ["Inspector2 Finding"]
    source      = ["aws.inspector2"]
  })
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "this" {
  rule      = aws_cloudwatch_event_rule.this.name
  target_id = "SendToSNS"
  arn       = module.sns_topic.sns_topic_arn
}
