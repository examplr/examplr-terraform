data "aws_caller_identity" "current" {}

module "shared_infra_data" {
  source = "../terraform-aws-shared-infra/modules/data"

  environment = var.environment
}

locals {
  alb = module.shared_infra_data.alb
  ecs = module.shared_infra_data.ecs
  vpc = module.shared_infra_data.vpc

  profile = var.profile != null ? var.profile : var.environment
  project = "helloworld"
  service = "api-v1"

  ecr_repository_name = format("%s-%s", local.project, local.service)
}
