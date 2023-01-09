
variable "network_aws_region" {
  type = string
  default = "us-east-1"
}

variable "network_aws_access_key" {
  type = string
}

variable "network_aws_secret_key" {
  type = string
}

variable "dev_aws_region" {
  type = string
  default = "us-east-1"
}

variable "dev_aws_access_key" {
  type = string
}

variable "dev_aws_secret_key" {
  type = string
}

variable "prod_aws_region" {
  type = string
  default = "us-east-1"
}

variable "prod_aws_access_key" {
  type = string
}

variable "prod_aws_secret_key" {
  type = string
}




variable "app_name" {
  description = "The name of the logical 'app' that this terraform corresponds to.  This value will be used to tag and prefix or postfix many of the created resources."
  type        = string
  default = ""
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
