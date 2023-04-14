output "alb" {
  value = nonsensitive(jsondecode(base64decode(data.aws_ssm_parameter.alb.value)))
}

output "ecs" {
  value = nonsensitive(jsondecode(base64decode(data.aws_ssm_parameter.ecs.value)))
}

output "vpc" {
  value = nonsensitive(jsondecode(base64decode(data.aws_ssm_parameter.vpc.value)))
}
