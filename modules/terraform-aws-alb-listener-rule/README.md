
# terraform-aws-alb-listener-rule

Attaches a target group to a named alb with the given port/path/host rules.  


### Example:

```terraform
module "dns-zone-lookup" {
  source = "./modules/terraform-aws-dns-zone-lookup"
  domain_names = ["example.com", "*.example.com", "!dev.example.com", "api.dev.example.com"]
}
```

### Inputs

| Name              | Description                                                                                                                    | Type                   |
|:------------------|:-------------------------------------------------------------------------------------------------------------------------------|:-----------------------|
| alb_name          | The domain name you want to look up the hosting Route53 zone_id for                                                            | string                 |
| port              | The port of the listener this rule should be attached to                                                                       | number                 | 
| paths             | The url path prefixes that should be routed to the target group.  Defaults to '/*' when 'paths' and 'hosts' are not provided.  | optional(list(string)) |
| hosts             | Optional. The hosts headers that must match for the request to route to the target group.                                      | optional(list(string)) |
| priority          | Optional. The order this rule will be evaulated.  Important when multiple rules could match the same request. Defaults to 100. | optional(number)       | 
| target_group_arn  | The target group that should receive matching requrests                                                                        | string                 |


### Outputs

| Name         | Description                      | Type     |
|:-------------|:---------------------------------|:---------|
| listener_arn | The ARN of the creatred listener | string   |
