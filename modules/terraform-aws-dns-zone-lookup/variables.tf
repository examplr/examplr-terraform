
variable "domain_name" {
  description = "The domain name who's zone_id you want to lookup.  Can be a a host fqdn (host.example.com), a wildcard (*.example.com), a domain itself (example.com), or a subdomain (!subdomain.example.com). Consult README.md regarding subdomains and the '!' prefix."
  type        = string
}