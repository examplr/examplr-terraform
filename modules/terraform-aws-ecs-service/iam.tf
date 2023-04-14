# Execution Role
resource "aws_iam_role" "ecs_executor" {
  name               = "ECS.executor.${data.aws_region.current.name}.${local.name}"
  assume_role_policy = data.aws_iam_policy_document.ecs_executor_arp.json
}

data "aws_iam_policy_document" "ecs_executor_arp" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_executor_managed_policy" {
  role       = aws_iam_role.ecs_executor.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "ecs_executor_secret_access" {
  count = length(local.ecs_task_secrets) > 0 ? 1 : 0

  name   = "ecs-executor-permissions"
  policy = data.aws_iam_policy_document.ecs_executor_secret_access[0].json
  role   = aws_iam_role.ecs_executor.name
}

# Secrets for ECS tasks can be either SSM Parameters or Secrets
# Instead of doing some sorcery to figure out which they are, grant access to both resource types
data "aws_iam_policy_document" "ecs_executor_secret_access" {
  count = length(local.ecs_task_secrets) > 0 ? 1 : 0

  statement {
    sid    = "AllowReadAccessToSecrets"
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "ssm:GetParameters",
    ]

    resources = local.ecs_task_secrets
  }
}

# Task Role
resource "aws_iam_role" "ecs_task" {
  name               = "ECS.task.${data.aws_region.current.name}.${local.name}"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_arp.json
}

data "aws_iam_policy_document" "ecs_task_arp" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "aws_iam_role_policy" "ecs_task_permissions" {
  count = var.ecs_task_permissions != null ? 1 : 0

  name   = "ecs-task-permissions"
  policy = var.ecs_task_permissions
  role   = aws_iam_role.ecs_task.name
}
