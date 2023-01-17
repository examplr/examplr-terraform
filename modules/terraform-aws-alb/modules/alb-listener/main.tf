//TODO support additional ports w/ and w/o ssl

locals {

  cert_count = var.cert_names != null ? length(var.cert_names) : 0
  rule_count = var.rules != null ? length(var.rules) : 0

}

resource "aws_alb_listener" "http" {
  count = local.cert_count == 0 ? 1 : 0

  load_balancer_arn = var.alb_arn
  port              = var.port
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "https" {
  count = local.cert_count == 0 ? 0 : 1

  load_balancer_arn = var.alb_arn

  port            = var.port
  protocol        = "HTTPS"
  certificate_arn = module.cert[0].cert_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "File Not Found"
      status_code  = "404"
    }
  }

#  depends_on = [time_sleep.wait_30_seconds]
}


module "cert" {
  source = "../../../../modules/terraform-aws-ssl"
  count  = local.cert_count == 0 ? 0 : 1

  domain_names = var.cert_names
}

#//-- this 'wait' is here because the cert module returns after validation is complete but the cert
#//-- may take a few minutes before it is ready to use in ACM
#resource "time_sleep" "wait_30_seconds" {
#  depends_on      = [module.cert]
#  create_duration = "30s"
#}


module "rules" {
  source = "../../modules/alb-listener-rule"
  count  = local.rule_count

  vpc_id           = var.vpc_id
  alb_listener_arn = concat(aws_alb_listener.http[*].arn, aws_alb_listener.https[*].arn)[0]

  service      = var.rules[count.index].service
  port         = var.rules[count.index].port
  paths        = var.rules[count.index].paths
  hosts        = var.rules[count.index].hosts
  priority     = var.rules[count.index].priority
  health_check = var.rules[count.index].health_check

}



