

data "aws_route53_zone" "zone" {
  name         = length(split(".", var.alias_name)) < 3 ? var.alias_name : join(".", slice(split(".", var.alias_name), 1, length(split(".", var.alias_name))))
  private_zone = false
}

//output "zone_id"{
//  value = data.aws_route53_zone.zone.zone_id
//}

resource "aws_route53_record" "alias" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.alias_name
  type    = "A"
  alias {
    name                   = var.target_name
    zone_id                = var.target_zone_id
    evaluate_target_health = true
  }
}



