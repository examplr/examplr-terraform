variable "domain_names" {
  description = "List of domains names to associate with the new certificate. The first name supplied will be the primary cert name.  All additional names will be subject alternative names."
  type = list(string)
}

variable "tag_name"{
  type = string
  default = ""
}

variable "tag_used_by"{
  type = string
}