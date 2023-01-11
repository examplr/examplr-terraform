
# terraform-aws-ssl

Given an input of "domain_names" provision and validate (via DNS) an ACM cert.  

There were many modules available online and in the Terraform registry to automate the provisioning and validation 
of an SSL cert but none of them supported the creation of certs where the supplied subject alternatives names might
belong to different Route53 zones.  This module supports multiple zones, provided they are all in the current AWS provider
account, as well as wildcards and subdomains.

This module attempts to validate the cert via DNS validation.  That means it attempts to add the ACM DMS domain validation
records to the Route53 zone that owns the domain.  Consequently, all domain names supplied must be hosted in Route53 
public zones controlled by the current AWS provider.

The first domain name in the list is the primary name on the cert.  All additional names are subject alternative names.

### Example:

```terraform
module "ssl" {
  source = "./modules/terraform-aws-ssl"
  domain_names = ["example.com", "*.example.com", "!dev.example.com", "api.dev.example.com"]
}
```
You can use wildcards subject to the use cases supported by ACM.

See documentation on module "terraform-aws-dns-zone-lookup" in this project for information on how to 
specify subdomains and the use of the '!' prefix.


### Inputs

| Name         | Description                                | Type         |
|:-------------|:-------------------------------------------|:-------------|
| domain_names | The domain name you want on your ACM cert. | list(string) |


### Outputs

| Name         | Description                                                      | Type         |
|:-------------|:-----------------------------------------------------------------|:-------------|
| cert_arn     | The ARN of the issued cert                                       | string       |
| zone_ids     | The zone_id for the pasted in domain_name                        | list(string) |
| zone_names   | The zone_name used to look up the zone                           | list(string) |
| domain_names | The same as the input domain_names with any "!" prefixes removed | list(string) |


