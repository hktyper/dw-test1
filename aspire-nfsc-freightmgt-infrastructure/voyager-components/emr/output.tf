output "cluster_id" {
  value       = module.batch_lambda_emr_cluster.cluster_id
  description = "EMR cluster ID"
}

output "cluster_name" {
  value       = module.batch_lambda_emr_cluster.cluster_name
  description = "EMR cluster name"
}

output "master_public_dns" {
  value       = module.batch_lambda_emr_cluster.master_public_dns
  description = "Master public DNS"
}

output "master_security_group_id" {
  value       = module.batch_lambda_emr_cluster.master_security_group_id
  description = "Master security group ID"
}

output "slave_security_group_id" {
  value       = module.batch_lambda_emr_cluster.slave_security_group_id
  description = "Slave security group ID"
}

output "master_host" {
  value       = module.batch_lambda_emr_cluster.master_host
  description = "Name of the cluster CNAME record for the master nodes in the parent DNS zone"
}

output "emr_role_arn" {
  value       = module.batch_lambda_emr_cluster.emr_role_arn
  description = "ARN of the EMR role that is created"
}

output "ec2_role_arn" {
  value       = module.batch_lambda_emr_cluster.ec2_role_arn
  description = "ARN of the EC2 role that is created"
}

output "emr_role_name" {
  value       = module.batch_lambda_emr_cluster.emr_role_name
  description = "Name of the EMR role that is created"
}

output "ec2_role_name" {
  value       = module.batch_lambda_emr_cluster.ec2_role_name
  description = "Name of the EC2 role that is created"
}

output "emr_cluster_arn" {
  value       = module.batch_lambda_emr_cluster.emr_cluster_arn
  description = "Name of the EC2 role that is created"
}

output "voyager_artefacts_bucket_name" {
  value       = module.batch_lambda_emr_cluster.voyager_artefacts_bucket_name
  description = "Name of the artefacts bucket created"
}