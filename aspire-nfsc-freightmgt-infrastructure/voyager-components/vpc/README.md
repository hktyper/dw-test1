
# VPC Component

This component sets up a VPC and will provide a set of outputs that other components can then use as inputs

## Example Usage

See examples directory for example configuration

#### Requirements

No requirements.

#### Providers

No provider.

#### Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| availability\_zones | A list of availability zones attributed to a VPC. | `list(string)` | <pre>[<br>  "eu-west-1a"<br>]</pre> |
| costcentre | Costcentre code, this controls who gets billed for what resources. | `string` | n/a |
| email | email of the owner of the pipeline. | `string` | n/a |
| enable\_nat\_gateway | n/a | `bool` | `true` |
| environment | This is the name of the deployment environment. The options are as follows: dev, preprod, prod. | `string` | n/a |
| live | Is the deployed solution live. e.g yes or no | `string` | `"no"` |
| owner | Owner of the pipeline. | `string` | n/a |
| private\_subnets | A list of CIDR ranges for your private subnets. | `list(string)` | n/a |
| project\_name | Name of the project. | `string` | `"voyager"` |
| public\_subnets | List of the CIDR block for the public subnets within the VPC | `list(string)` | `[]` |
| region | AWS region | `string` | `"eu-west-1"` |
| single\_nat\_gateway | n/a | `string` | `false` |
| subnet\_type | Type of VPC subnet ID where you want the job flow to launch. Supported values are `private` or `public` | `string` | `"private"` |
| vpc\_cidr | The CIDR block for the VPC. | `string` | n/a |
| vpc\_description | Description for a VPC. | `string` | n/a |
| vpc\_enable\_nat\_gateway | Toggle to enable a nat gateway on vpc creation | `string` | `true` |
| vpc\_flowlogs\_s3\_bucket | S3 bucket name where vpc flowlogs are written to. | `string` | `""` |
| vpc\_interface\_endpoint\_services | List of AWS-managed VPC Endpoint Interface services | `list(string)` | `[]` |
| vpc\_secondary\_cidr\_blocks | The secondary CIDR block of the VPC | `list(string)` | `[]` |

#### Outputs

| Name | Description |
|------|-------------|
| id | The ID of the VPC |
| private\_route\_table\_ids | List of the private routing table IDs within the VPC |
| private\_subnet\_cidrs | List of the CIDR block for the private subnets within the VPC |
| private\_subnet\_ids | List of the IDs for the private subnets within the VPC |
| public\_route\_table\_ids | List of the Public routing table IDs within the VPC |
| public\_subnet\_cidrs | List of the CIDR block for the public subnets within the VPC |
| public\_subnet\_ids | List of the IDs for the public subnets within the VPC |

