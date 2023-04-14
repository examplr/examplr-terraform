resource "aws_ecs_service" "this" {
  cluster                            = var.ecs_cluster.arn
  deployment_maximum_percent         = var.ecs_svc_deployment_max_percent
  deployment_minimum_healthy_percent = var.ecs_svc_deployment_min_healthy_percent
  desired_count                      = var.ecs_svc_desired_count
  enable_ecs_managed_tags            = var.ecs_svc_enable_ecs_managed_tags
  enable_execute_command             = var.ecs_svc_enable_execute_command
  force_new_deployment               = var.ecs_svc_force_new_deployment
  health_check_grace_period_seconds  = var.ecs_svc_health_check_grace_period
  launch_type                        = var.ecs_svc_launch_type
  name                               = local.name
  platform_version                   = var.ecs_svc_platform_version
  propagate_tags                     = var.ecs_svc_propagate_tags
  scheduling_strategy                = var.ecs_svc_scheduling_strategy
  tags                               = local.tags
  task_definition                    = aws_ecs_task_definition.this.arn
  triggers                           = null
  wait_for_steady_state              = var.ecs_svc_wait_for_steady_state

  # alarms - This will require configuration options to pass in alarm names, or create the alarms themselves.

  dynamic "deployment_circuit_breaker" {
    for_each = var.ecs_svc_deployment_circuit_breaker != null ? [var.ecs_svc_deployment_circuit_breaker] : []

    content {
      enable   = deployment_circuit_breaker.value.enable
      rollback = deployment_circuit_breaker.value.rollback
    }
  }

  dynamic "load_balancer" {
    for_each = local.ecs_task_container_ingress

    content {
      container_name   = load_balancer.value.container.name
      target_group_arn = aws_lb_target_group.ecs_ingress[load_balancer.key].arn
      container_port   = load_balancer.value.container.port
    }
  }

  network_configuration {
    subnets          = var.ecs_svc_subnet_ids
    security_groups  = local.ecs_svc_sg_ids
    assign_public_ip = var.ecs_svc_assign_public_ip
  }

  lifecycle {
    ignore_changes = [desired_count]

    precondition {
      condition     = var.ecs_svc_scheduling_strategy == "DAEMON" ? (var.ecs_svc_launch_type == "EC2") : true
      error_message = "When using DAEMON scheduling strategy, var.ecs_svc_launch_type must also be EC2."
    }

    precondition {
      condition     = var.ecs_svc_scheduling_strategy == "DAEMON" ? (var.ecs_svc_desired_count == null) : true
      error_message = "When using DAEMON scheduling strategy, var.ecs_svc_desired_count must not be set."
    }

    precondition {
      condition     = var.ecs_svc_scheduling_strategy == "DAEMON" ? (var.ecs_svc_deployment_max_percent == null) : true
      error_message = "When using DAEMON scheduling strategy, var.ecs_svc_deployment_max_percent must not be set."
    }

    precondition {
      condition     = var.ecs_svc_scheduling_strategy == "DAEMON" ? (var.ecs_svc_deployment_min_healthy_percent == null) : true
      error_message = "When using DAEMON scheduling strategy, var.ecs_svc_deployment_min_healthy_percent must not be set."
    }

    precondition {
      condition     = var.ecs_svc_health_check_grace_period != null ? (length(var.ecs_task_container_ingress) != 0) : true
      error_message = "Variable ecs_svc_health_check_grace_period can only be set when service is configured to use a load balancer."
    }

    precondition {
      condition     = var.ecs_svc_platform_version != null ? (var.ecs_svc_launch_type == "FARGATE") : true
      error_message = "Variable ecs_svc_platform_version can only be set when service is configured to use Fargate."
    }
  }
}

resource "aws_ecs_task_definition" "this" {
  container_definitions    = local.ecs_task_container_definitions
  cpu                      = var.ecs_task_resources.cpu
  execution_role_arn       = aws_iam_role.ecs_executor.arn
  family                   = local.name
  memory                   = var.ecs_task_resources.memory
  network_mode             = "awsvpc"
  requires_compatibilities = local.ecs_task_requires_compatibilities
  skip_destroy             = var.ecs_task_skip_destroy
  tags                     = local.tags
  task_role_arn            = aws_iam_role.ecs_task.arn

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_log_group" "ecs_task" {
  count = var.ecs_task_create_log_group ? 1 : 0

  # Name should turn out to `ecs/env/project/service`
  name              = "ecs/${join("/", split("-", local.name))}"
  retention_in_days = var.ecs_task_log_group_retention
  tags              = local.tags
}
