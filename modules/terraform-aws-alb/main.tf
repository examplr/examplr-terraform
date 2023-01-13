

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


resource "aws_security_group" "ingress" {
  count = length(var.listeners)

  name        = "${var.name}-ingress-${var.listeners[count.index].port}"
  description = "Allow inbound port ${var.listeners[count.index].port} traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.listeners[count.index].port
    to_port     = var.listeners[count.index].port
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-ingress_${var.listeners[count.index].port}"
  }
}


resource "aws_alb" "alb" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"

  subnets = var.subnets
  security_groups = concat([aws_security_group.egress_all.id], aws_security_group.ingress[*].id)
}


module "dns-lookup" {
  source = "../../modules/terraform-aws-dns-zone-lookup"
  count = length(var.dns_names)
  domain_name = var.dns_names[count.index]
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
}


module "alb_listener"{
  source = "./modules/alb-listener"
  count = length(var.listeners)

  vpc_id = var.vpc_id
  alb_arn = aws_alb.alb.arn

  port = var.listeners[count.index].port
  dns_aliases = var.dns_names
  cert_names = var.listeners[count.index].cert
  rules = var.listeners[count.index].rules

}






