# Fargate\_ECS Lambda Voyager Component

This module creates a Lambda function designed to be able to kick off a Voyager ECS task.  
Note that this is just the infrastructural backbone for the Lambda - the code itself has  
to be uploaded separately in order to keep it easy to update without forcing a redeploy.

Additionally, you have the option of adding a source mapping from SQS to the Lambda  
to allow the function to be triggered by SQS events.  
Again, note that this only provides the *skeleton* to plug your own SQS infrastructure into.

#### Requirements

No requirements.

#### Providers

| Name | Version |
|------|---------|
| aws | n/a |

#### Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| costcentre | Costcentre code, this controls who gets billed for what resources | `string` | n/a |
| cw\_logs\_retention | Number of days to retain cloudwatch logs for | `number` | `7` |
| email | email of the owner of the pipeline. | `string` | n/a |
| environment | This is the name of the deployment environment. The options are as follows: dev, preprod, prod. | `string` | n/a |
| iam\_statements | IAM permissions, as a list of pairs of (Actions, Resources) objects. Each object is a list of statements | <pre>list(object({<br>    actions   = list(string)<br>    resources = list(string)<br>  }))</pre> | `[]` |
| lambda\_app\_name | A name for the Lambda function. | `string` | n/a |
| lambda\_environment\_variables | Environment variables to set for the Lambda, as key:value mappings | `map(string)` | `{}` |
| lambda\_handler | Module path to the Lambda API handler, e.g. 'package.subpackage.module.function' | `string` | n/a |
| lambda\_memory\_size | Amount of memory available to Lambda, in MB | `number` | `128` |
| lambda\_runtime | Language version to use when running the code, e.g. 'python3.8' | `string` | `"python3.8"` |
| lambda\_timeout | Time in seconds before execution times out | `number` | `600` |
| lambda\_zip\_path | Optional lambda zip file location (if omitted, an empty lambda will be deployed) | `string` | `""` |
| live | Is the deployed solution live. e.g yes or no | `string` | `"no"` |
| owner | Owner of the pipeline. | `string` | n/a |
| project\_name | Name of the project. | `string` | `"voyager"` |
| region | AWS region | `string` | `"eu-west-1"` |
| sqs\_trigger\_batch\_size | The largest number of records that Lambda will retrieve from SQS at the time of invocation | `number` | `10` |
| subnet\_ids | Subnets to place Lambda in | `list(string)` | n/a |
| trigger\_on\_sqs | If true, adds a mapping to trigger the Lambda on SQS events. | `bool` | `false` |
| trigger\_sqs\_arn | ARN of the SQS queue that will trigger the Lambda. | `string` | `false` |
| vpc\_id | An ID for the VPC used by the Lambda. | `string` | n/a |

#### Outputs

| Name | Description |
|------|-------------|
| lambda\_arn | ARN of the created Lambda function |

