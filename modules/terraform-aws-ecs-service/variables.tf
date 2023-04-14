variable "ecs_cluster" {
  description = "ECS cluster object for this task. (Pass in the ecs_cluster Terraform resource.)"

  type = object({
    arn  = string
    name = string
  })
}

variable "ecs_svc_assign_public_ip" {
  description = "Determines whether or not to assign public IPs to the ECS tasks created by the ECS service. Only set to true if running in a public subnet."
  type        = bool
  default     = false
}

variable "ecs_svc_create_security_group" {
  description = "Determines whether or not to create a security group, allowing ingress from the specified ALB to the ECS service."
  type        = bool
  default     = true
}

variable "ecs_svc_deployment_circuit_breaker" {
  description = "Configuration block for deployment circuit breaker. See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/deployment-circuit-breaker.html for more info."

  type = object({
    enable   = bool
    rollback = bool
  })

  default = null
}

variable "ecs_svc_deployment_max_percent" {
  description = "Upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment. Not valid when using the DAEMON scheduling strategy."
  type        = number
  default     = null
}

variable "ecs_svc_deployment_min_healthy_percent" {
  description = "Lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment."
  type        = number
  default     = null
}

variable "ecs_svc_desired_count" {
  description = "Number of instances of the task definition to place and keep running."
  type        = number
  default     = null
}

variable "ecs_svc_enable_ecs_managed_tags" {
  description = "Specifies whether to enable Amazon ECS managed tags for the tasks within the service. See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-using-tags.html#managed-tags for more info."
  type        = bool
  default     = true
}

variable "ecs_svc_enable_execute_command" {
  description = "Specifies whether to enable Amazon ECS Exec for the tasks within the service. See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-exec.html for more info."
  type        = bool
  default     = false
}

variable "ecs_svc_force_new_deployment" {
  description = "Enable to force a new task deployment of the service."
  type        = bool
  default     = false
}

variable "ecs_svc_health_check_grace_period" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks"
  type        = number
  default     = null

  validation {
    condition = var.ecs_svc_health_check_grace_period == null ? true : (
      (var.ecs_svc_health_check_grace_period > 0) && (var.ecs_svc_health_check_grace_period <= 2147483647)
    )

    error_message = "Variable ecs_svc_health_check_grace_period must be betweek 1 and 2147483647 inclusive, or null."
  }
}

variable "ecs_svc_launch_type" {
  description = "Launch type on which to run your service."
  type        = string
  default     = "FARGATE"

  validation {
    condition     = contains(["EC2", "FARGATE", "EXTERNAL"], var.ecs_svc_launch_type)
    error_message = "Variable ecs_svc_launch_type must be one of: EC2, FARGATE, or EXTERNAL."
  }
}

variable "ecs_svc_platform_version" {
  description = "Platform version on which to run your service. See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/platform_versions.html for more info."
  type        = string
  default     = "1.4.0"
}

variable "ecs_svc_propagate_tags" {
  description = "Specifies whether to propagate the tags from the task definition or the service to the tasks."
  type        = string
  default     = null

  validation {
    condition     = var.ecs_svc_propagate_tags == null ? true : contains(["SERVICE", "TASK_DEFINITION"], var.ecs_svc_propagate_tags)
    error_message = "Variable ecs_svc_propagate_tags must be one of: SERVICE, or TASK_DEFINITION."
  }
}

variable "ecs_svc_scheduling_strategy" {
  description = "Scheduling strategy to use for the service."
  type        = string
  default     = "REPLICA"

  validation {
    condition     = contains(["REPLICA", "DAEMON"], var.ecs_svc_scheduling_strategy)
    error_message = "Variable ecs_svc_scheduling_strategy must be one of: REPLICA, or DAEMON."
  }
}

variable "ecs_svc_security_group_ids" {
  description = "List of additional security group IDs to attach to the ECS service."
  type        = list(string)
  default     = []
}

variable "ecs_svc_subnet_ids" {
  description = "Subnet IDs to associate the ECS service with."
  type        = list(string)
}

variable "ecs_svc_wait_for_steady_state" {
  description = "If true, Terraform will wait for the service to reach a steady state (like aws ecs wait services-stable) before continuing."
  type        = bool
  default     = false
}

variable "ecs_task_container_definitions" {
  description = "ECS task container definitions."

  type = list(object({
    name  = string
    image = string

    portMappings = optional(list(object({
      containerPort = number
      protocol      = optional(string)
    })))

    entryPoint = optional(list(string))
    command    = optional(list(string))

    environment = optional(list(object({
      name  = string
      value = string
    })))

    secrets = optional(list(object({
      name      = string
      valueFrom = string
    })))

    healthCheck = optional(object({
      command     = list(string)
      interval    = optional(number)
      timeout     = optional(number)
      retries     = optional(number)
      startPeriod = optional(number)
    }))
  }))
}

variable "ecs_task_container_ingress" {
  description = "Ingress attributes for ESC task containers."

  type = list(object({
    alb_listener_arn      = string
    alb_security_group_id = string

    container = object({
      name     = string
      port     = number
      protocol = optional(string, "HTTP")
    })

    health_check = optional(object({
      enabled = bool
      path    = string
      port    = number
    }))

    hosts = optional(list(string), [])
    paths = optional(list(string), [])
  }))

  default = []
}

variable "ecs_task_create_log_group" {
  description = "Specifies whether or not to create a log group in Cloudwatch for the ECS task."
  type        = bool
  default     = true
}

variable "ecs_task_log_group_retention" {
  description = "Specifies the number of days you want to retain log events in the specified log group."
  type        = number
  default     = 30

  validation {
    condition     = contains([0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653], var.ecs_task_log_group_retention)
    error_message = "Variable cw_log_group_retention must be one of [0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653]."
  }
}

variable "ecs_task_permissions" {
  description = "IAM policy document granting necessary permissions to the ECS task. (Use data.iam_policy_document.foo.json as the value for this variable.)"
  type        = string
  default     = null
}

variable "ecs_task_resources" {
  description = "Compute resources for the ECS task."

  type = object({
    cpu    = number
    memory = number
  })
}

variable "ecs_task_requires_compatibilities" {
  description = "Set of launch types required by the task."
  type        = list(string)
  default     = null

  validation {
    condition = var.ecs_task_requires_compatibilities == null ? true : alltrue(
      [for c in var.ecs_task_requires_compatibilities : contains(["EC2", "FARGATE"], c)]
    )

    error_message = "Valid values for ecs_task_requires_compatibilities are EC2 and FARGATE."
  }
}

variable "ecs_task_skip_destroy" {
  description = "Whether to retain the old revision when the resource is destroyed or replacement is necessary."
  type        = bool
  default     = false
}

variable "environment" {
  description = "The environment in which the service runs in."
  type        = string
}

variable "project" {
  description = "The project that the service belongs to. (ex: name-generator, helloworld)"
  type        = string
}

variable "route53_zone_id" {
  description = "The Route53 Zone ID to create DNS records in."
  type        = string
  default     = null
}

variable "service" {
  description = "The specific service in the project. (ex: api-v1, greeter)"
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to all resources managed by this module."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "The VPC in which to create the ECS related resources."
  type        = string
}
