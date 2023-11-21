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

variable "enabled_standards" {
  description = "A list of standards to enable in the account"
  type        = list(string)
  default     = []
}

variable "create_sns_topic" {
  description = "Flag to indicate whether an SNS topic should be created for notifications."
  type        = bool
  default     = false
}

variable "create_iam_role" {
  description = "Flag to indicate whether an iam role should be created for aws config."
  type        = bool
  default     = false
}

variable "enable_cloudwatch" {
  description = "Flag to indicate whether to enable cloudwatch for logging."
  type        = bool
  default     = false
}

variable "s3_protection_enabled" {
  description = "Flag to indicate whether S3 protection will be turned on in GuardDuty."
  type        = bool
  default     = false
}

variable "force_destroy" {
  type        = bool
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable"
  default     = false
}

variable "managed_rules" {
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
  default = {
    opsgenie = {
      protocol               = "https"
      endpoint               = ""
      endpoint_auto_confirms = true
      raw_message_delivery   = false
    }
  }
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
  default = {
    opsgenie = {
      protocol               = "https"
      endpoint               = ""
      endpoint_auto_confirms = true
      raw_message_delivery   = false
    }
  }
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
  default = {
    opsgenie = {
      protocol               = "https"
      endpoint               = ""
      endpoint_auto_confirms = true
      raw_message_delivery   = false
    }
  }
}

variable "create_inspector" {
  description = "Toggle to create aws inspector"
  type        = bool
  default     = false
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
