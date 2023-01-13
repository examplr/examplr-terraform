
output "alias" {
  value = var.alias
}


output "target_group_arn" {
  value = aws_lb_target_group.target_group.arn
}

