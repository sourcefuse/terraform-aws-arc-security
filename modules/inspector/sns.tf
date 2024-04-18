module "kms" {
  source  = "cloudposse/kms-key/aws"
  version = "0.12.2"

  name                = "${var.namespace}-${var.environment}-inspector"
  description         = "KMS key for the Inspector Findings SNS topic"
  enable_key_rotation = true
  alias               = "alias/${var.namespace}/${var.environment}/inspector-sns"
  policy              = data.aws_iam_policy_document.kms.json

  context = module.this.context
}

data "aws_iam_policy_document" "kms" {

  policy_id = "${var.namespace}-${var.environment}-inspector-EventBridgeEncryptUsingKey"

  statement {
    effect = "Allow"
    actions = [
      "kms:*"
    ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"]
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

module "sns_topic" {
  source  = "cloudposse/sns-topic/aws"
  version = "0.21.0"

  attributes        = ["inspector"]
  subscribers       = var.subscribers
  sqs_dlq_enabled   = false
  kms_master_key_id = module.kms.alias_name

  allowed_aws_services_for_sns_published = ["events.amazonaws.com"]

  context = module.this.context
}
