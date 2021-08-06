output "ecr_url" {
  description = "ECR for voyager docker images"
  value       = module.ecr.ecr_repository_url
}
