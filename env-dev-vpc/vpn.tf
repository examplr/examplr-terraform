
module "vpn"{
  source = "../modules/terraform-aws-vpn"

  for_each = toset(keys(var.vpns))

  name = each.key
  host_ip = var.vpns[each.key].host_ip
  destination_cidr_block = var.vpns[each.key].destination_cidr_block

  vpc_id = module.vpc.vpc_id
  //TODO: make other subnets available to VPN here
  route_table_ids = concat(module.vpc.private_route_table_ids, module.vpc.database_route_table_ids)
  //TODO: change this to match length of route_table_ids, TF did not like computing this length dynamically...is there a better way?
  route_table_count = 2

}
