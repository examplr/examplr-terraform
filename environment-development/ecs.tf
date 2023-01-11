# We need a cluster in which to put our service.
resource "aws_ecs_cluster" "cluster" {
  count = length(var.ecs_clusters)
  name  = "${local.environment}-${var.app_name}-${var.ecs_clusters[count.index]}"
}


module "ecs-fargate-microservice" {
  source = "../modules/terraform-aws-ecs-service-fargate"
  count  = length(var.fargate_microservices)

  name           = "${local.environment}-${var.app_name}-${var.fargate_microservices[count.index].name}"
  container_port = var.fargate_microservices[count.index].container_port
  host_port      = var.fargate_microservices[count.index].host_port
  cpu            = var.fargate_microservices[count.index].cpu
  memory         = var.fargate_microservices[count.index].memory
  autoscale_min  = var.fargate_microservices[count.index].autoscale_min
  autoscale_max  = var.fargate_microservices[count.index].autoscale_max
  log_group      = var.fargate_microservices[count.index].log_group
  health_check   = var.fargate_microservices[count.index].health_check

  cluster_name = (
    var.fargate_microservices[count.index].cluster_name != null ?
    "${local.environment}-${var.app_name}-${var.fargate_microservices[count.index].cluster_name}" :
    "${local.environment}-${var.app_name}-${var.ecs_clusters[0]}"
  )

  repository_url = (
      var.fargate_microservices[count.index].repository_url != null ?
      var.fargate_microservices[count.index].repository_url != null :
      "${var.devops_account_id}.dkr.ecr.us-east-1.amazonaws.com/${var.fargate_microservices[count.index].name}"
  )

  repository_tag = (
    var.fargate_microservices[count.index].repository_tag != null ?
    var.fargate_microservices[count.index].repository_tag :
    "latest"
  )

  alb_name  = (
    var.fargate_microservices[count.index].alb_name != null ?
    "${local.environment}-${var.app_name}-${var.fargate_microservices[count.index].alb_name}-alb" :
    "${local.environment}-${var.app_name}-${var.albs[0].name}-alb"
  )
  alb_rules = var.fargate_microservices[count.index].alb_rules

  service_subnets = module.vpc.private_subnets

  depends_on = [module.vpc, module.alb]
}