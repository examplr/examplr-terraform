
data "aws_lb" "alb" {
  name = var.alb_name
}

data "aws_lb_listener" "alb_listener" {
  load_balancer_arn = data.aws_lb.alb.arn
  port              = var.port
}

locals {
  hosts = var.hosts != null ? var.hosts : []
  paths = (
            var.paths != null ? var.paths : (
              length(local.hosts) != 0 ? [] : ["/*"]
            )
          )
}

resource "aws_lb_listener_rule" "paths_and_hosts" {
  count = length(local.paths) != 0  && length(local.hosts) != 0 ? 1 : 0

  listener_arn = data.aws_lb_listener.alb_listener.arn
  priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = var.target_group_arn
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

  listener_arn = data.aws_lb_listener.alb_listener.arn
  priority     = var.priority
  action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }

  condition {
    path_pattern {
      values = local.paths
    }
  }
}

resource "aws_lb_listener_rule" "hosts_only" {
  count = length(local.paths) == 0  && length(local.hosts) != 0 ? 1 : 0

  listener_arn = data.aws_lb_listener.alb_listener.arn
  priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }

  condition {
    host_header {
      values = local.hosts
    }
  }
}