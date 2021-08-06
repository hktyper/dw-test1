output "codeartifact_domain_id" {
  value = module.codeartifact.codeartifact_domain_id
}

output "codeartifact_domain_arn" {
  value = module.codeartifact.codeartifact_domain_arn
}

output "codeartifact_repository_id" {
  value = module.codeartifact.codeartifact_repository_id
}

output "codeartifact_repository_arn" {
  value = module.codeartifact.codeartifact_repository_arn
}

output "codeartifact_domain_name" {
  value = var.codeartifact_domain_name
}

output "codeartifact_repository_name" {
  value = var.codeartifact_repository
}
