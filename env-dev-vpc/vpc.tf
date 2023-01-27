
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "${var.app_env}-${var.app_name}-vpc"
  cidr = var.vpc_cidr

  azs              = var.vpc_azs
  public_subnets   = var.vpc_public_subnets
  private_subnets  = var.vpc_private_subnets
  database_subnets = var.vpc_database_subnets

  create_database_subnet_group = false
  //database_subnet_group_name = "${var.app_env}-${var.app_name}-db-${var.app_region}-sg"

  manage_default_network_acl = true
  default_network_acl_tags   = { Name = "${var.app_env}-${var.app_name}-default" }

  manage_default_route_table = true
  default_route_table_tags   = { Name = "${var.app_env}-${var.app_name}-default" }

  manage_default_security_group = true
  default_security_group_tags   = { Name = "${var.app_env}-${var.app_name}-default" }

  enable_nat_gateway = true
  single_nat_gateway = true

}
