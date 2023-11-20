data "aws_ssm_parameter" "guard_duty" {
  name = "/${var.namespace}/${var.environment}/guard-duty/opsgenie/api-key"
}

data "aws_ssm_parameter" "security_hub" {
  name = "/${var.namespace}/${var.environment}/security-hub/opsgenie/api-key"
}

data "aws_ssm_parameter" "aws_config" {
  name = "/${var.namespace}/${var.environment}/aws-config/opsgenie/api-key"
}
