
module "ecr-cross-account" {
  source                      = "../modules/terraform-aws-ecr-cross-account"

  for_each = toset(keys(var.ecr_repositories))

  repository_name             = each.key
  allowed_read_principals     = var.ecr_repositories[each.key].allowed_read_principals
  allowed_write_principals    = var.ecr_repositories[each.key].allowed_write_principals
}