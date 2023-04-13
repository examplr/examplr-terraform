variable "alb_cert_domain_name" {
  description = "Domain name for the ACM cert attached to the ALB. This can be a wildcard. If it does not end with a `.`, var.route53_domain_name will be appended to it."
  type        = string
}

variable "alb_cert_sans" {
  description = "List of subject alternative names for the ACM cert attached to the ALB. These can be wildcards. If any entry does not end with a `.`, var.route53_domain_name will be appended to it."
  type        = list(string)
  default     = []
}

variable "alb_create_dns_records" {
  description = "Determines whether or not to create Route53 records in the specified zone for the cert domain name, and all SANs. Wildcard DNS records can be created."
  type        = bool
  default     = true
}

variable "create_alb" {
  description = "Determines whether or not to create an ALB to allow ingress to the ECS cluster."
  type        = bool
  default     = true
}

variable "create_outputs_as_ssm_parameters" {
  description = "When set to `true` outputs will also be stored as SSM parameters. Use the nested module to fetch them."
  type        = bool
  default     = true
}

variable "environment" {
  description = "The name of the environment in which to stand up all resources managed by this module."
  type        = string
}

variable "route53_domain_name" {
  description = "The domain name for the Route53 hosted zone in which to create create ACM DNS validation records."
  type        = string
}

variable "route53_private_zone" {
  description = "Specify if the Route53 hosted zone is a private zone or not."
  type        = bool
  default     = false
}

variable "vpc_azs" {
  description = "List of availability zones to deploy VPC subnets to. Specify the full AZ name. Ex: `us-east-1a`."
  type        = list(string)
}

variable "vpc_cidr" {
  description = "Network CIDR for the VPC."
  type        = string
}

variable "vpc_database_subnets" {
  description = "List of database subnets, in CIDR format, to create for the VPC."
  type        = list(string)
  default     = null
}

variable "vpc_enable_nat_gateway" {
  description = "Determines whether or not to create NAT gateway(s) for the VPC."
  type        = bool
  default     = true
}

variable "vpc_private_subnets" {
  description = "List of private subnets, in CIDR format, to create for the VPC."
  type        = list(string)
  default     = null
}

variable "vpc_public_subnets" {
  description = "List of public subnets, in CIDR format, to create for the VPC."
  type        = list(string)
  default     = null
}

variable "vpc_single_nat_gateway" {
  description = "Set to `true` to create a single NAT gateway for the VPC."
  type        = bool
  default     = false
}
