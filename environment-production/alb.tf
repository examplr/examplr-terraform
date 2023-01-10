
module "alb" {
  source = "../modules/terraform-aws-alb"

  count = length(var.albs)

  name =  "${local.environment}-${var.app_name}-${var.albs[count.index].name}-alb"
  aliases_domain_names = var.albs[count.index].alias_domain_names
  cert_domain_names  =  var.albs[count.index].cert_domain_names

  subnets = module.vpc.public_subnets

  vpc_id = module.vpc.vpc_id

  depends_on = [module.vpc]
}