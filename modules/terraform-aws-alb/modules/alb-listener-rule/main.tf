

locals {
  hosts = var.hosts != null ? var.hosts : []
  paths = (
            var.paths != null ? var.paths : (
              length(local.hosts) != 0 ? [] : ["/*"]
            )
          )

  container_port = var.port != null ? var.port : 8080
  health_check = var.health_check != null ? var.health_check : "/health"
}

resource "aws_lb_target_group" "target_group" {
  name        = "${var.alias}-tg"
  port        = local.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    enabled = true
    path    = local.health_check
  }
}


resource "aws_lb_listener_rule" "paths_and_hosts" {
  count = length(local.paths) != 0  && length(local.hosts) != 0 ? 1 : 0

  listener_arn = var.alb_listener_arn
  priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  condition {
    path_pattern {
      values = local.paths
    }
  }

  condition {
    host_header {
      values = local.hosts
    }
  }
}


resource "aws_lb_listener_rule" "paths_only" {
  count = length(local.paths) != 0  && length(local.hosts) == 0 ? 1 : 0

  listener_arn = var.alb_listener_arn
  priority     = var.priority
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  condition {
    path_pattern {
      values = local.paths
    }
  }
}

resource "aws_lb_listener_rule" "hosts_only" {
  count = length(local.paths) == 0  && length(local.hosts) != 0 ? 1 : 0

  listener_arn = var.alb_listener_arn
  priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  condition {
    host_header {
      values = local.hosts
    }
  }
}