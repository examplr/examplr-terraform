

module "dns-zone-lookup" {
  source = "./modules/dns"
  count = length(var.domain_names)
  domain_name = var.domain_names[count.index]
}


module "cert"{
  source = "./modules/cert"
  domain_names = var.domain_names
  zone_ids_map = zipmap(var.domain_names,module.dns-zone-lookup[*].zone_id)
  tag_name = var.tag_name
  tag_used_by = var.tag_used_by
}