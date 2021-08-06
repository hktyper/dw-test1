# CodePipeline IAM Module

Deploy IAM roles in a specific account to be assumed by CodeBuild. This will  
allow resources to be deployed into multiple accounts from a single file.

This will need to be deployed locally first as the pipeline won't have  
permissions to deploy these to other accounts.

#### Requirements

No requirements.

#### Providers

| Name | Version |
|------|---------|
| aws | n/a |

#### Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| aws\_region | The region to deploy to | `string` | `"eu-west-1"` |
| codepipeline\_account\_id | The account where codepipeline is | `string` | n/a |
| environment | The environment that the component will be deployed to | `string` | `"dev"` |
| service\_name | Name of the service | `string` | `"voyager-poc"` |
| tags | The tags to use for resources | `map(string)` | <pre>{<br>  "servicename": "voyager-poc"<br>}</pre> |

#### Outputs

| Name | Description |
|------|-------------|
| iam\_arn | n/a |

