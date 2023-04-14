data "aws_route53_zone" "domain" {
  name         = var.route53_domain_name
  private_zone = var.route53_private_zone
}

locals {
  # Using the same logic as creating a Route53 record, if we end the DNS record
  # with a '.' keep it as is, otherwise append the domain name to the end of it.
  cert_domain_name = endswith(var.cert_domain_name, ".") ? trimsuffix(var.cert_domain_name, ".") : format("%s.%s", var.cert_domain_name, var.route53_domain_name)
  cert_sans        = distinct(compact([for san in var.cert_sans : endswith(san, ".") ? trimsuffix(san, ".") : format("%s.%s", san, var.route53_domain_name)]))
  dns_records      = var.create_dns_records ? distinct(concat([local.cert_domain_name], local.cert_sans)) : []

  security_group_rule_description = "This rule is managed by Terraform, do not change manually."
}
