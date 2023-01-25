app_region = "us-east-1"

app_name   = "examplr"
app_env    = "dev"
app_domain = "dev.examplr.co"

vpc_cidr             = "10.0.0.0/16"
vpc_public_subnets   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
vpc_private_subnets  = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
vpc_database_subnets = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]

vpn_host = "66.42.95.182"

albs = [
  {
    name        = "alb"
    dns_aliases = ["!dev.examplr.co", "*.dev.examplr.co"]

    listeners = [
      {
        port = 80 //default behavior of 80 is to forward to 443
      },
      {
        port  = 443
        cert  = ["!dev.examplr.co", "*.dev.examplr.co"]
        rules = [
          {
            service = "helloworld"
            port    = 8080
          }
        ]
      }
    ]
  }
]

ecr_account_id = "223609663012"
ecs_clusters   = ["cluster"]
ecs_services   = [
  {
    name = "helloworld"
  }
]


