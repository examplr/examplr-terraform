
locals{
  alb_keys = toset(keys(var.listeners))
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


resource "aws_security_group" "ingress" {
  for_each = local.alb_keys

  name        = "${var.name}-ingress-${each.key}"
  description = "Allow inbound port ${each.key} traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = each.key
    to_port     = each.key
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-ingress_${each.key}"
  }
}


resource "aws_alb" "alb" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"

  subnets = var.subnets
  security_groups = concat([aws_security_group.egress_all.id], [for v in aws_security_group.ingress : v.id])
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

  for_each = local.alb_keys

  vpc_id = var.vpc_id
  alb_arn = aws_alb.alb.arn

  port = tonumber(each.key)
  dns_aliases = var.dns_names
  cert_names = var.listeners[each.key].cert
  rules = var.listeners[each.key].rules

}






