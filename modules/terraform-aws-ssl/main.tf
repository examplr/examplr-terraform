

module "dns-lookup" {
  source = "../terraform-aws-dns-zone-lookup"
  count = length(var.domain_names)
  domain_name = var.domain_names[count.index]
}

resource "aws_acm_certificate" "cert" {
  domain_name = module.dns-lookup[0].domain_name
  subject_alternative_names = slice(module.dns-lookup[*].domain_name, 1, length(module.dns-lookup[*].domain_name))
  validation_method = "DNS"

  tags = {
    Name = "${module.dns-lookup[0].domain_name}-cert"
    UsedBy = var.tag_used_by != "" ? var.tag_name : module.dns-lookup[0].domain_name
  }

  //-- this is here so that users such as an ALB can change the names on their cert.  If this were not
  //-- here, the existing cert would fail destroy on the apply because it is in use by the ALB.
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation_records" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      domain = dvo.domain_name
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = lookup(zipmap(module.dns-lookup[*].domain_name, module.dns-lookup[*].zone_id), each.value.domain, null)
}



resource "aws_acm_certificate_validation" "validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.validation_records : record.fqdn]
}
