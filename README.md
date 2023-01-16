
# Purpose

This repo is designed to serve as a best practice example and starting point for quickly bootstrapping new
AWS environments via terraform and getting them to the point of usefulness for launching new web services.

In its current form, Terraform will provision everything you need to deploy multiple ECR containers
via ECS Fargate behind an ALB all with SSL certs all in a VPC with appropriate public/private zones and security groups.

When you are done, you can access urls such as:
 https://api.examplr.co/helloworld1/whatever
 https://dev.examplr.co/helloworld1/whatever
 https://dev2.dev.examplr.co/configurable_path/whatever


## Status / Versions

v0.0.4 - 2023-01-16
- Updated to use terraform registry best practice vpn module
- Added support for passing in a policy that gets attached to the ecs task in to terraform-aws-ecs-service-fargate
- Added an example policies/ecs/helloworld.json.tftpl to show how to create/attach a policy to the task. 

v0.0.3 - 2023-01-12
- I realized the module layout I had constructed created dependencies that were hard for TF to evaluate causing plans
  to modify/destroy/create WAY more than was necessary.  I restructured the modules to flatten the dependencies which 
  forced a change to the root vars.

v0.0.2 - 2023-01-11
- Refactored module layout and updated READMEs for all modules.

v0.0.1 - 2023-01-10 
- These repos/instructions have been used to successfully boostrap multiple environments/services as intended
  in this readme, but this approach, and the code, has not been code/peer reviewed by more experienced devops 
  practitioners.

## To Do
 - peer review this effort with people who know more about TF/CICD than me (Wells)
 - hook up a github action in "examplr-app-helloworld" to auto build/push/deploy new container images
 - figures out use of container stable tags vs CICD deploying a new task definition
 - setup and document github branch protection rules for both repos
 - replace the custom vpn module with the "standard" Terraform Registry VPN module 
 - add cloud watch alarms for each service
 - running an apply after changing SSL cert host names seems to change to many things...why?
 
### Known Sub Optimal Things

 - Module relative pathing - an 'init' seems to find and install relative path modules referencing '../../' but a 'plan'
   does not.  I've seem some chatter about this online as a bug, the solution appears to be to use symlinks, which I have 
   done here but it feels redundant to me.  Would prefer not to have to symlink modules for each workspace.

 - When modifying an ssl cert, the validation completes before the cert is ready in ACM and causes the apply to fail.  
   When you run apply immediately again, it works.  I've tried adding a sleep but results have been inconsistent


Several other TODOs are identified in this document below.
 

## Resource Overview

Usernames and passwords for all the accounts here are kept in the Rocket Partners 1Password "examplr" vault.

This "starter kit" involves the following pieces:
- an AWS account with multiple subaccounts
- a purchased domain name (in this case examplr.co)
- a GitHub account and these repos:
   - this repo: https://github.com/examplr/examplr-terraform
   - a simple "Hello World" app: https://github.com/examplr/examplr-app-helloworld
- a Terraform Cloud account
 
### AWS Accounts
- exampr          - master biller account
- examplr-network - hosts the root DNS zone, examplr.com and NS records pointing to environment subdomains (ex dev.examplr.com)
- examplr-devops  - hosts ECR repos that will be shared by all environments
- examplr-dev     - demo dev account
- examplr-prod    - demo prod account


### Github

#### This GitHub Terraform Repo

https://github.com/examplr/examplr-terraform 

Project Directories
1. "global-network" Creates the required child zones and NS records for each child environment in the child environment Route43 subdomain zone.
   For example "dev.examplr.co" gets created in the examplr-dev account and an NS record is put in examplr.co in the examplr-network 
   account to point to dev.examplr.co subdomain.
1. "global-devops" - Creates shared ECR repos.
1. "environment-*" - creates the remainder of the app environment, in this case ALBs connecting to ECS Fargate containers.

Each of the above directories is related to a Terraform Cloud workspace of the same name.

##### Important Branches

 - deploy/global-network
 - deploy/global-devops
 - deploy/environment-development
 - deploy/environment-production
  

   These branches have been automated in Terraform Cloud to run a plan on a PR and run an apply after a successful
   merge and plan to these branches.  Running a plan/apply on one workspace does not impact the other workspaces.

#### Hello World Repo: 

https://github.com/examplr/examplr-app-helloworld

A simple springboot app accessible as "dev.examplr.co/helloworld1" or "api.examplr.co/helloworld1". See terraform.tfvars in environment-* for specifics on the url routing rules.


### Terraform Cloud

   Each root folder in this project (other than /modules) has been setup as its own workspace in TF Cloud and connected to GitHub.
   The workspaces are setup to run plan on a pr to "release/${dir_name}" and then automatically deploy after a successful plan on a commit.


## Instructions To Replicate
1. Register a new AWS account and provision the 4 specific sub accounts.
1. Create an IAM CLI "tfuser" in each subaccount, record the API key creds.  
    - TODO: tfusers currently provisioned as admin.  What is the right role
    - TODO: should there be a single tfuser or a tfuser in each account
    - TODO: can a master "accounts" terraform provision all of the accounts and tfusers?
1. Setup a Route 53 hosted zone in "${name}-network" account and set Route 53 up with your registrar as the DNS for that domain.  An easy way to do this is to 
   procure the domain name in the ${name}-network account.  If you do that, AWS will setup Route 53 for you automatically.
1. Copy this repo to your desired location.  Don't copy the release branches, you will create those in your own repo after modifying variable values
1. Modify all terraform.tfvars files to suite your needs.  Pay specific attention to the account ids in environment-*/tfvariables that must reference the AWS Account ID for your provisioned ${name}-network account.
1. Commit to main.
1. Create all of your release branches as above.
1. Create a Terraform Cloud account
1. Create TF Cloud workspace for each folder in this project other than "modules".
   - Configure each workspace to have a "working directory" that matches each folder name (we only run that folder's tf code in that workspace)
   - Configure each workspace to pull from the above specified release branch matching your workspace name
   - Configure each workspace to auto deploy
   - Configure each worksapces variables w/ the tfuser AWS creds for that account
   - Run a plan/deploy for each worksapce.  The first time, order is important.
     1. Fist - "global-network"
     2. Second - "global-devos"
     3. Then - "environment-*" in any order 
1. Build and publish the "Hello World" container to ECR.
1. Wait for our service to deploy your new container. Check the deployments, tasks, and alb target group members.
1. Point your browser to your configured endpoints and enjoy.


## Cheat Sheet

### Docker Image Publishing

... and force a service update after publishing so the new image gets deployed
```
gradle build
docker build -t 223609663012.dkr.ecr.us-east-1.amazonaws.com/helloworld:latest .

//tfuser@examplr-devops account
export AWS_ACCESS_KEY_ID=[REPLACE WITH tfuser@examplr-devops accessKey]
export AWS_SECRET_ACCESS_KEY=[REPLACE WITH tfuser@examplr-devops secretKey]

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 223609663012.dkr.ecr.us-east-1.amazonaws.com/helloworld:latest

docker push 223609663012.dkr.ecr.us-east-1.amazonaws.com/helloworld:latest
aws ecs update-service --cluster dev-lift-test1 --service dev-helloworld --force-new-deployment
```

### Best Practices For Scaling Out
 - Have all of your services use a different port...and maybe a different container port. This
   way, you can run all of your services locally during development 

### Lessons Learned
 - Your module dependencies need to be as flat as possible or TF may get confused and plan to modify or create/destroy things it does not need to

## Research Links


### Multi AWS Account Setup
- https://thenewstack.io/terraform-on-aws-multi-account-setup-and-other-advanced-tips/
- https://jhooq.com/terraform-aws-multi-account/

### Terraforming Fargate - Very Helpful
 - https://dev.to/thnery/create-an-aws-ecs-cluster-using-terraform-g80
   - https://github.com/thnery/terraform-aws-template
 - https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master/examples/complete-vpc
 - https://section411.com/2019/07/hello-world/
 - https://itnext.io/creating-an-ecs-fargate-service-for-container-applications-using-terraform-and-terragrunt-2af5db3b35c0
 - https://www.architect.io/blog/2021-03-30/create-and-manage-an-aws-ecs-cluster-with-terraform/


### Terraforming Fargate - Also Helpful
 - https://www.wbotelhos.com/aws-ecs-with-terraform
 - https://hands-on.cloud/managing-amazon-ecs-using-terraform/
 - https://aws.plainenglish.io/creating-an-ecs-cluster-with-terraform-edf6fd3b822
 - https://www.architect.io/blog/2021-03-30/create-and-manage-an-aws-ecs-cluster-with-terraform/
 - https://alexhladun.medium.com/create-a-vpc-endpoint-for-ecr-with-terraform-and-save-nat-gateway-1bc254c1f42
 - https://engineering.finleap.com/posts/2020-02-20-ecs-fargate-terraform/
 - https://github.com/npalm/terraform-aws-ecs-service
 - https://registry.terraform.io/modules/cn-terraform/ecs-fargate/aws/latest
 - https://cadu.dev/easy-deploy-your-docker-applications-to-aws-using-ecs-and-fargate/
 - https://github.com/zambien/terraform-ecs-iam-example

### ECR Image Tagging
 - https://blog.scottlowe.org/2017/11/08/how-tag-docker-images-git-commit-information/
 - https://axellarsson.com/blog/tag-docker-image-with-git-commit-hash/

### CERT Validation w/ Multiple Zones
 - https://manicminer.io/posts/terraform-aws-acm-certificates-for-multiple-domains/
 - https://github.com/manicminer/terraform-aws-acm-certificate
 - https://stackoverflow.com/questions/63235321/aws-acm-certificate-seems-to-have-changed-its-state-output-possibly-due-to-a-pro
 - https://stackoverflow.com/questions/62579564/how-to-create-a-map-in-terraform


### Terraform Resource Tagging
 - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/resource-tagging
 - https://docs.aws.amazon.com/whitepapers/latest/tagging-best-practices/tagging-best-practices.html
 - https://engineering.deptagency.com/best-practices-for-terraform-aws-tags

### Terraform Multi vs Monorepo
 - https://www.google.com/search?q=terraform+monorepo&rlz=1C5CHFA_enUS907US907&oq=terraform+monore&aqs=chrome.0.0i512j69i57j0i512l2j0i22i30l2.2148j0j4&sourceid=chrome&ie=UTF-8#fpstate=ive&vld=cid:f3ddbe77,vid:4Rlwh4YVLRY
 - https://www.hashicorp.com/blog/terraform-mono-repo-vs-multi-repo-the-great-debate


### Other Reading
 - https://www.terraform-best-practices.com/naming
 - https://medium.com/react-courses/quick-ci-cd-from-github-to-prod-with-aws-ecr-ecs-creating-a-serverless-docker-container-698d360ee21e
   - manaul config of ecr/ecs and task definitions
 - https://particule.io/en/blog/cicd-ecr-ecs/
   - github/terraform/cicd example using tags
 - https://stevelasker.blog/2018/03/01/docker-tagging-best-practices-for-tagging-and-versioning-docker-images/ 
   - container tagging best practices
 - https://medium.com/jp-tech/docker-image-tagging-strategy-for-deploying-to-production-d2b90c115691
 - https://container-registry.com/posts/container-image-versioning/
 - https://www.reddit.com/r/Terraform/comments/xoumxf/deploying_ecs_tasks_what_is_the_right_way/

### ALB Cloudwatch Alarms
 - https://github.com/lorenzoaiello/terraform-aws-alb-alarms


### Terragrunt
 - https://medium.com/@man-wai/why-use-terragrunt-in-2022-5e97c61cc539

### Terraform CICD Interference
 - https://www.google.com/search?q=aws_ecs_task_definition+ignore_changes
 - Has a reasonable solution - https://github.com/hashicorp/terraform-provider-aws/issues/632
 - https://github.com/hashicorp/terraform-provider-aws/issues/258
 - https://github.com/hashicorp/terraform/issues/13005
 - https://www.reddit.com/r/aws/comments/nlco6r/terraform_and_ecs_dont_change_task_revision/
 - https://www.reddit.com/r/devops/comments/fleac9/create_aws_ecs_task_definition_and_service_in/

### Adding Multiple SSL Certs to an ALB Listener
 - https://stackoverflow.com/questions/66268417/how-do-i-add-a-list-of-ssl-certificates-to-a-list-of-of-alb-listeners-i-have-cre
 
### CodeDeploy 
 - https://medium.com/@jaclynejimenez/what-i-learned-using-aws-ecs-fargate-blue-green-deployment-with-codedeploy-65dde6781fcc

### VPC CIDR Block Planning
- https://www.linkedin.com/pulse/aws-vpc-best-practice-journal-eric-l/

### Interesting Tools Discovered
 - https://github.com/fabfuel/ecs-deploy

### Github Actions & Environments
 - Deployment Manual Approval
   - https://docs.github.com/en/actions/managing-workflow-runs/reviewing-deployments
   - https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment
   - https://cloudlumberjack.com/posts/github-actions-approvals/
   - https://docs.github.com/en/actions/deployment/managing-your-deployments/viewing-deployment-history