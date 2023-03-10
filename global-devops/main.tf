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
  region     = var.devops_aws_region
  access_key = var.devops_aws_access_key
  secret_key = var.devops_aws_secret_key

  default_tags {
    tags = merge(
      var.additional_tags,
      {
        Terraform = "true"
      })
  }

}


