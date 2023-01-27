app_region = "us-east-1"

app_name   = "examplr"
app_env    = "dev"
app_domain = "dev.examplr.co"

vpc_cidr             = "10.0.0.0/16"
vpc_azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
vpc_public_subnets   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
vpc_private_subnets  = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
vpc_database_subnets = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]


vpns = {
  "office" = {
    host_ip = "66.42.95.182"
  }
}

