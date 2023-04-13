data "aws_ssm_parameter" "alb" {
  name = "/infrastructure/${var.environment}/shared/alb"
}

data "aws_ssm_parameter" "ecs" {
  name = "/infrastructure/${var.environment}/shared/ecs"
}

data "aws_ssm_parameter" "vpc" {
  name = "/infrastructure/${var.environment}/shared/vpc"
}
