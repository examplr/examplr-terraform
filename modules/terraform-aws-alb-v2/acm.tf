resource "aws_acm_certificate" "alb" {
  domain_name               = local.cert_domain_name
  subject_alternative_names = length(local.cert_sans) > 0 ? local.cert_sans : null
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true

    precondition {
      condition     = endswith(local.cert_domain_name, var.route53_domain_name)
      error_message = "The ACM cert domain name should be in the Route53 zone specified by var.route53_domain_name."
    }

    precondition {
      condition     = length(local.cert_sans) > 0 ? alltrue([for san in local.cert_sans : endswith(san, var.route53_domain_name)]) : true
      error_message = "All ACM cert subject alternative names should be in the Route53 zone specified by var.route53_domain_name."
    }
  }
}

resource "aws_route53_record" "alb_validation" {
  for_each = {
    for dvo in aws_acm_certificate.alb.domain_validation_options : dvo.domain_name => {
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
  zone_id         = data.aws_route53_zone.domain.zone_id
}

resource "aws_acm_certificate_validation" "alb_validation" {
  certificate_arn         = aws_acm_certificate.alb.arn
  validation_record_fqdns = [for record in aws_route53_record.alb_validation : record.fqdn]
}
