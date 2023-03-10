variable "name" {
  description = "A name for the ALB that is unique to the AWS account."
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  description = "The subnets where the ALB should run."
  type        = list(string)
}

variable "dns_names" {
  type    = list(string)
  default = null
}

variable "listeners" {
  type = map(object({
    cert  = optional(list(string))
    rules = map(object({
      paths        = optional(list(string))
      hosts        = optional(list(string))
      priority     = optional(number)
      health_check = optional(string)
    }))
  }))
}
