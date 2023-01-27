
locals{
  ecs_service_keys = toset(keys(var.ecs_services))

  target_group_arn_map = merge([for v in module.alb : v.service_to_target_group_arn_map]...)
}

output "alb_target_group_arn_map"{
  value = local.target_group_arn_map
}


resource "aws_ecs_cluster" "cluster" {
  count = length(var.ecs_clusters)
  name  = "${var.app_env}-${var.app_name}-${var.ecs_clusters[count.index]}"
}

module "ecs-fargate-service" {
  source = "../modules/terraform-aws-ecs-service-fargate"

  for_each = local.ecs_service_keys

  name       = "${var.app_env}-${var.app_name}-${each.key}-ecs"
  app_region = var.app_region
  app_name   = var.app_name
  app_env    = var.app_env
  profile       = var.ecs_services[each.key].profile
  port          = var.ecs_services[each.key].port
  cpu           = var.ecs_services[each.key].cpu
  memory        = var.ecs_services[each.key].memory
  autoscale_min = var.ecs_services[each.key].autoscale_min
  autoscale_max = var.ecs_services[each.key].autoscale_max
  log_group     = var.ecs_services[each.key].log_group

  secret_arn = aws_secretsmanager_secret.secret.arn

  vpc_id  = var.vpc_id
  subnets_ids = var.vpc_private_subnet_ids

  target_group_arn = lookup(local.target_group_arn_map, each.key, null)

  cluster_name = (
  var.ecs_services[each.key].cluster_name != null ?
  "${var.app_env}-${var.app_name}-${var.ecs_services[each.key].cluster_name}" :
  "${var.app_env}-${var.app_name}-${var.ecs_clusters[0]}"
  )

  repository_url = (
  var.ecs_services[each.key].repository_url != null ?
  var.ecs_services[each.key].repository_url != null :
  "${var.ecr_account_id}.dkr.ecr.us-east-1.amazonaws.com/${each.key}"
  )

  repository_tag = (
  var.ecs_services[each.key].repository_tag != null ?
  var.ecs_services[each.key].repository_tag :
  "latest"
  )

}
