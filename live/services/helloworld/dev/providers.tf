provider "aws" {
  # Configure credentials by setting env vars recognized by the AWS credential provider chain
  # ex: AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION

  default_tags {
    tags = {
      Environment = "Development"
      ManagedBy   = "Terraform"
      Project     = "HelloWorld"
      Shared      = "true"
    }
  }
}
