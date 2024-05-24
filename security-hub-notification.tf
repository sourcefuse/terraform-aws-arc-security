# This section is only if Notification is required when SecurityHub is already enabled
data "aws_iam_policy_document" "securityhub_sns_kms_key_policy" {
  count = local.enable_just_security_hub_notification ? 1 : 0

  policy_id = "EventBridgeEncryptUsingKey"

  statement {
    effect = "Allow"
    actions = [
      "kms:*"
    ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:${one(data.aws_partition.current[*].partition)}:iam::${one(data.aws_caller_identity.current[*].account_id)}:root"]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

module "securityhub_sns_kms_key" {
  source  = "cloudposse/kms-key/aws"
  version = "0.12.2"
  count   = local.enable_just_security_hub_notification ? 1 : 0

  name                = "${local.name_prefix}-security-hub-sns"
  description         = "KMS key for the security-hub SNS topic"
  enable_key_rotation = true
  alias               = "alias/${local.name_prefix}/security-hub-sns"
  policy              = local.enable_just_security_hub_notification ? data.aws_iam_policy_document.securityhub_sns_kms_key_policy[0].json : ""

}

module "securityhub_sns_topic" {
  source  = "cloudposse/sns-topic/aws"
  version = "0.21.0"
  count   = local.enable_just_security_hub_notification ? 1 : 0

  attributes        = ["securityhub"]
  subscribers       = var.security_hub_sns_subscribers
  sqs_dlq_enabled   = false
  kms_master_key_id = local.enable_just_security_hub_notification ? module.securityhub_sns_kms_key[0].alias_name : ""

  allowed_aws_services_for_sns_published = ["events.amazonaws.com"]
}

resource "aws_cloudwatch_event_rule" "imported_findings" {
  count       = local.enable_just_security_hub_notification ? 1 : 0
  name        = "${local.name_prefix}-security-hub-event-rule"
  description = "SecurityHubEvent - Imported Findings"

  event_pattern = jsonencode(
    {
      "source" : [
        "aws.securityhub"
      ],
      "detail-type" : [
        "Security Hub Findings - Imported"
      ]
    }
  )
  tags = var.tags
}

resource "aws_cloudwatch_event_target" "security_hub_imported_findings" {
  count = local.enable_just_security_hub_notification ? 1 : 0
  rule  = local.enable_just_security_hub_notification ? aws_cloudwatch_event_rule.imported_findings[0].name : null
  arn   = local.enable_just_security_hub_notification ? module.securityhub_sns_topic[0].sns_topic_arn : ""
}
