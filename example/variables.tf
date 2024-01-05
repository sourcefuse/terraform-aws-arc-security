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
