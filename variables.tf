## shared
################################################################################
variable "namespace" {
  type        = string
  description = "Namespace for the resources."
}

variable "environment" {
  type        = string
  default     = "poc"
  description = "ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "project" {
  type        = string
  description = "The project name"
  default     = ""
}

############################################################################
## security hub
############################################################################

variable "enable_security_hub" {
  description = "Whether to enable Security Hub"
  type        = bool
  default     = true
}

variable "enabled_security_hub_standards" {
  description = <<-DOC
  A list of standards/rulesets to enable

  See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_standards_subscription#argument-reference

  The possible values are:

    - standards/aws-foundational-security-best-practices/v/1.0.0
    - ruleset/cis-aws-foundations-benchmark/v/1.2.0
    - standards/pci-dss/v/3.2.1
  DOC
  type        = list(any)
  default = [
    "standards/aws-foundational-security-best-practices/v/1.0.0",
    "ruleset/cis-aws-foundations-benchmark/v/1.2.0"
  ]
}

variable "create_config_iam_role" {
  description = "Flag to indicate whether an iam role should be created for aws config."
  type        = bool
  default     = false
}

variable "guard_duty_s3_protection_enabled" {
  description = "Flag to indicate whether S3 protection will be turned on in GuardDuty."
  type        = bool
  default     = false
}

variable "aws_config_managed_rules" {
  description = <<-DOC
    A list of AWS Managed Rules that should be enabled on the account.

    See the following for a list of possible rules to enable:
    https://docs.aws.amazon.com/config/latest/developerguide/managed-rules-by-aws-config.html
  DOC
  type = map(object({
    description      = string
    identifier       = string
    input_parameters = any
    tags             = map(string)
    enabled          = bool
  }))
  default = {}
}

variable "security_hub_sns_subscribers" {
  type = map(object({
    protocol               = string
    endpoint               = string
    endpoint_auto_confirms = bool
    raw_message_delivery   = bool
  }))
  description = <<-DOC
  A map of subscription configurations for SNS topics

  For more information, see:
  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription#argument-reference

  protocol:
    The protocol to use. The possible values for this are: sqs, sms, lambda, application. (http or https are partially
    supported, see link) (email is an option but is unsupported in terraform, see link).
  endpoint:
    The endpoint to send data to, the contents will vary with the protocol. (see link for more information)
  endpoint_auto_confirms:
    Boolean indicating whether the end point is capable of auto confirming subscription e.g., PagerDuty. Default is
    false
  raw_message_delivery:
    Boolean indicating whether or not to enable raw message delivery (the original message is directly passed, not wrapped in JSON with the original message in the message property).
    Default is false
  DOC
}

variable "enable_guard_duty" {
  description = "Whether to enable Guard Duty"
  type        = bool
  default     = true
}

variable "guard_duty_sns_subscribers" {
  type = map(object({
    protocol               = string
    endpoint               = string
    endpoint_auto_confirms = bool
    raw_message_delivery   = bool
  }))
  description = <<-DOC
  A map of subscription configurations for SNS topics

  For more information, see:
  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription#argument-reference

  protocol:
    The protocol to use. The possible values for this are: sqs, sms, lambda, application. (http or https are partially
    supported, see link) (email is an option but is unsupported in terraform, see link).
  endpoint:
    The endpoint to send data to, the contents will vary with the protocol. (see link for more information)
  endpoint_auto_confirms:
    Boolean indicating whether the end point is capable of auto confirming subscription e.g., PagerDuty. Default is
    false
  raw_message_delivery:
    Boolean indicating whether or not to enable raw message delivery (the original message is directly passed, not wrapped in JSON with the original message in the message property).
    Default is false
  DOC
}

variable "enable_aws_config" {
  description = "Whether to enable AWS Config"
  type        = bool
  default     = true
}

variable "aws_config_sns_subscribers" {
  type = map(object({
    protocol               = string
    endpoint               = string
    endpoint_auto_confirms = bool
    raw_message_delivery   = bool
  }))
  description = <<-DOC
  A map of subscription configurations for SNS topics

  For more information, see:
  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription#argument-reference

  protocol:
    The protocol to use. The possible values for this are: sqs, sms, lambda, application. (http or https are partially
    supported, see link) (email is an option but is unsupported in terraform, see link).
  endpoint:
    The endpoint to send data to, the contents will vary with the protocol. (see link for more information)
  endpoint_auto_confirms:
    Boolean indicating whether the end point is capable of auto confirming subscription e.g., PagerDuty. Default is
    false
  raw_message_delivery:
    Boolean indicating whether or not to enable raw message delivery (the original message is directly passed, not wrapped in JSON with the original message in the message property).
    Default is false
  DOC
}


variable "enable_inspector" {
  description = "Whether to enable Inspector"
  type        = bool
  default     = true
}

variable "create_inspector_iam_role" {
  description = "Toggle to create aws inspector iam role"
  type        = bool
  default     = true
}

variable "inspector_enabled_rules" {
  description = "list of rules to pass to inspector"
  type        = list(string)
  default     = []
}

variable "inspector_schedule_expression" {
  description = "AWS Schedule Expression to indicate how often the inspector scheduled event shoud run"
  type        = string
  default     = "rate(7 days)"
}

variable "inspector_assessment_event_subscription" {
  description = "Configures sending notifications about a specified assessment template event to a designated SNS topic"
  type = map(object({
    event     = string
    topic_arn = string
  }))
  default = {}
}

variable "tags" {
  type        = map(string)
  description = "Tags for AWS resources"
}
