variable "env_aws_region" {
  type    = string
  default = "us-east-1"
}

variable "env_aws_access_key" {
  type = string
}

variable "env_aws_secret_key" {
  type = string
}

variable "devops_account_id" {
  type = string
}

variable "app_name" {
  description = "The name of the logical 'app' that this terraform corresponds to.  This value will be used to tag and prefix or postfix many of the created resources."
  type        = string
  default     = "app"
}


variable "app_environment" {
  description = "The environment of the logical 'app' that this terraform corresponds to.  For example 'dev' or 'prod'.  This value will be used to tag and prefix or postfix many of the created resources.  Defaults to $${terraform.workspace}"
  type        = string
  default     = ""
}


variable "tag_project" {
  description = "The umbrella project this app is related to.  Tagged as 'Project'. Defaults to '$${var.app_name}'."
  type        = string
  default     = ""
}

variable "tag_cost_center" {
  description = "The cost center responsible for the bills.  Tagged as 'CostCenter'.  Defaults to '$${var.app_name}'."
  type        = string
  default     = ""
}

variable "tag_owner" {
  description = "The organizational unit responsible for this infrastructure."
  type        = string
  default     = "devops"
}

variable "tag_terraform_repo" {
  description = "The git repo url where this terraform script is found.  Tagged as 'TerraformRepo"
  type        = string
  default     = "local"
}


variable "additional_tags" {
  description = "Additional global tags for all resources."
  type        = map(string)
  default     = {}
}


variable "albs" {
  description = "The ALBs to create.  Each name  Each name provided will be prefixed with '$${var.app_environment}-$${var.app_name}-' automatically. The resulting name must be unique to the AWS account."
  type        = list(object({
    name               = string
    alias_domain_names = list(string)
    cert_domain_names  = list(string)
  }))
}

variable "ecs_clusters" {
  description = "The ECS clusters to create.  Each name provided will be prefixed with '$${var.app_environment}-$${var.app_name}-' automatically. The resulting name must be unique to the AWS account."
  type        = list(string)
}

variable "fargate_microservices" {
  description = "Definitions of container/tasks that should run as ECS Fargate services and connected to an ALB with autoscaling."
  type        = list(object({

    name           = string
    container_port = optional(number)
    host_port      = optional(number)
    cpu            = optional(number)
    memory         = optional(number)
    autoscale_min  = optional(number)
    autoscale_max  = optional(number)
    log_group      = optional(string)
    health_check   = optional(string)

    cluster_name   = optional(string)
    repository_url = optional(string)
    repository_tag = optional(string)

    alb_name  = optional(string)
    alb_rules = list(object({
      port     = number
      paths    = optional(list(string))
      hosts    = optional(list(string))
      priority = optional(number)
    }))

  }))

}