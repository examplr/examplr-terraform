
variable "vpc_id" {
  type    = string
}

variable "vpn_host" {
  type    = string
}

variable "route_table_ids" {
  type    = list(string)
}

variable "route_table_count" {
  type    = number
}

variable "destination_cidr_block" {
  type    = string
}

