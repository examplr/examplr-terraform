output "registry_id" {
  value       = aws_ecr_repository.this.registry_id
  description = "Registry ID"
}

output "repository_arn" {
  value       = aws_ecr_repository.this.arn
  description = "Repository ARN"
}

output "repository_name" {
  value       = aws_ecr_repository.this.name
  description = "Repository name"
}

output "repository_url" {
  value       = aws_ecr_repository.this.repository_url
  description = "Registry URL"
}
