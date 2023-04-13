variable "cert_domain_name" {
  description = "Domain name for the ACM cert attached to the ALB. This can be a wildcard. If it does not end with a `.`, var.route53_domain_name will be appended to it."
  type        = string
}

variable "cert_sans" {
  description = "List of subject alternative names for the ACM cert attached to the ALB. These can be wildcards. If any entry does not end with a `.`, var.route53_domain_name will be appended to it."
  type        = list(string)
  default     = []
}

variable "create_dns_records" {
  description = "Determines whether or not to create Route53 records in the specified zone for the cert domain name, and all SANs. Wildcard DNS records can be created."
  type        = bool
  default     = true
}

variable "internal" {
  description = "Determines whether or not the ALB is internal or public."
  type        = bool
  default     = false
}

variable "name" {
  description = "The name of the ALB to create"
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

variable "subnet_ids" {
  description = "List of subnet IDs to deploy the ALB to."
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC to create the ALB's security group in. This should be the same VPC the subnets are in."
  type        = string
}