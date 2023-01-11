
output "zone_id"{
  description = "The zone_id of the input domain_name"
  value = data.aws_route53_zone.zone.zone_id
}

output "zone_name"{
  description = "The name of the zone"
  value = local.zone_name
}

output "domain_name"{
  description = "Same as the passed in domain_name with any leading '!' characters removed"
  value = local.fqdn
}