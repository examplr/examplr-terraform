locals {
  tag_project = var.tag_project != "" ? var.tag_project : var.app_name
  tag_cost_center = var.tag_cost_center != "" ? var.tag_cost_center : var.app_name
}

terraform {
  required_version = "~> 1.3.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.49.0"
    }
  }
}

provider "aws" {
  region  = var.devops_aws_region
  access_key = var.devops_aws_access_key
  secret_key = var.devops_aws_secret_key

  default_tags {
    tags = merge(
      var.additional_tags,
      {
        App = var.app_name

        Owner = var.tag_owner
        Project = "${local.tag_project}"
        CostCenter = "${local.tag_cost_center}"

        Terraform = "true"
        TerraformRepo = var.tag_terraform_repo
      })
  }
}




