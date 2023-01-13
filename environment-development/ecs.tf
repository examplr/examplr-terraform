//-- We need a cluster in which to put our service.
resource "aws_ecs_cluster" "cluster" {
  count = length(var.ecs_clusters)
  name  = "${local.environment}-${var.app_name}-${var.ecs_clusters[count.index]}"
}


module "ecs-fargate-service" {
  source = "../modules/terraform-aws-ecs-service-fargate"
  count  = length(var.ecs_services)

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.private_subnets

  name  = "${local.environment}-${var.app_name}-${var.ecs_services[count.index].name}-ecs"

  target_group_arn = lookup(merge(module.alb[*].alias_to_target_group_arn_map...), var.ecs_services[count.index].alias != null ? var.ecs_services[count.index].alias : var.ecs_services[count.index].name, null)


  port          = var.ecs_services[count.index].port
  cpu           = var.ecs_services[count.index].cpu
  memory        = var.ecs_services[count.index].memory
  autoscale_min = var.ecs_services[count.index].autoscale_min
  autoscale_max = var.ecs_services[count.index].autoscale_max
  log_group     = var.ecs_services[count.index].log_group
  health_check  = var.ecs_services[count.index].health_check

  cluster_name = (
  var.ecs_services[count.index].cluster_name != null ?
  "${local.environment}-${var.app_name}-${var.ecs_services[count.index].cluster_name}" :
  "${local.environment}-${var.app_name}-${var.ecs_clusters[0]}"
  )

  repository_url = (
  var.ecs_services[count.index].repository_url != null ?
  var.ecs_services[count.index].repository_url != null :
  "${var.devops_account_id}.dkr.ecr.us-east-1.amazonaws.com/${var.ecs_services[count.index].name}"
  )

  repository_tag = (
  var.ecs_services[count.index].repository_tag != null ?
  var.ecs_services[count.index].repository_tag :
  "latest"
  )

}