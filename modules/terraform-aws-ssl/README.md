
Given an input of "domain_names" will output "cert_arn", the ARN for a validated ACM generated cert.  

All domain names supplied must be hosted in Route53 public zones controlled by the current AWS provider.

The first domain name in the list is the primary name on the cert.  All additional names are subject alternative names.

Example:

module "ssl" {
  source = "./ssl"
  domain_names = "example.com, dev.example.com, api.dev.example.com"
}

You can use wildcards subject to the use cases supported by ACM.