
variable "app_aws_region" {
  type = string
  default = "us-east-1"
}

variable "app_aws_access_key" {
  type = string
}

variable "app_aws_secret_key" {
  type = string
}

variable "app_name" {
  description = "The name of the logical 'app' that this terraform corresponds to.  This value will be used to tag and prefix or postfix many of the created resources."
  type        = string
  default = "app"
}


variable "app_environment" {
  description = "The environment of the logical 'app' that this terraform corresponds to.  For example 'dev' or 'prod'.  This value will be used to tag and prefix or postfix many of the created resources.  Defaults to $${terraform.workspace}"
  type        = string
  default     = ""
}


variable "tag_project"{
  description = "The umbrella project this app is related to.  Tagged as 'Project'. Defaults to '$${var.app_name}'."
  type = string
  default = ""
}

variable "tag_cost_center"{
  description = "The cost center responsible for the bills.  Tagged as 'CostCenter'.  Defaults to '$${var.app_name}'."
  type = string
  default = ""
}

variable "tag_owner"{
  description = "The organizational unit responsible for this infrastructure."
  type = string
  default = "devops"
}

variable "tag_terraform_repo"{
  description = "The git repo url where this terraform script is found.  Tagged as 'TerraformRepo"
  type = string
  default = "local"
}


variable "additional_tags" {
  description = "Additional global tags for all resources."
  type        = map(string)
  default     = {}
}


variable "albs" {
  description = "The ALBs to create.  Each name  Each name provided will be prefixed with '$${var.app_environment}-$${var.app_name}-' automatically. The resulting name must be unique to the AWS account."
  type = list(object({
    name = string
    ports = list(number)
    alias_domain_names = list(string)
    cert_domain_names = list(string)
  }))
}


variable "ecs_clusters" {
  description = "The ECS clusters to create.  Each name provided will be prefixed with '$${var.app_environment}-$${var.app_name}-' automatically. The resulting name must be unique to the AWS account."
  type        = list(string)
}




variable "fargate_microservices" {
  description = "Definitions of container/tasks that should run as ECS Fargate services and connected to an ALB with autoscaling."
  type = list(object({
    task_name = string
    task_container_port = number
    task_host_port = number
    task_cpu = number
    task_memory = number
    task_autoscale_min = number
    task_autoscale_max = number
    task_log_group = optional(string)

    ecr_repository_url = string
    ecr_repository_tag = string
    ecs_cluster_name = string

    //-- the 'name' property of the target alb as defined in the 'albs' var.
    alb_name = string
    alb_listener_port = number
    alb_listener_rule_paths = list(string)
    alb_listener_rule_hosts = list(string)
    alb_listener_rule_priority = number

  }))

  /*
  default = [
    {

      alb_arn = aws_alb.alb.arn
      ecs_cluster = aws_ecs_cluster.cluster.name
      service_security_groups = [
        aws_security_group.egress_all.id,
        aws_security_group.ingress_api.id,
      ]

      service_subnets = [
        aws_subnet.private_d.id,
        aws_subnet.private_e.id,
      ]

    }
  ]*/

}