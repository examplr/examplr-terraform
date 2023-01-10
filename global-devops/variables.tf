
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

variable "app_name" {
  description = "The name of the logical 'app' that this terraform corresponds to.  This value will be used to tag and prefix or postfix many of the created resources."
  type        = string
  default = "app"
}

variable "tag_project"{
  description = "The umbrella project this app is related to.  Tagged as 'Project'. Defaults to '$${var.app_name}'."
  type = string
  default = ""
}

variable "tag_cost_center"{
  description = "The cost center responsible for the bills.  Tagged as 'CostCenter'.  Defaults to '$${var.app_name}'."
  type = string
  default = ""
}

variable "tag_owner"{
  description = "The organizational unit responsible for this infrastructure."
  type = string
  default = "devops"
}

variable "tag_terraform_repo"{
  description = "The git repo url where this terraform script is found.  Tagged as 'TerraformRepo"
  type = string
  default = "local"
}


variable "additional_tags" {
  description = "Additional global tags for all resources."
  type        = map(string)
  default     = {}
}

variable "ecr_repositories" {
  description = "The ECR repositories to create.  Each name must be unique to the AWS account."
  type = list(object({
    name = string
    allowed_read_principals = list(string)
    allowed_write_principals = list(string)
  }))

}