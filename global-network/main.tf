
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
  region  = var.network_aws_region
  access_key = var.network_aws_access_key
  secret_key = var.network_aws_secret_key

  default_tags {
    tags = merge(
      var.additional_tags,
      {
        Terraform = "true"
        TerraformRepo = var.tag_terraform_repo
      })
  }
}

provider "aws" {
  region  = var.dev_aws_region
  access_key = var.dev_aws_access_key
  secret_key = var.dev_aws_secret_key
  alias = "dev"

  default_tags {
    tags = merge(
      var.additional_tags,
      {
        Terraform = "true"
        TerraformRepo = var.tag_terraform_repo
      })
  }
}

provider "aws" {
  region  = var.prod_aws_region
  access_key = var.prod_aws_access_key
  secret_key = var.prod_aws_secret_key
  alias = "prod"

  default_tags {
    tags = merge(
      var.additional_tags,
      {
        Terraform = "true"
        TerraformRepo = var.tag_terraform_repo
      })
  }
}


