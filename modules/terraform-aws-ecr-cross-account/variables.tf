

# The name of the ECR repository
variable "name" {
  description = "name defines the name of the repository, by default it will be interpolated to {namespace}-{name}"
}

variable "allowed_read_principals" {
  description = "allowed_read_principals defines which external principals are allowed to read from the ECR repository"
  type        = list(string)
}

variable "allowed_write_principals" {
  description = "allowed_write_principals defines which external principals are allowed to write to the ECR repository"
  type        = list(string)
  default     = []
}