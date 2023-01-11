

output "cert_arn" {
  description = "The ARN of the issued certificate"
  value = aws_acm_certificate.cert.arn
}
output "zone_names"{
  value =  module.dns-lookup[*].zone_name
}

output "domain_names"{
  value = module.dns-lookup[*].domain_name
}

output "zone_ids"{
  value = module.dns-lookup[*].zone_id
}
