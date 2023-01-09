
# aws_ecr_repository creates the aws_ecr_repository resource
resource "aws_ecr_repository" "this" {
  name  = var.name
}

# ecs_ecr_read_perms defines the regular read and login perms for principals defined in var.allowed_read_principals
data "aws_iam_policy_document" "ecs_ecr_read_perms" {
  statement {
    sid = "ECRRead"

    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
    ]

    principals {
      identifiers = var.allowed_read_principals
      type        = "AWS"
    }
  }
}

# ecr_read_and_write_perms defines the ecr_read_and_write_perms for principals defined in var.allowed_write_principals
data "aws_iam_policy_document" "ecr_read_and_write_perms" {

  # The previously created ecs_ecr_read_perms will be merged into this document.
  source_json = data.aws_iam_policy_document.ecs_ecr_read_perms.json

  statement {
    sid = "ECRWrite"

    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
    ]

    principals {
      identifiers = var.allowed_write_principals
      type        = "AWS"
    }
  }
}

# aws_ecr_repository_policy defines the policy for the ECR repository
# when var.allowed_write_principals contains no principals, only the data.aws_iam_policy_document.ecs_ecr_read_perms.json will
# be used to populate the iam policy.
resource "aws_ecr_repository_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy = length(var.allowed_write_principals) > 0 ? data.aws_iam_policy_document.ecr_read_and_write_perms.json : data.aws_iam_policy_document.ecs_ecr_read_perms.json
}
