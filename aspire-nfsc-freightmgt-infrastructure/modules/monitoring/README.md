## Providers

| Name | Version |
|------|---------|
| local | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| environment | The environment the stack is going to be deployed in e.g. dev/preprod/prod | `string` | n/a | yes |
| log\_group | Log group for the ECS cluster | `string` | n/a | yes |
| service\_name | Name of the service being monitored | `string` | n/a | yes |
| tables | List of tables to monitor | `list(string)` | n/a | yes |
| table\_config | A mapping of the configuration for the tables, whereby the keys are name of the table and the values are a mapping which includes row_threshold as a key | `map(map(string))` | n/a | yes |
| namespace |The namespace for the alarm's associated metric | `string` | n/a | yes |
| tags | Default project tags. | `map(string)` | `{}` | no |

## Outputs

No output.

