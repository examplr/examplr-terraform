data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

locals {
  /*
  Create a list of ports to allow ingress from various security groups
  The format of the list will be "<securit_group_id>:<port>"
  This will allow us to use the `distinct()` function to remove duplicates
  in case the container port and health check port are the same.
  */
  ecs_svc_ingress_ports = distinct(compact(flatten([
    [for i in var.ecs_task_container_ingress : format("%s:%d", i.alb_security_group_id, i.container.port)],
    [for i in var.ecs_task_container_ingress : format("%s:%d", i.alb_security_group_id, i.health_check.port) if can(i.health_check)],
  ])))

  ecs_svc_sg_ids = distinct(compact(flatten([
    var.ecs_svc_security_group_ids,
    var.ecs_svc_create_security_group ? [aws_security_group.ecs_sg[0].id] : [],
  ])))

  # Log configuration is managed by this module, so we merge it into the task container definitions
  ecs_task_container_definitions = jsonencode([for cd in var.ecs_task_container_definitions : merge(cd, local.log_configuration)])

  # Munge the ecs_task_container_ingress variable to make it a map of container name => ingress, used to index the ingress rules by name rather than position
  ecs_task_container_ingress = { for ingress in var.ecs_task_container_ingress : (ingress.container.name) => ingress }

  ecs_task_route53_records = merge([for ingress in var.ecs_task_container_ingress : { for host in ingress.hosts : (host) => ingress.alb_listener_arn }]...)

  ecs_task_requires_compatibilities = var.ecs_task_requires_compatibilities != null ? var.ecs_task_requires_compatibilities : (
    var.ecs_svc_launch_type != "EXTERNAL" ? [var.ecs_svc_launch_type] : null
  )

  # Get a list of ECS task secrets to grant permission for the ECS task executor to fetch them
  ecs_task_secrets = distinct(compact(flatten([for cd in var.ecs_task_container_definitions : [for s in cd.secrets != null ? cd.secrets : [] : s.valueFrom]])))

  log_configuration = var.ecs_task_create_log_group ? {
    logConfiguration = {
      logDriver = "awslogs"

      options = {
        awslogs-region        = data.aws_region.current.name
        awslogs-group         = aws_cloudwatch_log_group.ecs_task[0].name
        awslogs-stream-prefix = "ecs"
      }
    }
  } : {}

  # If var.project and var.service name are the same, omit var.service to avoid redundancy in the name
  name = join("-", distinct([var.environment, var.project, var.service]))

  tags = merge({
    environment = var.environment
    project     = var.project
    region      = data.aws_region.current.name
    service     = var.service
  }, var.tags)
}
