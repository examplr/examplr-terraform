
locals{
  cert_name = var.tag_name != "" ? var.tag_name : "${var.domain_names[0]}-${var.tag_used_by}-cert"
}

resource "aws_acm_certificate" "cert" {
  domain_name = var.domain_names[0]
  subject_alternative_names = slice(var.domain_names, 1, length(var.domain_names))
  validation_method = "DNS"

  tags = {
    Name = local.cert_name
    UsedBy = var.tag_used_by
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
  zone_id         = lookup(var.zone_ids_map, each.value.domain, null)
}



resource "aws_acm_certificate_validation" "validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.validation_records : record.fqdn]
}
