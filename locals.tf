locals {

  environment = var.environment
  project     = var.project
  name_prefix = "${var.namespace}-${var.environment}"

  assessment_event_subscriptions = {
    assessment_completed = {
      event = "ASSESSMENT_RUN_COMPLETED"
      topic_arn = "${module.sns_inspector.sns_topic_arn}"
    }
  }

  guard_duty_sns_subscribers = {
    opsgenie = {
      protocol               = "https"
      endpoint               = ""
      endpoint_auto_confirms = true
      raw_message_delivery   = false
    }
  }
  security_hub_sns_subscribers = {
    opsgenie = {
      protocol               = "https"
      endpoint               = ""
      endpoint_auto_confirms = true
      raw_message_delivery   = false
    }
  }

  aws_config_sns_subscribers = {
    opsgenie = {
      protocol               = "https"
      endpoint               = ""
      endpoint_auto_confirms = true
      raw_message_delivery   = false
    }
  }

  managed_rules = {
    access-keys-rotated = {
      identifier  = "ACCESS_KEYS_ROTATED"
      description = "Checks whether the active access keys are rotated within the number of days specified in maxAccessKeyAge. The rule is NON_COMPLIANT if the access keys have not been rotated for more than maxAccessKeyAge number of days."
      input_parameters = {
        maxAccessKeyAge : "90"
      }
      enabled = true
      tags = {
        "compliance/cis-aws-foundations/1.2"                                 = true
        "compliance/cis-aws-foundations/filters/global-resource-region-only" = true
        "compliance/cis-aws-foundations/1.2/controls"                        = 1.4
      }
    }
  }

  kms_key_administrators = [
    data.aws_iam_session_context.current.issuer_arn,
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  ]

  key_policy = jsonencode({
    Id      = "key-policy-1",
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
