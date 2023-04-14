resource "aws_security_group" "alb" {
  description = "Security group ALB: ${var.name}"
  name        = "ALB.${var.name}"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "egress" {
  description       = local.security_group_rule_description
  security_group_id = aws_security_group.alb.id

  type             = "egress"
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

resource "aws_security_group_rule" "ingress_80" {
  description       = local.security_group_rule_description
  security_group_id = aws_security_group.alb.id

  type             = "ingress"
  from_port        = 80
  to_port          = 80
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

resource "aws_security_group_rule" "ingress_443" {
  description       = local.security_group_rule_description
  security_group_id = aws_security_group.alb.id

  type             = "ingress"
  from_port        = 443
  to_port          = 443
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}
