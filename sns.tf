
resource "aws_kms_key" "cloud_security" {
  deletion_window_in_days = 7
  enable_key_rotation     = false
  policy                  = local.key_policy
  description             = "KMS"
  multi_region            = false
}

resource "aws_kms_alias" "cloud_security" {
  name          = "alias/${local.name_prefix}-cloud-security"
  target_key_id = aws_kms_key.cloud_security.key_id
}

module "sns_guard_duty" {
  source  = "cloudposse/sns-topic/aws"
  version = "0.21.0"

  name              = "${local.name_prefix}-guard-duty"
  namespace         = var.namespace
  kms_master_key_id = aws_kms_key.cloud_security.arn
  sqs_dlq_enabled   = false
  
  subscribers = length(var.guard_duty_sns_subscribers) > 0 ? var.guard_duty_sns_subscribers : local.guard_duty_sns_subscribers
}

module "sns_inspector" {
  source  = "cloudposse/sns-topic/aws"
  version = "0.21.0"

  name              = "${local.name_prefix}-inspector"
  namespace         = var.namespace
  kms_master_key_id = aws_kms_key.cloud_security.arn
  sqs_dlq_enabled   = false
}


