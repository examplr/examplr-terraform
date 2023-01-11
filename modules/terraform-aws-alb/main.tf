
module "dns-lookup" {
  source = "../../modules/terraform-aws-dns-zone-lookup"
  count = length(var.aliases_domain_names)

  domain_name = var.aliases_domain_names[count.index]
}


resource "aws_alb" "alb" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"

  subnets = var.subnets
  security_groups = [aws_security_group.egress_all.id, aws_security_group.ingress_80.id, aws_security_group.ingress_443.id, aws_security_group.ingress_8080.id]

}

resource "aws_route53_record" "alias" {
  count = length(module.dns-lookup[*].domain_name)
  zone_id = module.dns-lookup[count.index].zone_id
  name    = module.dns-lookup[count.index].domain_name
  type    = "A"
  alias {
    name                   = aws_alb.alb.dns_name
    zone_id                = aws_alb.alb.zone_id
    evaluate_target_health = true
  }
  depends_on = [aws_alb.alb, module.dns-lookup]
}



resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
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


module "cert" {
  source = "../../modules/terraform-aws-ssl"
  domain_names = var.cert_domain_names

  tag_used_by = var.name
  depends_on = [module.dns-lookup]
}


resource "aws_alb_listener" "https_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = module.cert.cert_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "File Not Found"
      status_code  = "404"
    }
  }

  depends_on = [module.cert]
}


resource "aws_security_group" "egress_all" {
  name        = "${var.name}-egress-all"
  description = "Allow all outbound traffic"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-egress-all"
  }
}


resource "aws_security_group" "ingress_80" {
  name        = "${var.name}-ingress-80"
  description = "Allow inbound port 80 traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-ingress_80"
  }
}

resource "aws_security_group" "ingress_443" {
  name        = "${var.name}-ingress-443"
  description = "Allow inbound port 443 traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-ingress_443"
  }
}


//TODO testing showed this is necessary for health checks...is that correct?
resource "aws_security_group" "ingress_8080" {
  name        = "${var.name}-ingress-8080"
  description = "Allow inbound port 8080 traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-ingress_8080"
  }
}


