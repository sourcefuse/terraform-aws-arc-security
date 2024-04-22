resource "aws_kms_key" "this" {
  count = var.enable_guard_duty ? 1 : 0

  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = local.key_policy
  description             = "KMS"
  multi_region            = false

  tags = var.tags
}

resource "aws_kms_alias" "this" {
  count         = var.enable_guard_duty ? 1 : 0
  name          = "alias/${var.namespace}/${var.environment}/guard-duty"
  target_key_id = aws_kms_key.this[0].key_id
}

module "sns_guard_duty" {
  source  = "cloudposse/sns-topic/aws"
  version = "0.21.0"
  enabled = var.enable_guard_duty

  name              = "${local.name_prefix}-guard-duty"
  subscribers       = var.guard_duty_sns_subscribers
  kms_master_key_id = var.enable_guard_duty ? aws_kms_key.this[0].arn : null
  sqs_dlq_enabled   = false

  tags = var.tags
}
