region      = "us-east-1"
environment = "dev"
namespace   = "arc"
project     = "aws-modules"

create_sns_topic = true
create_iam_role  = true
force_destroy    = true

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
aws_config_sns_subscribers = {
  opsgenie = {
    protocol               = "https"
    endpoint               = ""
    endpoint_auto_confirms = true
    raw_message_delivery   = false
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
enabled_standards = ["standards/aws-foundational-security-best-practices/v/1.0.0", "ruleset/cis-aws-foundations-benchmark/v/1.2.0"]


create_inspector              = false
create_inspector_iam_role     = false
inspector_enabled_rules       = ["cis"]
inspector_schedule_expression = "rate(7 days)"



