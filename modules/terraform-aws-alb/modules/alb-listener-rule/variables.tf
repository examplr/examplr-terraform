
variable "vpc_id" {
  type = string
}

variable "alb_listener_arn" {
  type = string
}

variable "service" {
  type = string
}

variable "port" {
  type = number
  default = null
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

variable "health_check"{
  type = string
}
