env_aws_region = "us-east-1"

app_name        = "example"
app_environment = "dev"

devops_account_id = "223609663012"

ecs_clusters = ["cluster1"]

albs = [
  {
    name        = "alb1"
    dns_aliases = ["dev1.dev.examplr.co"]

    listeners = [
      {
        port  = 80 //default behavior of 80 is to forward to 443
      },
      {
        port  = 443
        cert  = ["dev1.dev.examplr.co"]
        rules = [
          {
            alias = "helloworld"
            //paths = ["/*"]
            //hosts = ""
            //priority = 100

          }
        ]
      }
    ]
  }
]


ecs_services = [
  {
    name = "helloworld"
  }
  # Example w/ all properties
  #  ,{
  #    name           = "helloworld" //will be expanded to "environment-app_name-name"
  #    alias          = "helloworld" //will not be expanded, defaults to 'name' alone
  #    port           = 8080
  #    cpu            = 1024
  #    memory         = 2048
  #    autoscale_min  = 1
  #    autoscale_max  = 2
  #    log_group      = "helloworld"
  #    health_check   = "/health"
  #
  #    cluster_name   = "cluster1"
  #    repository_url = "223609663012.dkr.ecr.us-east-1.amazonaws.com/helloworld"
  #    repository_tag = "latest"
  #
  #  }
]


