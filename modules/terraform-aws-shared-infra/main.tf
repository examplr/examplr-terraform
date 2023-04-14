module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.1"

  name = "${var.environment}-ecs"
  cidr = var.vpc_cidr

  azs              = var.vpc_azs
  private_subnets  = var.vpc_private_subnets
  public_subnets   = var.vpc_public_subnets
  database_subnets = var.vpc_database_subnets

  create_database_subnet_group = var.vpc_database_subnets != null

  enable_nat_gateway     = var.vpc_enable_nat_gateway
  single_nat_gateway     = var.vpc_single_nat_gateway
  one_nat_gateway_per_az = var.vpc_enable_nat_gateway ? !var.vpc_single_nat_gateway : false
}

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "4.1.3"

  cluster_name = "${var.environment}-ecs-fargate"
}

module "alb" {
  source = "../terraform-aws-alb-v2"

  count = var.create_alb ? 1 : 0

  cert_domain_name     = var.alb_cert_domain_name
  cert_sans            = var.alb_cert_sans
  create_dns_records   = var.alb_create_dns_records
  name                 = "${module.ecs.cluster_name}-ingress"
  route53_domain_name  = var.route53_domain_name
  route53_private_zone = var.route53_private_zone
  subnet_ids           = module.vpc.public_subnets
  vpc_id               = module.vpc.vpc_id
}
