variable "name" {
  description = "The logical name given to the task."
  type        = string
}

variable "target_group_arn" {
  type = string
}


variable "port" {
  description = ""
  type        = number
  default     = 8080
}

variable "cpu" {
  description = "The task CPU allocation"
  type        = number
  default     = 1024
}

variable "memory" {
  description = "The task memory allocation"
  type        = number
  default     = 2048
}

variable "autoscale_min" {
  description = "The minimum number of task instances"
  type        = number
  default     = 1
}

variable "autoscale_max" {
  description = "The maximum number of task instances"
  type        = number
  default     = 2
}

variable "log_group" {
  description = ""
  type        = string
  default     = ""
}

variable "health_check" {
  description = ""
  type        = string
  default     = "/health"
}

variable "cluster_name" {
  type = string
}

variable "repository_url" {
  type = string
}

variable "repository_tag" {
  type = string
}

/*
variable "alb_name" {
  type = string
}

variable "alb_rules" {
  type = list(object({
      port          = number
      paths    = list(string)
      hosts    = list(string)
      priority = number
    }))
}
*/

variable "vpc_id" {
  type = string
}

variable "subnets" {
  description = ""
  type        = list(string)
}


