locals {
  aws_config_sns_subscribers = {
    opsgenie = {
      protocol               = "https"
      endpoint               = data.aws_ssm_parameter.aws_config.value
      endpoint_auto_confirms = true
      raw_message_delivery   = false
    }
  }
  guard_duty_sns_subscribers = {
    opsgenie = {
      protocol               = "https"
      endpoint               = data.aws_ssm_parameter.guard_duty.value
      endpoint_auto_confirms = true
      raw_message_delivery   = false
    }
  }
  security_hub_sns_subscribers = {
    opsgenie = {
      protocol               = "https"
      endpoint               = data.aws_ssm_parameter.security_hub.value
      endpoint_auto_confirms = true
      raw_message_delivery   = false
    }
  }

  security_hub_standards = [
    "standards/aws-foundational-security-best-practices/v/1.0.0",
    "standards/cis-aws-foundations-benchmark/v/1.4.0"
  ]

}
