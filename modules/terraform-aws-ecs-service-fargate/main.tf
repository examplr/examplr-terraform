data "aws_region" "current" {}

locals {
  region        = data.aws_region.current.name
  port          = var.port != null ? var.port : 8080
  cpu           = var.cpu != null ? var.cpu : 1024
  memory        = var.memory != null ? var.memory : 2048
  autoscale_min = var.autoscale_min != null ? var.autoscale_min : 1
  autoscale_max = var.autoscale_max != null ? var.autoscale_max : 2
  log_group     = var.log_group != null ? var.log_group : var.name
  health_check  = var.health_check != null ? var.health_check : "/health"

  ecr_repository_name = split("/", var.repository_url)[1]
}

# Log groups hold logs from our app.
resource "aws_cloudwatch_log_group" "log_group" {
  name = local.log_group
}


# The task definition for our app.
resource "aws_ecs_task_definition" "task_definition" {
  family = "${var.name}"

  container_definitions = <<EOF
  [
    {
      "name": "${local.ecr_repository_name}",
      "image": "${var.repository_url}:${var.repository_tag}",
      "portMappings": [
        {
          "containerPort": ${local.port}
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-region": "${local.region}",
          "awslogs-group": "${local.log_group}",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
EOF

  cpu                      = local.cpu
  memory                   = local.memory
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn = aws_iam_role.execution_role.arn
  task_role_arn      = aws_iam_role.task_role.arn

  #  lifecycle {
  #    create_before_destroy = true
  #    ignore_changes        = [container_definitions]
  #  }

}


data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "execution_role" {
  name               = "${var.name}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Attach the above policy to the execution role.
resource "aws_iam_role_policy_attachment" "attach_execution_policy" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "task_role" {
  name               = "${var.name}-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "task_policy" {
  name   = "${var.name}-task-policy"
  policy = var.policy
}

resource "aws_iam_role_policy_attachment" "attach_task_policy" {
  role       = aws_iam_role.task_role.name
  policy_arn = aws_iam_policy.task_policy.arn
}


# The main service.
resource "aws_ecs_service" "service" {
  name            = "${var.name}"
  task_definition = aws_ecs_task_definition.task_definition.arn
  cluster         = var.cluster_name
  launch_type     = "FARGATE"
  desired_count   = local.autoscale_min

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = local.ecr_repository_name
    container_port   = local.port
  }

  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.egress.id, aws_security_group.ingress.id]
    subnets          = var.subnets
  }
}

resource "aws_security_group" "egress" {
  name        = "${var.name}-egress"
  description = "Allow all outbound traffic"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-egress-all"
  }
}

resource "aws_security_group" "ingress" {
  name        = "${var.name}-ingress-${local.port}"
  description = "Allow inbound port ${local.port} traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = local.port
    to_port     = local.port
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-ingress-${local.port}"
  }
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = local.autoscale_max
  min_capacity       = local.autoscale_min
  resource_id        = "service/${var.cluster_name}/${var.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [aws_ecs_service.service]
}

resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = "${var.name}-memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = 80
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name               = "${var.name}-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 80
  }
}


