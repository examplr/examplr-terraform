variable "vpc_id" {
  type = string
}

variable "alb_arn" {
  type = string
}

variable "port" {
  type = number
}

variable "dns_aliases" {
  type = list(string)
}

variable "cert_names" {
  type    = list(string)
  default = null
}

variable "rules" {
  type = list(object(
    {
      service      = string
      port         = optional(number)
      paths        = optional(list(string))
      hosts        = optional(list(string))
      priority     = optional(number)
      health_check = optional(string)
    }))
}