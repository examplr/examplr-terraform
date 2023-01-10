

module "dns" {
  source = "./modules/dns"
  count = length(var.domain_names)
  domain_name = var.domain_names[count.index]
}


module "cert"{
  source = "./modules/cert"
  domain_names = module.dns[*].fqdn
  zone_ids_map = zipmap(module.dns[*].fqdn, module.dns[*].zone_id)
  tag_name = var.tag_name
  tag_used_by = var.tag_used_by
}

output "cert_arn" {
  description = "The ARN of the issued certificate"
  value = module.cert.cert_arn
}

output "zone_names"{
  value =  module.dns[*].zone_name
}

output "fqdns"{
  value = module.dns[*].fqdn
}

output "zone_ids"{
  value = module.dns[*].zone_id
}
