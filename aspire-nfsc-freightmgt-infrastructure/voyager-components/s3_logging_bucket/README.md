# S3 Logging Bucket

This component creates a bucket. For putting logs into. When buckets were accessed.

#### Requirements

No requirements.

#### Providers

No provider.

#### Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| account\_number | The account number to use in the bucket name and policy | `string` | n/a |
| costcentre | Costcentre code, this controls who gets billed for what resources. | `string` | n/a |
| email | email of the owner of the pipeline. | `string` | n/a |
| environment | This is the name of the deployment environment. The options are as follows: dev, preprod, prod. | `string` | n/a |
| live | Is the deployed solution live. e.g yes or no | `string` | `"no"` |
| owner | Owner of the pipeline. | `string` | n/a |
| project\_name | Name of the project. | `string` | `"voyager"` |
| s3\_logging\_enforced\_acl | Canned ACL to enforce by bucket policy (https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl) | `string` | `"log-delivery-write"` |

#### Outputs

| Name | Description |
|------|-------------|
| logging\_bucket\_name | The name of the bucket for access logs |

