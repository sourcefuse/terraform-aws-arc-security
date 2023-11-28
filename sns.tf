locals {
  kms_key_administrators = [
    data.aws_iam_session_context.current.issuer_arn,
    "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"
  ]

  key_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "Allow access for Key Administrators",
        Effect = "Allow",
        Principal = {
          AWS = local.kms_key_administrators
        },
        Action = [
          "kms:*"
        ],
        Resource = "*"
      },
      {
        Sid    = "Allow access to services",
        Effect = "Allow",
        Principal = {
          Service = ["events.amazonaws.com"]
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = "*"
      }
    ]
  })

}
resource "aws_kms_key" "this" {
  count = var.enable_guard_duty ? 1 : 0

  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = local.key_policy
  description             = "KMS"
  multi_region            = false
}

resource "aws_kms_alias" "this" {
  count         = var.enable_guard_duty ? 1 : 0
  name          = "alias/${var.environment}/${var.namespace}/guard-duty"
  target_key_id = aws_kms_key.this[0].key_id
}

module "sns_guard_duty" {
  source  = "cloudposse/sns-topic/aws"
  version = "0.21.0"

  count = var.enable_guard_duty ? 1 : 0

  name              = "${var.environment}-${var.namespace}-guard-duty"
  subscribers       = var.guard_duty_sns_subscribers
  kms_master_key_id = aws_kms_key.this[0].arn
  sqs_dlq_enabled   = false
}
