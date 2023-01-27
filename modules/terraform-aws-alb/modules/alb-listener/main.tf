
locals {
  rules = var.rules != null ? var.rules : {}
  cert_count = var.cert_names != null ? length(var.cert_names) : 0
  https = local.cert_count > 0 ? toset(["https"]) : toset([])
  http  = local.cert_count <= 0 ? toset(["http"]) : toset([])
}

resource "aws_alb_listener" "listener" {

  load_balancer_arn = var.alb_arn
  port              = var.port
  protocol          = local.cert_count > 0 ? "HTTPS" : "HTTP"
  certificate_arn = local.cert_count > 0 ? module.cert[0].cert_arn : null

  dynamic "default_action" {
    for_each = local.http
    content {
      type = "redirect"
      redirect {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  }

  dynamic "default_action" {
    for_each = local.https
    content {
      type = "fixed-response"
      fixed_response {
        content_type = "text/plain"
        message_body = "File Not Found"
        status_code  = "404"
      }
    }
  }
}

module "cert" {
  source = "../../../../modules/terraform-aws-ssl"
  count  = local.cert_count == 0 ? 0 : 1

  domain_names = var.cert_names
}

module "rules" {
  source   = "../../modules/alb-listener-rule"
  for_each = toset(keys(local.rules))

  vpc_id           = var.vpc_id
  alb_listener_arn = aws_alb_listener.listener.arn

  service      = each.key
  port         = var.rules[each.key].port
  paths        = var.rules[each.key].paths
  hosts        = var.rules[each.key].hosts
  priority     = var.rules[each.key].priority
  health_check = var.rules[each.key].health_check

}



