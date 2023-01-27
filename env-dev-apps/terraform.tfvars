app_region = "us-east-1"

app_name   = "examplr"
app_env    = "dev"
app_domain = "dev.examplr.co"

vpc_database_subnet_ids = [
  "subnet-0082cee5c9bcef092",
  "subnet-05718e19472aa2fe2",
  "subnet-0cd467b48c4361a32",
]
vpc_id = "vpc-030e9cd4640427e48"
vpc_private_subnet_ids = [
  "subnet-034993c692a90496f",
  "subnet-0aa5a00b8d8dd9934",
  "subnet-02a8ffa1e916abc1d",
]
vpc_public_subnet_ids = [
  "subnet-0018b72b36146ba23",
  "subnet-093aba630e649d6ad",
  "subnet-0bdc9ecef849aaa12",
]


albs = {
  "alb" = {
    dns_aliases = ["!dev.examplr.co", "*.dev.examplr.co"]
    listeners   = {
      "80" = {}
      "443" = {
        cert  = ["!dev.examplr.co", "*.dev.examplr.co"]
        rules = {
          "examplr-helloworld-api-v1" = {
            port = 8080
          }
        }
      }
    }
  }
}

ecr_account_id = "223609663012"
ecs_clusters   = ["cluster"]

ecs_services   = {
  "examplr-helloworld-api-v1" = {}
}



