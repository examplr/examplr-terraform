module "dev_shared_infra" {
  source = "../../../modules/terraform-aws-shared-infra"

  alb_cert_domain_name = "dev.examplr.co."
  alb_cert_sans        = ["*"]
  environment          = "dev"
  route53_domain_name  = "dev.examplr.co"
  vpc_azs              = ["us-east-1a", "us-east-1c", "us-east-1d"]
  vpc_cidr             = "10.24.0.0/16"
  vpc_database_subnets = ["10.24.128.0/20", "10.24.144.0/20", "10.24.160.0/20"]
  vpc_private_subnets  = ["10.24.32.0/19", "10.24.64.0/19", "10.24.96.0/19"]
  vpc_public_subnets   = ["10.24.0.0/24", "10.24.1.0/24", "10.24.2.0/24"]
}
