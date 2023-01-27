
locals{
  alb_keys = toset(keys(var.albs))
}


module "alb" {
  source = "../modules/terraform-aws-alb"

  for_each = local.alb_keys

  name =  "${var.app_env}-${var.app_name}-${each.key}-alb"
  dns_names = var.albs[each.key].dns_aliases
  listeners = var.albs[each.key].listeners
  vpc_id = var.vpc_id
  subnets = var.vpc_public_subnet_ids
}
