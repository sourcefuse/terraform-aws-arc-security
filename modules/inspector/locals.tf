locals {

  resource_types_to_in_org = {
    ec2         = contains(var.resource_types, "EC2") ? true : false
    ecr         = contains(var.resource_types, "ECR") ? true : false
    lambda      = contains(var.resource_types, "LAMBDA") ? true : false
    lambda_code = contains(var.resource_types, "LAMBDA_CODE") ? true : false
  }

}
