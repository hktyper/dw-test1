# S3 File Notifications Pipeline Components

This component creates the infrastructure for an event processing pipeline from  
S3 Bucket Event -> SNS Topic Notification -> SQS queue + dead-letter queue.

The queue can then be wired up as an event source for a Lambda function;  
however, you will need to pass in the ARN of the SQS queue to the Lambda  
component yourself, separately.

#### Requirements

No requirements.

#### Providers

| Name | Version |
|------|---------|
| aws | n/a |

#### Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| costcentre | Cost-centre code - controls who gets billed for what resources. | `string` | n/a |
| email | email of the owner of the pipeline. | `string` | n/a |
| environment | Name of the deployment environment. The options are: dev, preprod, prod | `string` | n/a |
| live | Is the deployed solution live. e.g yes or no | `string` | `"no"` |
| region | The region to deploy to | `string` | `"eu-west-1"` |
| sns\_filter\_policy | A JSON definition for routing events to different SNS subscribers. See: https://docs.aws.amazon.com/sns/latest/dg/sns-message-filtering.html | `string` | `""` |
| sns\_source\_topic\_arns | n/a | `list(string)` | `[]` |
| sqs\_delay\_seconds | See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue#delay_seconds | `number` | `0` |
| sqs\_max\_message\_size | See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue#max_message_size | `number` | `262144` |
| sqs\_max\_receive\_count | Maximum number of times a message may be received from SQS without being deleted before it's moved to the dead letter queue | `number` | `5` |
| sqs\_message\_retention\_seconds | See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue#message_retention_seconds | `number` | `1209600` |
| sqs\_name | Name of the SQS queue handling the file notifications. | `string` | n/a |
| sqs\_raw\_message\_delivery | See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription#raw_message_delivery | `string` | `"true"` |
| sqs\_receive\_wait\_time\_seconds | See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue#receive_wait_time_seconds | `number` | `10` |
| sqs\_timeout\_seconds | The visibility timeout for the queue. An integer from 0 to 43200 (12 hours) | `number` | `30` |

#### Outputs

| Name | Description |
|------|-------------|
| deadletter\_arn | ARN of the created SQS dead letter queue |
| sqs\_arn | ARN of the created SQS queue |

