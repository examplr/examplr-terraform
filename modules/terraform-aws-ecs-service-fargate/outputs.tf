
output "service_id"{
  value = aws_ecs_service.service.id
}

output "service_full_name"{
  value = aws_ecs_service.service.name
}

output "service_short_name"{
  value = var.name
}

output "security_groups"{
  value = [aws_security_group.ingress, aws_security_group.egress]
}

output "execution_role_arn"{
  value = aws_iam_role.execution_role.arn
}

output "task_role_arn"{
  value = aws_iam_role.task_role.arn
}
