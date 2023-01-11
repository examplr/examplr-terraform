env_aws_region = "us-east-1"

app_name        = "example"
app_environment = "dev"

devops_account_id = "223609663012"

ecs_clusters = ["cluster1"]

albs = [
  {
    name               = "alb1"
    alias_domain_names = ["!dev.examplr.co", "dev1.dev.examplr.co"]
    cert_domain_names  = ["!dev.examplr.co", "dev1.dev.examplr.co"]
  }
]

fargate_microservices = [
  {
    name      = "helloworld"
    alb_rules = [
      {
        port = 443
      }
    ]
  }
  # Example w/ all properties
  #  ,{
  #    name           = "helloworld"
  #    container_port = 8080
  #    host_port      = 8080
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
  #    alb_name  = "alb1"
  #    alb_rules = [
  #            {
  #              port     = 80
  #              paths    = ["/*"]
  #              hosts    = null
  #              priority = 100
  #            },
  #            {
  #              port     = 443
  #              paths    = ["/*"]
  #              hosts    = null
  #              priority = 100
  #            }
  #    ]
  #  }
]

