# ECR Terraform Component

This component creates an ECR resource to push a docker image too

#### Requirements

No requirements.

#### Providers

No provider.

#### Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| environment | The environment that this component is deployed to | `string` | `"dev"` |
| project\_name | Project name for this deployment | `string` | n/a |
| service\_name | Name of the service | `string` | `"voyager-poc"` |
| tags | The tags to use for the resources | `map(string)` | <pre>{<br>  "servicename": "voyager-poc"<br>}</pre> |

#### Outputs

| Name | Description |
|------|-------------|
| ecr\_url | ECR for voyager docker images |

