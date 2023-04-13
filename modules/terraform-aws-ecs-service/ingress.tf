resource "aws_lb_target_group" "ecs_ingress" {
  for_each = local.ecs_task_container_ingress

  name        = each.key
  port        = each.value.container.port
  protocol    = each.value.container.protocol
  target_type = "ip"
  vpc_id      = var.vpc_id

  dynamic "health_check" {
    for_each = can(each.value.health_check) ? [each.value.health_check] : []

    content {
      enabled = health_check.value.enabled
      path    = health_check.value.path
      port    = health_check.value.port
    }
  }
}

resource "aws_lb_listener_rule" "ecs_ingress" {
  for_each = local.ecs_task_container_ingress

  listener_arn = each.value.alb_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_ingress[each.key].arn
  }

  dynamic "condition" {
    for_each = length(each.value.paths) > 0 ? { paths = each.value.paths } : {}

    content {
      path_pattern {
        values = condition.value
      }
    }
  }

  dynamic "condition" {
    for_each = length(each.value.hosts) > 0 ? { hosts = each.value.hosts } : {}

    content {
      host_header {
        values = condition.value
      }
    }
  }

  lifecycle {
    precondition {
      condition     = length(each.value.paths) > 0 || length(each.value.hosts) > 0
      error_message = "One of hosts or paths must be set for each ingress"
    }
  }
}

resource "aws_security_group" "ecs_sg" {
  count = var.ecs_svc_create_security_group ? 1 : 0

  description = "Security group for ECS task ${local.name}"
  name        = "ECS.task.${local.name}"
  tags        = local.tags
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "ecs_svc_egress" {
  count = var.ecs_svc_create_security_group ? 1 : 0

  description       = "All outbound"
  security_group_id = aws_security_group.ecs_sg[0].id

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ecs_svc_ingress_from_alb" {
  for_each = var.ecs_svc_create_security_group ? toset(local.ecs_svc_ingress_ports) : []

  description       = "This rule is managed by Terraform, do not change manually."
  security_group_id = aws_security_group.ecs_sg[0].id

  type                     = "ingress"
  from_port                = split(":", each.value)[1]
  to_port                  = split(":", each.value)[1]
  protocol                 = "tcp"
  source_security_group_id = split(":", each.value)[0]
}

data "aws_lb_listener" "selected" {
  for_each = var.route53_zone_id != null ? toset(distinct(values(local.ecs_task_route53_records))) : []

  arn = each.key
}

data "aws_lb" "selected" {
  for_each = var.route53_zone_id != null ? toset(distinct(values(local.ecs_task_route53_records))) : []

  arn = data.aws_lb_listener.selected[each.key].load_balancer_arn
}

resource "aws_route53_record" "host" {
  for_each = var.route53_zone_id != null ? local.ecs_task_route53_records : {}

  zone_id = var.route53_zone_id
  name    = each.key
  type    = "A"

  alias {
    name                   = data.aws_lb.selected[each.value].dns_name
    zone_id                = data.aws_lb.selected[each.value].zone_id
    evaluate_target_health = true
  }
}
