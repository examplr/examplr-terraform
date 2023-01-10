
locals{
  zone_name = (
                  length(split(".", var.domain_name)) < 3 ?
                  var.domain_name :
                  (
                      startswith(var.domain_name, "!") ?
                      substr(var.domain_name, 1, length(var.domain_name)-1) :
                      join(".", slice(split(".", var.domain_name), 1, length(split(".", var.domain_name))))
                  )
              )
  fqdn =  (
            startswith(var.domain_name, "!") ?
            substr(var.domain_name, 1, length(var.domain_name)-1) :
            var.domain_name
          )
}


data "aws_route53_zone" "zone" {
  name = local.zone_name
  private_zone = false
}

output "zone_id"{
  description = "The zone_id of the input domain_name"
  value = data.aws_route53_zone.zone.zone_id
}

output "zone_name"{
  value = local.zone_name
}

output "fqdn"{
  value = local.fqdn
}