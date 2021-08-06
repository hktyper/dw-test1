output "airflow_alb_dns" {
  value       = module.airflow.airflow_alb_dns
  description = "The DNS name of the ALB, with this you can access the Airflow webserver"
}

output "airflow_connection_sg" {
  value       = module.airflow.airflow_connection_sg
  description = "The security group with which you can connect other instance to Airflow, for example EMR Livy"
}

output "airflow_dns_record" {
  value       = module.airflow.airflow_dns_record
  description = "The created DNS record (only if 'use_https' = true)"
}

output "airflow_task_iam_role" {
  value       = module.airflow.airflow_task_iam_role
  description = "The IAM role of the airflow task, use this to give Airflow more permissions"
}