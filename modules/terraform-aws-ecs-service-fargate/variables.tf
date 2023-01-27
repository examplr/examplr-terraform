
variable "app_name" {
  type = string
}

variable "app_env" {
  type = string
}

variable "app_region" {
  type = string
}

variable "name" {
  description = "The logical name given to the task."
  type        = string
}

variable "profile" {
  description = "Defaults to app_env"
  type        = string
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

variable "cluster_name" {
  type = string
}

variable "repository_url" {
  type = string
}

variable "repository_tag" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnets_ids" {
  description = ""
  type        = list(string)
}

variable "target_group_arn" {
  type = string
}

variable "secret_arn"{
  type = string
}