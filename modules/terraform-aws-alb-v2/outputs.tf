output "arn" {
  value = aws_lb.this.arn
}

output "id" {
  value = aws_lb.this.id
}

output "listener" {
  value = {
    arn               = aws_lb_listener.ingress_443.arn
    id                = aws_lb_listener.ingress_443.id
    load_balancer_arn = aws_lb_listener.ingress_443.load_balancer_arn
  }
}

output "name" {
  value = aws_lb.this.name
}

output "security_group" {
  value = {
    arn      = aws_security_group.alb.arn
    id       = aws_security_group.alb.id
    owner_id = aws_security_group.alb.owner_id
    vpd_id   = aws_security_group.alb.vpc_id
  }
}

output "zone_id" {
  value = aws_lb.this.zone_id
}
