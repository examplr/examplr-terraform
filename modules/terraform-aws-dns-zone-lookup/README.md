
# terraform-aws-dns-zone-lookup

Given a "domain_name" variable, outputs the Route53 "zone_id" Route53 zone that owns the domain.  

Rules:

 1. If a passed in name starts with a "!" character, remove the "!" and take the remainder to be the zone name.  Using
    the "!" prefix, allows you to correctly resolve the subdomain zones, such as "subdomain.example.com",
    when you pass in "!subdomain.example.com" instead of it resolving to "example.com"

1.  Else, if the domain name has less than three segments (ex. example.com), then that is considered to be the zone name.
    
 1. Else, if the passed in name has three or more segments, strip off the first segment and use that as the zone name.  
    For example, "host.example.com", returns the zone id for "example.com" and "host.subdomain.example.com" returns
    the zone_id for "subdomain.example.com".


### Example:

```terraform
module "dns-zone-lookup" {
  source = "./modules/terraform-aws-dns-zone-lookup"
  domain_names = ["example.com", "*.example.com", "!dev.example.com", "api.dev.example.com"]
}
```


### Example Inputs:

| Input                        | Looked Up Zone Name   |
|:-----------------------------|:----------------------|
| example.com                  | example.com           |
| !example.com                 | example.com           |
| *.example.com                | example.com           |
| host.example.com             | example.com           |
| !subdomain.example.com       | subdomain.example.com |
| host.subdomain.example.com   | subdomain.example.com |
| *.subdomain.example.com      | subdomain.example.com |


### Inputs

| Name                       | Description                                                         | Type     |
|:---------------------------|:--------------------------------------------------------------------|:---------|
| domain_name                | The domain name you want to look up the hosting Route53 zone_id for | string   |


### Outputs

| Name        | Description                                                     | Type     |
|:------------|:----------------------------------------------------------------|:---------|
| zone_id     | The zone_id for the pasted in domain_name                       | string   |
| zone_name   | The zone_name used to look up the zone                          | string   |
| domain_name | The same as the input domain_name with any "!" prefixes removed | string   |
