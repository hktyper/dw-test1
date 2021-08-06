module "airflow" {
  source                       = "datarootsio/ecs-airflow/aws"
  resource_prefix              = var.resource_prefix
  resource_suffix              = var.resource_suffix
  vpc_id                       = var.vpc_id
  private_subnet_ids           = var.private_subnet_ids
  rds_password                 = var.rds_password
  public_subnet_ids            = var.public_subnet_ids
  airflow_py_requirements_path = "./requirements.txt"
  airflow_variables = {
    AIRFLOW__WEBSERVER__NAVBAR_COLOR : "#f58220"
  }
}