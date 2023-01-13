
module "alb" {
  source = "../modules/terraform-aws-alb"

  count = length(var.albs)

  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  name =  "${local.environment}-${var.app_name}-${var.albs[count.index].name}-alb"
  dns_names = var.albs[count.index].dns_aliases

  listeners = var.albs[count.index].listeners

}
