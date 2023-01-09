
#Overview

## AWS Accounts
 - exampr - master biller account
 - examplr-network - hosts the root DNS zone, examplr.com and creates child hosted zones (ex dev.examplr.com) for each app environment
 - examplr-dev - hosts ECR repos that will be shared by all app environments, and any app environments you want to deploy
 - examplr-prod - demo prod account designed to hold
 
## Terraform Directories
 1."network" run this first to create the required DNS master zone and child zones for each child app environment in the child environment account
 1. "dev" - run next to create shared ecr repos in examplr-dev aws account
 1. "app" - create a terraform workspace for each app environment you would like to deploy.

## Github
 1. https://github.com/examplr/examplr-terraform - this terraform project
 1. https://github.com/examplr/examplr-app-helloworld - a simple springboot app accessable as "helloworld.dev.examplr.co"


# Getting Started

 1. Install terraform CLI
 1. Checkout this repo

```
cd network
terraform init
terraform apply

cd ../dev
terraform init 
terraform apply

cd ../app

export export TF_VAR_app_aws_region=us-east-1
export export TF_VAR_app_aws_access_key={REPLACE_WITH tfuser@examplr-dev creds}
export export TF_VAR_app_aws_secret_key={REPLACE_WITH tfuser@examplr-dev creds}

terraform workspace new dev
terraform workspace select dev
terraform init
terraform plan -var-file environments/dev/dev.tfvars
terraform apply -var-file environments/dev/dev.tfvars


xport export TF_VAR_app_aws_region=us-east-1
export export TF_VAR_app_aws_access_key={REPLACE_WITH tfuser@examplr-prod creds}
export export TF_VAR_app_aws_secret_key={REPLACE_WITH tfuser@examplr-prod creds}

terraform workspace new prod
terraform workspace select prod
terraform init
terraform plan -var-file environments/prod/prod.tfvars
terraform apply -var-file environments/prod/prod.tfvars

```

##Terraform Cloud
wellsb1 / wells+examplr@rocketpartners.io




# Research

https://www.terraform-best-practices.com/naming

## Very Helpful
 - https://dev.to/thnery/create-an-aws-ecs-cluster-using-terraform-g80
   - https://github.com/thnery/terraform-aws-template
 - https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master/examples/complete-vpc

https://section411.com/2019/07/hello-world/
https://itnext.io/creating-an-ecs-fargate-service-for-container-applications-using-terraform-and-terragrunt-2af5db3b35c0
https://www.architect.io/blog/2021-03-30/create-and-manage-an-aws-ecs-cluster-with-terraform/

## Additional
 - https://www.wbotelhos.com/aws-ecs-with-terraform
 - https://hands-on.cloud/managing-amazon-ecs-using-terraform/
 - https://aws.plainenglish.io/creating-an-ecs-cluster-with-terraform-edf6fd3b822
 - https://www.architect.io/blog/2021-03-30/create-and-manage-an-aws-ecs-cluster-with-terraform/
 - https://alexhladun.medium.com/create-a-vpc-endpoint-for-ecr-with-terraform-and-save-nat-gateway-1bc254c1f42

 - https://engineering.finleap.com/posts/2020-02-20-ecs-fargate-terraform/


## ECR Tagging
 - https://blog.scottlowe.org/2017/11/08/how-tag-docker-images-git-commit-information/
 - https://axellarsson.com/blog/tag-docker-image-with-git-commit-hash/


## CERT Validation w/ Multiple Zones
https://manicminer.io/posts/terraform-aws-acm-certificates-for-multiple-domains/
https://github.com/manicminer/terraform-aws-acm-certificate
https://stackoverflow.com/questions/63235321/aws-acm-certificate-seems-to-have-changed-its-state-output-possibly-due-to-a-pro
https://stackoverflow.com/questions/62579564/how-to-create-a-map-in-terraform



## Resource Tagging
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/resource-tagging
https://docs.aws.amazon.com/whitepapers/latest/tagging-best-practices/tagging-best-practices.html
https://engineering.deptagency.com/best-practices-for-terraform-aws-tags

### Multi vs Monorepo
- https://www.google.com/search?q=terraform+monorepo&rlz=1C5CHFA_enUS907US907&oq=terraform+monore&aqs=chrome.0.0i512j69i57j0i512l2j0i22i30l2.2148j0j4&sourceid=chrome&ie=UTF-8#fpstate=ive&vld=cid:f3ddbe77,vid:4Rlwh4YVLRY
- https://www.hashicorp.com/blog/terraform-mono-repo-vs-multi-repo-the-great-debate


## Other Reading
https://medium.com/react-courses/quick-ci-cd-from-github-to-prod-with-aws-ecr-ecs-creating-a-serverless-docker-container-698d360ee21e
 - manaul config of ecr/ecs and task definitions

https://particule.io/en/blog/cicd-ecr-ecs/
 - github/terraform/cicd example using tags

https://stevelasker.blog/2018/03/01/docker-tagging-best-practices-for-tagging-and-versioning-docker-images/ 
 - container tagging best practices

https://medium.com/jp-tech/docker-image-tagging-strategy-for-deploying-to-production-d2b90c115691

https://container-registry.com/posts/container-image-versioning/

https://www.reddit.com/r/Terraform/comments/xoumxf/deploying_ecs_tasks_what_is_the_right_way/

## ALB Cloudwatch Alarms
https://github.com/lorenzoaiello/terraform-aws-alb-alarms


## Terragrunt
https://medium.com/@man-wai/why-use-terragrunt-in-2022-5e97c61cc539

## Multi Account Setup
https://thenewstack.io/terraform-on-aws-multi-account-setup-and-other-advanced-tips/
https://jhooq.com/terraform-aws-multi-account/


## Docker Image Publishing

```

```
need to run in terraform-sandbox, not terraform-sandbox-devops

Force a cluster update after publishing a new container
```
gradle build
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 937423686755.dkr.ecr.us-east-1.amazonaws.com/helloworld:latest
docker build -t 937423686755.dkr.ecr.us-east-1.amazonaws.com/helloworld:latest .
docker push 937423686755.dkr.ecr.us-east-1.amazonaws.com/helloworld:latest
aws ecs update-service --cluster dev-lift-test1 --service dev-helloworld --force-new-deployment

```
docker run -p 8080:8080 937423686755.dkr.ecr.us-east-1.amazonaws.com/helloworld