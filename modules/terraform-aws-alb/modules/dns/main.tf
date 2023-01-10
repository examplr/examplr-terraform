
locals{
  zone_name = (
                length(split(".", var.alias_name)) < 3 ?
                var.alias_name :
                (
                  startswith(var.alias_name, "!") ?
                  substr(var.alias_name, 1, length(var.alias_name)-1) :
                  join(".", slice(split(".", var.alias_name), 1, length(split(".", var.alias_name))))
                )
              )
}



data "aws_route53_zone" "zone" {
  name         = local.zone_name
  private_zone = false
}

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



