locals {

  environment = var.environment
  namespace   = var.namespace
  project = var.project
  name_prefix = "${var.namespace}-${var.environment}"

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

}
