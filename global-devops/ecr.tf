
module "ecr-cross-account" {
  source                      = "../modules/terraform-aws-ecr-cross-account"

  count = length(var.ecr_repositories)

  repository_name             = var.ecr_repositories[count.index].name
  allowed_read_principals     = var.ecr_repositories[count.index].allowed_read_principals
  allowed_write_principals    = var.ecr_repositories[count.index].allowed_write_principals
}