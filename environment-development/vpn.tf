
module "vpn"{
  source = "../modules/terraform-aws-vpn"
  count = var.vpn_host != null && var.vpn_destination_cidr_block != null ? 1 : 0

  vpn_host = var.vpn_host
  vpc_id = module.vpc.vpc_id
  destination_cidr_block = var.vpn_destination_cidr_block

  //TODO: make other subnets available to VPN here
  route_table_ids = concat(module.vpc.private_route_table_ids, module.vpc.database_route_table_ids)
  //TODO: change this to match length of route_table_ids, TF did not like computing this length dynamically...is there a better way?
  route_table_count = 2

}
