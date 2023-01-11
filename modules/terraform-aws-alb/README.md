
# terraform-aws-alb

Creates an ALB in the requested VPC and subnets, adds DNS aliases and listeners on port 80 and 443 with a validated ACM cert.

The default port 80 rule is to redirect to port 443.  The default 443 rule is to return 404.

Other modules will want to add additional rules to the 80 or 443 listeners to have the ALB do anything interesting. If those
modules do not have easy access to the output alb ARN and listener ARNs, they can lookup the ALB by name and then lookup the 
listener by port.

### To Do
 - Add more outputs to be helpful to future users

### Example:

```terraform
module "alb" {
  source = "./modules/terraform-aws-alb"

  name =  "dev-myappalb-alb"
  aliases_domain_names = ["api.examplr.co", "api1.examplr.co", "api2.examplr.co"]
  cert_domain_names  =  ["api.examplr.co", "api1.examplr.co", "api2.examplr.co"]

  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  depends_on = [module.vpc]
}
```

### Inputs

| Name                 | Description                                                        | Type         |
|:---------------------|:-------------------------------------------------------------------|:-------------|
| name                 | The name of the alb, should be unique to the environment           | string       |
| alias_domain_names   | The domain names you want to point to your ALB                     | list(string) |
| cert_domains         | The domain names you want on your port 443 listener cert           | list(string  |
| vpc_id               | The VPC where the Security Groups will be placed                   | string       |
| subnets              | The subnets in the vpc to place the ALB...should be public subnets | list         |  




### Outputs

| Name               | Description                      | Type     |
|:-------------------|:---------------------------------|:---------|
| alb_arn            | The ARN of the created ALB       | string   |
| http_listener_arn  | The ARN of the port 80 listener  | string   |
| https_listener_arn | The ARN of the port 443 listener | string   |

