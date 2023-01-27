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

variable "vpc_azs" {
  type = list(string)
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

variable "vpns" {
  type    = map(object({
    host_ip = string
    destination_cidr_block = optional(string)
  }))
  default = {}
}
