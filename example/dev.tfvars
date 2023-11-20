region      = "us-east-1"
environment = "dev"
namespace   = "arc"
project     = "aws-modules"

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

create_inspector_iam_role     = true
inspector_enabled_rules       = ["cis"]
inspector_schedule_expression = "rate(7 days)"
