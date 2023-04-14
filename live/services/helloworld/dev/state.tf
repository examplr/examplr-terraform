terraform {
  backend "s3" {
    bucket         = "examplr-tfstate"
    key            = "dev/ecs-helloworld.tfstate"
    region         = "us-east-1"
    dynamodb_table = "examplr-tfstate-lock"
  }
}
