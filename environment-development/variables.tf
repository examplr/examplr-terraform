

variable "env_aws_access_key" {
  type = string
}

variable "env_aws_secret_key" {
  type = string
}

variable "app_name" {
  description = "The name of the logical 'app' that this terraform corresponds to.  This value will be used to tag and prefix or postfix many of the created resources."
  type        = string
}

variable "app_region" {
  type    = string
  default = "us-east-1"
}

variable "app_env" {
  description = "The environment of the logical 'app' that this terraform corresponds to.  For example 'dev' or 'prod'.  This value will be used to tag and prefix or postfix many of the created resources.  Defaults to $${terraform.workspace}"
  type        = string
}

variable "app_domain" {
  type        = string
  description = "The domain name corresponding to the Route53 zone where DNS records should be placed"
}

variable "additional_tags" {
  description = "Additional global tags for all resources."
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {
  type = string
}

variable "vpc_public_subnets" {
  type = list(string)
}

variable "vpc_private_subnets" {
  type = list(string)
}

variable "vpc_database_subnets" {
  type = list(string)
}

variable "vpn_host" {
  type    = string
  default = null
}

variable "mysql_user" {
  type    = string
  default = "root"
}

variable "mysql_pass" {
  type    = string
  default = "password"
}


variable "vpn_destination_cidr_block" {
  type    = string
  default = "10.255.0.0/16"
}


variable "albs" {
  description = "The ALBs to create.  Each name  Each name provided will be prefixed with '$${var.app_env}-$${var.app_name}-' automatically. The resulting name must be unique to the AWS account."
  type        = list(object({
    name        = string
    dns_aliases = list(string)
    listeners   = list(object({
      port  = number
      cert  = optional(list(string))
      rules = optional(list(object({
        service      = string
        port         = number
        paths        = optional(list(string))
        hosts        = optional(list(string))
        priority     = optional(number)
        health_check = optional(string)
      })))
    }))
  }))
}

variable "ecr_account_id" {
  type = string
}

variable "ecs_clusters" {
  description = "The ECS clusters to create.  Each name provided will be prefixed with '$${var.app_env}-$${var.app_name}-' automatically. The resulting name must be unique to the AWS account."
  type        = list(string)
}

variable "ecs_services" {
  description = "Definitions of container/tasks that should run as ECS Fargate services and connected to an ALB with autoscaling."
  type        = list(object({

    name          = string
    profile       = optional(string)
    port          = optional(number)
    cpu           = optional(number)
    memory        = optional(number)
    autoscale_min = optional(number)
    autoscale_max = optional(number)
    log_group     = optional(string)
    health_check  = optional(string)

    cluster_name   = optional(string)
    repository_url = optional(string)
    repository_tag = optional(string)

  }))
}


