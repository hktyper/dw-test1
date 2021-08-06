output "id" {
  value       = module.vpc.id
  description = "The ID of the VPC"
}

output "public_subnet_cidrs" {
  value       = module.vpc.public_subnet_cidrs
  description = "List of the CIDR block for the public subnets within the VPC"
}

output "private_subnet_cidrs" {
  value       = module.vpc.private_subnet_cidrs
  description = "List of the CIDR block for the private subnets within the VPC"
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
  description = "List of the IDs for the public subnets within the VPC"
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "List of the IDs for the private subnets within the VPC"
}

output "private_route_table_ids" {
  value       = module.vpc.private_route_table_ids
  description = "List of the private routing table IDs within the VPC"
}
output "public_route_table_ids" {
  value       = module.vpc.public_route_table_ids
  description = "List of the Public routing table IDs within the VPC"
}