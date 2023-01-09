
module "dns" {
  source = "./modules/dns"

  count = length(var.aliases_domain_names)

  alias_name = var.aliases_domain_names[count.index]
  target_name = aws_alb.alb.dns_name
  target_zone_id = aws_alb.alb.zone_id

  depends_on = [aws_alb.alb]
}

module "cert" {
  source = "../../modules/terraform-aws-ssl"
  domain_names = var.cert_domain_names

  tag_used_by = var.name
  depends_on = [module.dns]
}



resource "aws_alb" "alb" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"

  subnets = var.subnets
  security_groups = [aws_security_group.egress_all.id, aws_security_group.ingress_40.id, aws_security_group.ingress_443.id, aws_security_group.ingress_8080.id]

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


resource "aws_security_group" "ingress_40" {
  name        = "${var.name}-http"
  description = "Allow inbound port 40 traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 40
    to_port     = 40
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-ingress_40"
  }
}

resource "aws_security_group" "ingress_443" {
  name        = "${var.name}-https"
  description = "Allow inbound port 80 traffic"
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


resource "aws_security_group" "ingress_8080" {
  name        = "${var.name}-ingress-api"
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


