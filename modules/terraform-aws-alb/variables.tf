variable "name" {
  description = "A name for the ALB that is unique to the AWS account."
  type        = string
}

variable "vpc_id"{
  type = string
}

variable "subnets" {
  description = "The subnets where the ALB should run."
  type = list(string)
}

variable "cert_domain_names" {
  description = "The domain names that should be on the ACM cert used by the HTTPs ALB listener."
  type = list(string)
}

variable "aliases_domain_names" {
  description = "The domain name aliases that should be mapped to public domain name of the ALB."
  type = list(string)
}