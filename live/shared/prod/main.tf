module "shared_infra" {
  source = "../../../modules/terraform-aws-shared-infra"

  alb_cert_domain_name = "api.examplr.co."
  alb_cert_sans        = ["*"]
  environment          = "prod"
  route53_domain_name  = "api.examplr.co"
  vpc_azs              = ["us-east-1a", "us-east-1c", "us-east-1d"]
  vpc_cidr             = "10.10.0.0/16"
  vpc_database_subnets = ["10.10.128.0/20", "10.10.144.0/20", "10.10.160.0/20"]
  vpc_private_subnets  = ["10.10.32.0/19", "10.10.64.0/19", "10.10.96.0/19"]
  vpc_public_subnets   = ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24"]
}
