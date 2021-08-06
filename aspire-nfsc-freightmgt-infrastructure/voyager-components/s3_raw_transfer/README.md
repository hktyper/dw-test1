# S3 Raw Transfer

This component creates an S3 bucket which will contain raw data from data source.

### Running via CircleCI

For development purpose, you can run the component via CircleCI.  
You need to create a voyager\_variables.yaml file and pass it to the deploy\_components.py.

#### Requirements

No requirements.

#### Providers

| Name | Version |
|------|---------|
| aws | n/a |

#### Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| access\_logs\_bucket | The name of the log bucket to place logs into | `string` | n/a |
| account\_number | The AWS Account Number of this bucket | `string` | n/a |
| costcentre | The PD code for costing which the resource is allocated to | `string` | `""` |
| data\_classification | To determine how the data held or flowing through a resource should be treated | `string` | `""` |
| data\_retention | To determine how long data should be retained within a particular datastore | `string` | `""` |
| email | The email address of the owner of the resource, usually PO | `string` | `""` |
| enable\_notification | If true, an SNS notification will be created and will be linked to the created S3 to trigger event notification | `bool` | `false` |
| enable\_snowflake\_stage | Flag to determine whether to create Snowflake Stage IAM policies | `bool` | `false` |
| environment | This is the name of the deployment environment. The options are as follows: dev, preprod, prod. | `string` | n/a |
| live | Non-production resources should always have the live tag set to no. Production resources should have the live tag set to no before they go live, but after they go live it should be set to yes. | `string` | `"No"` |
| name | Name of the application | `string` | `"voyager"` |
| owner | Owner of the pipeline. | `string` | n/a |
| project\_name | Name of the project. | `string` | `"voyager"` |
| region | AWS region | `string` | `"eu-west-1"` |
| service\_catalogue\_id | Way of identifying application resources by the recognised reference number held in ServiceNow and MEGA | `string` | `""` |
| service\_name | Way of identifying application resources in Non-Prod prior to issue of Service Catalogue ID for production resources. | `string` | `""` |
| subrecv\_arn\_list | If there is any cross-account subscription, provide principle arn. | `list(any)` | `[]` |
| tags | The tags to use for the resources | `map(string)` | `{}` |

#### Outputs

| Name | Description |
|------|-------------|
| raw\_transfer\_bucket\_arn | ARN of the raw transfer bucket |
| raw\_transfer\_bucket\_name | Name of the raw transfer bucket. |
| sns\_topic\_arn | n/a |

