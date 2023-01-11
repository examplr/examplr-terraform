

variable "alb_name" {
  type = string
}

variable "port" {
  type = string
}

variable "paths" {
  type = list(string)
  default = null
}

variable "hosts" {
  type = list(string)
  default = null
}

variable "priority" {
  type = number
  default = 100
}

variable "target_group_arn" {
  type = string
}