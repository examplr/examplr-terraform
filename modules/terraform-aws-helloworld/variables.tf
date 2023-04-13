variable "container_port" {
  default = 8080
}

variable "image_tag" {
  type = string
}

variable "environment" {
  type = string
}

variable "hosts" {
  type = list(string)
}

variable "resources" {
  type = object({
    cpu    = optional(number, 256)
    memory = optional(number, 512)
  })

  default = {
    cpu    = 256
    memory = 512
  }
}

variable "profile" {
  type    = string
  default = null
}

variable "deploy" {
  default = false
}

variable "ecr_images_to_keep" {
  default = 10
}

variable "route53_zone_id" {
  type    = string
  default = null
}

variable "replicas" {
  default = 1
}
