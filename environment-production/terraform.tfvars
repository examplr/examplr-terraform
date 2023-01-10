app_aws_region  = "us-east-1"

app_name        = "example"
app_environment = "prod"

ecs_clusters = ["cluster1"]

albs = [
  {
    name = "alb1"
    alias_domain_names = ["!api.examplr.co"]
    cert_domain_names = ["!api.examplr.co"]
    ports = [80,443]
  }
]

fargate_microservices = [
  {
    alb_name = "alb1"
    alb_listener_port = 443
    alb_listener_rule_priority = 100
    alb_listener_rule_paths = ["/helloworld1/*"]
    alb_listener_rule_hosts = ["api.examplr.co", "*.amazonaws.com"]

    ecs_cluster_name = "cluster1"
    ecr_repository_url = "223609663012.dkr.ecr.us-east-1.amazonaws.com/helloworld"
    ecr_repository_tag = "latest"

    task_name = "helloworld"
    task_container_port = 8080
    task_host_port = 8080
    task_cpu = 1024
    task_memory = 2048
    task_autoscale_min = 1
    task_autoscale_max = 2

  }
  //-- add additional microservice definitions below
  /*
  ,{
    ...
  }
  */
]