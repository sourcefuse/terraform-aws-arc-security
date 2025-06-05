locals {
  aws_config_sns_subscribers = {
    opsgenie = {
      protocol               = "email"
      endpoint               = "devops-team@example.com"
      endpoint_auto_confirms = true
      raw_message_delivery   = false
    }
  }
  guard_duty_sns_subscribers = {
    opsgenie = {
      protocol               = "email"
      endpoint               = "devops-team@example.com"
      endpoint_auto_confirms = true
      raw_message_delivery   = false
    }
  }
  security_hub_sns_subscribers = {
    opsgenie = {
      protocol               = "email"
      endpoint               = "devops-team@example.com"
      endpoint_auto_confirms = true
      raw_message_delivery   = false
    }
  }

  inspector_sns_subscribers = {
    opsgenie = {
      protocol               = "email"
      endpoint               = "devops-team@example.com"
      endpoint_auto_confirms = true
      raw_message_delivery   = false
    }
  }


  security_hub_standards = [
    "standards/aws-foundational-security-best-practices/v/1.0.0",
    "standards/cis-aws-foundations-benchmark/v/1.4.0"
  ]

}
