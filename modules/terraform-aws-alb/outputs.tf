

output "arn" {
  value = aws_alb.alb.arn
}

output "listener_arns"{
  value = module.alb_listener[*].listener_arn
}

output "alias_to_target_group_arn_map"{
  value = merge(module.alb_listener[*].alias_to_target_group_arn_map...)
}
