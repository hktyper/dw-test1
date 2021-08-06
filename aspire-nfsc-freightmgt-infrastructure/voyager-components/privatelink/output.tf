output "hostname" {
  value = module.snowflake_privatelink.hostname
}

output "vpce_address" {
  value = module.snowflake_privatelink.vpce_address
}

output "r53_zone_name" {
  value = module.snowflake_privatelink.r53_zone_name
}

output "snowflake_privatelink_security_group_id" {
  value       = module.snowflake_privatelink.snowflake_privatelink_security_group_id
  description = "ID of the security group for snowflake vpc endpoint"
}