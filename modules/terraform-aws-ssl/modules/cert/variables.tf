variable "domain_names" {
  description = "The domain names to apply to the cert"
  type        = list(string)
}

variable "zone_ids_map" {
  description = "A map of the given domain_names to their zone_id"
  type        = map
}

variable "tag_name"{
  type = string
  default = ""
}

variable "tag_used_by"{
  type = string
}