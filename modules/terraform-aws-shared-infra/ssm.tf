resource "aws_ssm_parameter" "output_alb" {
  count = var.create_outputs_as_ssm_parameters ? 1 : 0

  name           = "/infrastructure/${var.environment}/shared/alb"
  type           = "String"
  insecure_value = base64encode(jsonencode(local.output_alb))
}

resource "aws_ssm_parameter" "output_ecs" {
  count = var.create_outputs_as_ssm_parameters ? 1 : 0

  name           = "/infrastructure/${var.environment}/shared/ecs"
  type           = "String"
  insecure_value = base64encode(jsonencode(local.output_ecs))
}

resource "aws_ssm_parameter" "output_vpc" {
  count = var.create_outputs_as_ssm_parameters ? 1 : 0

  name           = "/infrastructure/${var.environment}/shared/vpc"
  type           = "String"
  insecure_value = base64encode(jsonencode(local.output_vpc))
}
