locals {
  output_alb = var.create_alb ? {
    arn          = module.alb[0].arn
    sg_id        = module.alb[0].security_group.id
    listener_arn = module.alb[0].listener.arn
  } : {}

  output_ecs = {
    arn  = module.ecs.cluster_arn
    id   = module.ecs.cluster_id
    name = module.ecs.cluster_name
  }

  output_vpc = {
    id              = module.vpc.vpc_id
    private_subnets = module.vpc.private_subnets
    public_subnets  = module.vpc.public_subnets
  }
}
