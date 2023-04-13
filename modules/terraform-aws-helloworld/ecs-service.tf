module "this" {
  source = "../terraform-aws-ecs-service"
  count  = var.deploy ? 1 : 0

  environment = var.environment
  project     = local.project
  service     = local.service

  ecs_cluster           = local.ecs
  ecs_svc_desired_count = var.replicas
  ecs_svc_subnet_ids    = local.vpc.private_subnets
  vpc_id                = local.vpc.id
  route53_zone_id       = var.route53_zone_id

  ecs_task_log_group_retention      = 1
  ecs_task_requires_compatibilities = ["FARGATE"]

  # ecs_task_permissions = "data.aws_iam_policy_document.permissions.json"

  ecs_task_container_definitions = [{
    name  = local.ecr_repository_name
    image = format("%s:%s", module.ecr.repository_url, var.image_tag)

    portMappings = [{
      containerPort = var.container_port
    }]

    environment = [
      {
        name  = "PORT"
        value = tostring(var.container_port)
      },
      {
        name  = "spring_profiles_active",
        value = local.profile
      },
      {
        name  = "BAR",
        value = "foo"
      },
    ]

    # secrets = [
    #   {
    #     name      = "mysql.user",
    #     valueFrom = "TODO: AWS SSM SECRET"
    #   },
    #   {
    #     name      = "mysql.pass",
    #     valueFrom = "TODO: AWS SSM SECRET"
    #   },
    # ]
  }]

  ecs_task_container_ingress = [{
    alb_listener_arn      = local.alb.listener_arn
    alb_security_group_id = local.alb.sg_id
    hosts                 = var.hosts

    container = {
      name = local.ecr_repository_name
      port = var.container_port
    }

    health_check = {
      enabled = true
      path    = "/actuator/health"
      port    = var.container_port
    }
  }]

  ecs_task_resources = {
    cpu    = var.resources.cpu
    memory = var.resources.memory
  }
}
