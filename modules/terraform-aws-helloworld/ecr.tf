module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "1.6.0"

  repository_name = local.ecr_repository_name

  repository_read_write_access_arns = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last ${var.ecr_images_to_keep} images",

        selection = {
          tagStatus   = "any",
          countType   = "imageCountMoreThan",
          countNumber = var.ecr_images_to_keep
        },

        action = {
          type = "expire"
        }
      }
    ]
  })
}
