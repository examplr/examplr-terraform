
output "repository_arn" {
  value       = module.ecr-cross-account[*].repository_arn
  description = "Repository ARN"
}

output "repository_name" {
  value       = module.ecr-cross-account[*].repository_name
  description = "Repository name"
}

output "registry_id" {
  value       = module.ecr-cross-account[*].registry_id
  description = "Registry ID"
}

output "repository_url" {
  value       = module.ecr-cross-account[*].repository_url
  description = "Registry URL"
}
