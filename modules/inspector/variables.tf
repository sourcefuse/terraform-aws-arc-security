variable "enable_inspector_at_orgnanization" {
  type        = bool
  description = "Whether to enable Inspecter at Org level, if false account_list should be provided "
  default     = false
}

variable "add_inspector_member_accounts" {
  type        = bool
  description = "Whether to associate as a member account with your Amazon Inspector delegated administrator account."
  default     = false
}

variable "account_list" {
  type        = list(string)
  description = "List of Account for which inspector has to be enabled"
}

variable "subscribers" {
  type = map(object({
    protocol = string
    # The protocol to use. The possible values for this are: sqs, sms, lambda, application. (http or https are partially supported, see below) (email is an option but is unsupported, see below).
    endpoint = string
    # The endpoint to send data to, the contents will vary with the protocol. (see below for more information)
    endpoint_auto_confirms = bool
    # Boolean indicating whether the end point is capable of auto confirming subscription e.g., PagerDuty (default is false)
    raw_message_delivery = bool
    # Boolean indicating whether or not to enable raw message delivery (the original message is directly passed, not wrapped in JSON with the original message in the message property) (default is false)
  }))
  description = "Required configuration for subscibres to SNS topic."
  default     = {}
}

variable "resource_types" {
  type        = list(string)
  description = "Type of resources to scan. Valid values are EC2, ECR, LAMBDA and LAMBDA_CODE. At least one item is required."
  default     = ["EC2", "ECR"]
}

variable "schedule_expression" {
  type        = string
  description = <<-DOC
    An AWS Schedule Expression to indicate how often the scheduled event shoud run.

    For more information see:
    https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html
  DOC
  default     = "rate(7 days)"
}
