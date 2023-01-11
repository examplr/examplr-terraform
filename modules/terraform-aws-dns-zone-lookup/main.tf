
locals{

  zone_name = (
                startswith(var.domain_name, "!") ?
                substr(var.domain_name, 1, length(var.domain_name)-1) :
                (
                  length(split(".", var.domain_name)) < 3 ?
                  var.domain_name :
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
