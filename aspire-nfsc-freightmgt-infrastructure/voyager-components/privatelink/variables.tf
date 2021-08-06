variable "tags" {
  description = "A map of tags to add"
  default     = {}
}

variable "vpce_snowflake_address_id" {
  description = "17 character suffix of Snowflake provided VPCE address."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC making connections to Snowflake.  Please enable DNS hostnames and support to connect."
  type        = string
}


variable "aws_route53_zone_id" {
  description = "ID of the Route 53 hosted zone to contain CNAME record"
  type        = string
  default     = ""
}

variable "vpc_endpoint_ingress_cidrs" {
  description = "List of ingress CIDRs for the VPC Endpoint Security Group"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs in which the VPC Endpoint is located."
  type        = list(string)
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable account_number {
  description = "AWS account number"
  type        = string
}


variable snowflake_privatelink_domain {
  description = "Basic Snowflake PrivateLink domain"
  default     = "privatelink.snowflakecomputing.com"
  type        = string
}

variable snowflake_account_name {
  description = "Snowflake assigned account name"
  default     = "sainsburys"
  type        = string
}

variable ocsp_port_number {
  description = "Description for the OCSP port configuration rule"
  default     = 80
  type        = number
}

variable ocsp_port_rule_type {
  description = "Type of traffic for the OCSP port configuration rule"
  default     = "ingress"
  type        = string
}

variable ocsp_port_rule_protocol {
  description = "Type of traffic for the OCSP port configuration rule"
  default     = "TCP"
  type        = string
}

variable ocsp_port_rule_desc {
  description = "Description for the OCSP port configuration rule"
  default     = "Required for the Snowflake OCSP cache server, which listens for all Snowflake client communication on this port."
  type        = string
}

variable https_port_number {
  description = "HTTPS port number"
  default     = 443
  type        = number
}

variable https_port_rule_type {
  description = "Type of traffic for the HTTPS port configuration rule"
  default     = "ingress"
  type        = string
}

variable https_port_rule_protocol {
  description = "Type of traffic protocol for the HTTPS port configuration rule"
  default     = "TCP"
  type        = string
}

variable https_port_rule_desc {
  description = "Description for the HTTPS port configuration rule"
  default     = "Required for the Snowflake HTTPS connection"
  type        = string
}

variable snowflake_dns_record_type {
  description = "Record type for Snowflake PrivateLink DNS settings"
  default     = "CNAME"
  type        = string
}

variable snowflake_dns_record_ttl {
  description = "TTL for Snowflake PrivateLink DNS settings"
  default     = "300"
  type        = string
}

variable snowflake_vpce_type {
  description = "VPCE type for Snowflake"
  default     = "Interface"
  type        = string
}

variable ocsp_hostname_prefix {
  description = "ocsp record prefix for CNAME record pointing to ocsp cache server"
  default     = "ocsp"
  type        = string
}

variable snowflake_privatelink_sg_name {
  description = "Name for the Security Group attached to the Snowflake VPC Endpoint"
  default     = "Snowflake Private Link Security Group"
  type        = string
}

locals {
  snowflake_vpce            = "com.amazonaws.vpce.${var.region}.vpce-svc-${var.vpce_snowflake_address_id}"
  snowflake_regional_domain = "${var.region}.${var.snowflake_privatelink_domain}"
  r53_zone_name             = "${var.account_number}.${local.snowflake_regional_domain}"
  snowflake_hostname        = "${var.snowflake_account_name}.${local.snowflake_regional_domain}"
  ocsp_hostname_prefix      = "${var.ocsp_hostname_prefix}.${var.snowflake_account_name}"
}
