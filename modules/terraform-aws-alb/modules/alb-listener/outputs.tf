
output "service_to_target_group_arn_map"{
  //value = zipmap(module.rules[*].service, module.rules[*].target_group_arn)

  value = { for k, v in module.rules : v.service => v.target_group_arn }
}

output "listener_arn"{
  value = aws_alb_listener.listener.arn
}