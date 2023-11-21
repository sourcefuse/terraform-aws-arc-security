locals {

  name_prefix               = "${var.namespace}-${var.environment}"
  guard_duty_sns_topic_name = "${local.name_prefix}-guard-duty"

  aws_config_managed_rules = {
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

  default_security_hub_standards = [
    "standards/aws-foundational-security-best-practices/v/1.0.0",
    "standards/cis-aws-foundations-benchmark/v/1.4.0"
  ]
  security_hub_standards = length(var.enabled_security_hub_standards) == 0 ? local.default_security_hub_standards : var.enabled_security_hub_standards


}
