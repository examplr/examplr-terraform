



variable "aws_region" {
  description = "Defaults to the current provider region"
  type = string
  default = ""
}


variable "alb_name" {
  type = string
}

variable "alb_listener_port" {
  type = number
}


variable "alb_listener_rule_paths" {
  description = "The paths on the ALB to forward to the target group"
  type = list(string)
}

variable "alb_listener_rule_hosts" {
  description = "The hosts on the ALB to forward to the target group"
  type = list(string)
}

variable "alb_listener_rule_priority" {
  description = "The priority on the ALB listener rule for the target group"
  type = number
}

variable "ecs_cluster_name" {
  description = "The ECS cluster to run the service/task."
  type        = string
}

variable "ecr_repository_url" {
  description = ""
  type = string
}

variable "ecr_repository_tag" {
  description = ""
  type        = string
  default     = "latest"
}

/*
variable "service_security_groups" {
  description = ""
  type        = list(string)
}
*/

variable "service_subnets" {
  description = ""
  type        = list(string)
}


variable "task_name" {
  description = "The logical name given to the task."
  type        = string
}


variable "task_container_port" {
  description = ""
  type = number
  default = 80
}

variable "task_host_port" {
  description = ""
  type = number
  default = 8080
}


variable "task_cpu" {
  description = "The task CPU allocation"
  type = number
  default = 1024
}

variable "task_memory" {
  description = "The task memory allocation"
  type = number
  default = 2048
}

variable "task_autoscale_min" {
  description = "The minimum number of task instances"
  type = number
  default = 1
}

variable "task_autoscale_max" {
  description = "The maximum number of task instances"
  type = number
  default = 2
}

variable "task_log_group" {
  description = ""
  type = string
  default = ""
}

/*
variable "target_group_vpc_id" {
  description = ""
  type        = string
}
*/

variable "target_group_health_check" {
  description = ""
  type        = string
  default     = "/health"
}
