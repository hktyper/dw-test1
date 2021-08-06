# Snowflake PrivateLink

Module that creates VPC Endpoints and DNS configurations to allow connection to Snowflake via PrivateLink

## Example Usage

```
module "snowflake_privatelink" {
 source                     = "git::git@github.com:JSainsburyPLC/voyager-terraform-modules.git//snowflake_privatelink?ref=v1.1"
 private_subnet_ids         = module.vpc.private_subnet_ids
 account_number             = var.account_number
 region                     = var.aws_region
 vpc_id                     = module.vpc.id
 vpce_snowflake_address_id  = var.vpce_snowflake_address_id
 vpc_endpoint_ingress_cidrs = [var.vpc_cidr]
}
```

#### Requirements

No requirements.

#### Providers

No provider.

#### Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| account\_number | AWS account number | `string` | n/a |
| aws\_route53\_zone\_id | ID of the Route 53 hosted zone to contain CNAME record | `string` | `""` |
| https\_port\_number | HTTPS port number | `number` | `443` |
| https\_port\_rule\_desc | Description for the HTTPS port configuration rule | `string` | `"Required for the Snowflake HTTPS connection"` |
| https\_port\_rule\_protocol | Type of traffic protocol for the HTTPS port configuration rule | `string` | `"TCP"` |
| https\_port\_rule\_type | Type of traffic for the HTTPS port configuration rule | `string` | `"ingress"` |
| ocsp\_hostname\_prefix | ocsp record prefix for CNAME record pointing to ocsp cache server | `string` | `"ocsp"` |
| ocsp\_port\_number | Description for the OCSP port configuration rule | `number` | `80` |
| ocsp\_port\_rule\_desc | Description for the OCSP port configuration rule | `string` | `"Required for the Snowflake OCSP cache server, which listens for all Snowflake client communication on this port."` |
| ocsp\_port\_rule\_protocol | Type of traffic for the OCSP port configuration rule | `string` | `"TCP"` |
| ocsp\_port\_rule\_type | Type of traffic for the OCSP port configuration rule | `string` | `"ingress"` |
| private\_subnet\_ids | List of private subnet IDs in which the VPC Endpoint is located. | `list(string)` | n/a |
| region | AWS region | `string` | `"eu-west-1"` |
| snowflake\_account\_name | Snowflake assigned account name | `string` | `"sainsburys"` |
| snowflake\_dns\_record\_ttl | TTL for Snowflake PrivateLink DNS settings | `string` | `"300"` |
| snowflake\_dns\_record\_type | Record type for Snowflake PrivateLink DNS settings | `string` | `"CNAME"` |
| snowflake\_privatelink\_domain | Basic Snowflake PrivateLink domain | `string` | `"privatelink.snowflakecomputing.com"` |
| snowflake\_privatelink\_sg\_name | Name for the Security Group attached to the Snowflake VPC Endpoint | `string` | `"Snowflake Private Link Security Group"` |
| snowflake\_vpce\_type | VPCE type for Snowflake | `string` | `"Interface"` |
| tags | A map of tags to add | `map` | `{}` |
| vpc\_endpoint\_ingress\_cidrs | List of ingress CIDRs for the VPC Endpoint Security Group | `list(string)` | n/a |
| vpc\_id | The ID of the VPC making connections to Snowflake.  Please enable DNS hostnames and support to connect. | `string` | n/a |
| vpce\_snowflake\_address\_id | 17 character suffix of Snowflake provided VPCE address. | `string` | n/a |

#### Outputs

| Name | Description |
|------|-------------|
| hostname | n/a |
| r53\_zone\_name | n/a |
| snowflake\_privatelink\_security\_group\_id | ID of the security group for snowflake vpc endpoint |
| vpce\_address | n/a |

