resource "aws_route53_record" "alb" {
  for_each = toset(local.dns_records)

  zone_id = data.aws_route53_zone.domain.zone_id
  name    = each.value
  type    = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}
