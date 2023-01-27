
variable "devops_aws_region" {
  type = string
  default = "us-east-1"
}

variable "devops_aws_access_key" {
  type = string
}

variable "devops_aws_secret_key" {
  type = string
}


variable "additional_tags" {
  description = "Additional global tags for all resources."
  type        = map(string)
  default     = {}
}

variable "ecr_repositories" {
  description = "The ECR repositories to create.  Each name must be unique to the AWS account."
  type = map(object({
    allowed_read_principals = list(string)
    allowed_write_principals = list(string)
  }))
}