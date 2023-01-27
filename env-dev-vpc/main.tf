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
  region     = var.app_region
  access_key = var.env_aws_access_key
  secret_key = var.env_aws_secret_key

  default_tags {
    tags = merge(
      var.additional_tags,
      {
        AppName   = var.app_name
        AppEnv    = var.app_env
        Terraform = "true"
      })
  }

}




