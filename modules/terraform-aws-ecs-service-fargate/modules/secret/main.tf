
data "aws_iam_role" "ecs_task_execution_role" {
  name = var.ecs_task_execution_role
}


data aws_iam_policy_document secrets_policy {
  statement {
    effect = "Allow"
    principals {
      identifiers = [data.aws_iam_role.ecs_task_execution_role.arn]
      type = "AWS"
    }
    actions = [
      "secretsmanager:GetSecret",
      "secretsmanager:GetSecretValue"
    ]
    resources = ["*"]
  }
}


resource "aws_secretsmanager_secret_policy" "example" {
  secret_arn = var.secret_arn
  policy = data.aws_iam_policy_document.secrets_policy.json
}


resource aws_iam_policy secrets_access {
  name        = "secrets_access"
  description = "Access rights to SecretsManager Secret created by terraform-aws-ecs-secrets-manager module"

  policy = <<-POLICY
  {
     "Version": "2012-10-17",
     "Statement": [
         {
             "Effect": "Allow",
             "Action": [
                 "secretsmanager:GetResourcePolicy",
                 "secretsmanager:GetSecretValue",
                 "secretsmanager:DescribeSecret",
                 "secretsmanager:ListSecretVersionIds"
             ],
             "Resource": [
               "${var.secret_arn}"
             ]
         }
     ]
  }
  POLICY
}

resource aws_iam_role_policy_attachment secret_access {
  role       = var.ecs_task_execution_role
  policy_arn = aws_iam_policy.secrets_access.arn
}
