output "zone_id"{
  description = "The zone_id of the input domain_name"
  value = data.aws_route53_zone.zone.zone_id
}