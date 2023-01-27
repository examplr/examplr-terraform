
variable "name"{
  type = string
  default = null
}

variable "host_ip" {
  type    = string
}

variable "destination_cidr_block" {
  type    = string
  default = null
}

variable "vpc_id" {
  type    = string
}

variable "route_table_ids" {
  type    = list(string)
}

variable "route_table_count" {
  type    = number
}

