
# We need a cluster in which to put our service.
resource "aws_ecs_cluster" "cluster" {
  count = length(var.ecs_clusters)
  name =  "${local.environment}-${var.app_name}-${var.ecs_clusters[count.index]}"
}



module "ecs-fargate-microservice" {
  source = "../modules/terraform-aws-ecs-service-fargate"
  count = length(var.fargate_microservices)

  task_name = "${local.environment}-${var.app_name}-${var.fargate_microservices[count.index].task_name}"

  task_container_port = var.fargate_microservices[count.index].task_container_port
  task_host_port = var.fargate_microservices[count.index].task_host_port
  task_cpu = var.fargate_microservices[count.index].task_cpu
  task_memory = var.fargate_microservices[count.index].task_memory
  task_autoscale_min = var.fargate_microservices[count.index].task_autoscale_min
  task_autoscale_max = var.fargate_microservices[count.index].task_autoscale_max
  //task_log_group = "${var.fargate_microservices[count.index].task_log_group}-${var.app_environment}-${var.app_name}"

  ecr_repository_url = var.fargate_microservices[count.index].ecr_repository_url
  ecs_cluster_name = "${local.environment}-${var.app_name}-${var.fargate_microservices[count.index].ecs_cluster_name}"

  alb_name = "${local.environment}-${var.app_name}-${var.fargate_microservices[count.index].alb_name}-alb"
  alb_listener_port = var.fargate_microservices[count.index].alb_listener_port
  alb_listener_rule_paths = var.fargate_microservices[count.index].alb_listener_rule_paths
  alb_listener_rule_hosts = var.fargate_microservices[count.index].alb_listener_rule_hosts
  alb_listener_rule_priority = var.fargate_microservices[count.index].alb_listener_rule_priority


  //-- use a datasource to look this up by name or otherwise make it so it does not have to be passed
  //target_group_vpc_id = module.vpc.vpc_id

  service_subnets = module.vpc.private_subnets

  //service_security_groups = module.alb.security_groups

  depends_on = [module.vpc, module.alb]
}