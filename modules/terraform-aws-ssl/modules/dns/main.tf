data "aws_route53_zone" "zone" {
  name         = length(split(".", var.domain_name)) < 3 ? var.domain_name : join(".", slice(split(".", var.domain_name), 1, length(split(".", var.domain_name))))
  private_zone = false
}