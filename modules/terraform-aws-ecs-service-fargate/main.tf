
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_lb" "alb" {
  name = var.alb_name
}

data "aws_lb_listener" "alb_listener" {
  load_balancer_arn = data.aws_lb.alb.arn
  port              = var.alb_listener_port
}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region = var.aws_region != "" ? var.aws_region : data.aws_region.current.name
  log_group = var.task_log_group != "" ? var.task_log_group : var.task_name
  ecr_repository_name = split("/", var.ecr_repository_url)[1]
}

# Log groups hold logs from our app.
resource "aws_cloudwatch_log_group" "log_group" {
  name = local.log_group
}

# The main service.
resource "aws_ecs_service" "service" {
  name            = "${var.task_name}"
  task_definition = aws_ecs_task_definition.task_definition.arn
  cluster         = var.ecs_cluster_name
  launch_type     = "FARGATE"

  desired_count = var.task_autoscale_min

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = local.ecr_repository_name
    container_port   = var.task_container_port
  }

  network_configuration {
    assign_public_ip = false
    //TODO should this be tightened up to the container port???
    security_groups = data.aws_lb.alb.security_groups
    subnets = var.service_subnets
  }
}



# The task definition for our app.
resource "aws_ecs_task_definition" "task_definition" {
  family = "${var.task_name}"

  container_definitions = <<EOF
  [
    {
      "name": "${local.ecr_repository_name}",
      "image": "${var.ecr_repository_url}:${var.ecr_repository_tag}",
      "portMappings": [
        {
          "containerPort": ${var.task_container_port},
          "hostPort": ${var.task_host_port}
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

  execution_role_arn = aws_iam_role.task_execution_role.arn

  # These are the minimum values for Fargate containers.
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  requires_compatibilities = ["FARGATE"]

  # This is required for Fargate containers (more on this later).
  network_mode = "awsvpc"
}

# This is the role under which ECS will execute our task. This role becomes more important
# as we add integrations with other AWS services later on.

# The assume_role_policy field works with the following aws_iam_policy_document to allow
# ECS tasks to assume this role we're creating.
resource "aws_iam_role" "task_execution_role" {
  name               = "${var.task_name}-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Normally we'd prefer not to hardcode an ARN in our Terraform, but since this is an AWS-managed
# policy, it's okay.
data "aws_iam_policy" "ecs_task_execution_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Attach the above policy to the execution role.
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = data.aws_iam_policy.ecs_task_execution_role.arn
}


resource "aws_lb_target_group" "target_group" {
  name        = "${var.task_name}"
  port        = var.task_container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_lb.alb.vpc_id

  health_check {
    enabled = true
    path    = var.target_group_health_check
  }
}



resource "aws_lb_listener_rule" "alb_rule" {
  listener_arn = data.aws_lb_listener.alb_listener.arn
  priority     = var.alb_listener_rule_priority

  action {
    type             = "forward"
    target_group_arn =aws_lb_target_group.target_group.arn
  }

  condition {
    path_pattern {
      values = var.alb_listener_rule_paths
    }
  }

  condition {
    host_header {
      values = var.alb_listener_rule_hosts
    }
  }
}




resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.task_autoscale_max
  min_capacity       = var.task_autoscale_min
  resource_id        = "service/${var.ecs_cluster_name}/${var.task_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = "${var.task_name}-memory-autoscaling"
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
  name               = "${var.task_name}-cpu-autoscaling"
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

