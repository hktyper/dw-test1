# EMR Component

This component sets up an EMR cluster and bundles the capabilities to setup the required pre-requisites such as the S3 resources and Lambda and voyager-app parts if required. It will then provide outputs that can be re-used for other components.

## Example Usage

Note: This version of component has been tested and verified working against AMI ID ami-0bcd3e1d48f694928

The component currently supports two methods of deployment:

### Method 1 (Isolated deployment):

This method allows you to run the emr component in isolation from other components and run terraform directly against the component's resources. This requires you to plug in a tf\_vars.json file with all of the component's required variable values and a other\_vars.json which plugs in all of the backend and provider variables (See setup.sh to find out specifically what keys/vars are required). Once these are available, you can run the following steps:

```
cd emr
./setup.sh
```

### Method 2 (Terragrunt and integrated component deployment):

This method allows the EMR component to be deployed in conjunction with other components with the use of Terragrunt. This requires the use of a the deploy\_components.py found in the root of the voyager-components repo and the use of a voyager\_variables.yaml and terragrunt.hcl file. An example\_terragrount\_config.yaml file has been supplied to get you up and running with deploying EMR integrated with the other components.

Additionally if you are deploying the EMR component with S3 and Voyager App toggles enabled, you need to make sure that the pre\_deploy.sh and voyager\_bash\_functions.sh scripts exist and that a script\_vars.json file is also present with your ETL configuration.

Once these are present, you will be able to run the following steps:

```
cd ../
python deploy_components.py
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

For method 1 ensure that the following packages/dependencies are available in your pipeline:

```
Terraform
Jq
yq
```

For method 2 ensure that the following packages/dependencies are available in your pipeline (Python packages are required if deploying with deploy\_voyager\_app toggle enabled and for deploy\_components.py):

```
Terraform
Terragrunt (https://github.com/gruntwork-io/terragrunt/releases/)
Jq
yq
python3
py-pip
pyyaml
```

If deploying with the deploy-voyager-app toggle enabled, you will also need to ensure that you pass an appropriate script\_vars.json file to be picked up by the pre\_deploy.sh hook (see example\_terragrunt\_config.yaml for example of the hook and config). You will need to make sure that you populate this with the appropriate json schema configuration required to create the voyager-artefacts. Currently pre\_deploy.sh looks for keys in both the terragrunt configuration and in script\_vars.json, the terragrunt keys are as follows (Should already be declared in your configuration ):

```
.inputs.deploy_voyager_app
.inputs.project_name
.inputs.environment
.inputs.voyager_app_repo
.inputs.voyager_app_branch
.inputs.lambda_environment_variables
.inputs.regex_prefix
```

The other keys that are required in the file called script\_vars.json are as follows (The pre\_deploy.sh and functions can be modified to meet your use case):

```
.etl_config
.schema
```

## Component Requirements

The following components this module requires.

| Name | Reason | Required outputs provided |
|------|--------|---------------------------|
| vpc | To provide necessary networking setup | Yes |
| privatelink | To enable EMR to write out to Snowflake within deployed VPC | Yes |

## Known Issues:

https://github.com/JSainsburyPLC/voyager-components/issues?q=emr

## Terraform Version~~~~

Terraform version tested against and compatible.

| Name      | Version |
| --------- | ------- |
| terraform | >=0.13  |

## Terragrunt Version~~~~

Terragrunt version tested against and compatible.

| Name       | Version  |
| ---------- | -------- |
| terragrunt | >=0.26.X |

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
| applications | A list of applications for the cluster. Valid values are: Flink, Ganglia, Hadoop, HBase, HCatalog, Hive, Hue, JupyterHub, Livy, Mahout, MXNet, Oozie, Phoenix, Pig, Presto, Spark, Sqoop, TensorFlow, Tez, Zeppelin, and ZooKeeper (as of EMR 5.25.0). Case insensitive | `list(string)` | n/a |
| configurations\_json | A JSON string for supplying list of configurations for the EMR cluster. See https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-configure-apps.html for more details | `string` | `null` |
| core\_instance\_group\_ebs\_size | Core instances volume size, in gibibytes (GiB) | `number` | n/a |
| core\_instance\_group\_ebs\_type | Core instances volume type. Valid options are `gp2`, `io1`, `standard` and `st1` | `string` | `"gp2"` |
| core\_instance\_group\_ebs\_volumes\_per\_instance | The number of EBS volumes with this configuration to attach to each EC2 instance in the Core instance group | `number` | `1` |
| core\_instance\_group\_instance\_count | Target number of instances for the Core instance group. Must be at least 1 | `number` | `1` |
| core\_instance\_group\_instance\_type | EC2 instance type for all instances in the Core instance group | `string` | n/a |
| costcentre | Costcentre code, this controls who gets billed for what resources. | `string` | n/a |
| create\_task\_instance\_group | Whether to create an instance group for Task nodes. For more info: https://www.terraform.io/docs/providers/aws/r/emr_instance_group.html, https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-master-core-task-nodes.html | `bool` | `false` |
| custom\_ami\_id | A custom Amazon Linux AMI for the cluster (instead of an EMR-owned AMI). Available in Amazon EMR version 5.7.0 and later | `string` | n/a |
| deploy\_voyager\_app | Toggle whether the EMR component deploys voyager-app | `bool` | `false` |
| ebs\_root\_volume\_size | Size in GiB of the EBS root device volume of the Linux AMI that is used for each EC2 instance. Available in Amazon EMR version 4.x and later | `number` | `10` |
| email | email of the owner of the pipeline. | `string` | n/a |
| emr\_secret\_names | A list of secrets that the EMR needs access for PII data processing. | `list(string)` | `[]` |
| enable\_cloudwatch | This variable allows the EMR to access Cloudwatch logs | `bool` | `false` |
| enable\_dynamodb\_vpce | This variable allows the EMR to create VPC endpoint for DynamoDB | `bool` | `true` |
| enable\_kms\_access | This variable allows the EMR to access KMS secrets | `bool` | `false` |
| enable\_s3\_access\_log\_bucket\_creation | Toggle whether the component creates the S3 access log bucket | `bool` | `false` |
| enable\_s3\_failed\_file\_bucket\_creation | Toggle whether the component creates the S3 failed file bucket | `bool` | `false` |
| enable\_s3\_notification | Boolean value: choose if you want s3 notification or not | `bool` | `true` |
| enable\_s3\_vpce | This variable allows the EMR to create VPC endpoint for S3 | `bool` | `true` |
| environment | This is the name of the deployment environment. The options are as follows: dev, preprod, prod. | `string` | n/a |
| lambda\_environment\_variables | Environmental variables to be set within the lambda environment. | `map` | `{}` |
| lambda\_runtime | https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html | `string` | n/a |
| lambda\_s3\_key | Key of object containing Lambda deployment zip | `string` | `"lambda-emr.zip"` |
| lambda\_s3\_local | The file path to the local lambda-emr.zip file to be send to the artefacts S3 bucket. | `string` | `"lambda-emr.zip"` |
| live | Is the deployed solution live. e.g yes or no | `string` | `"no"` |
| log\_uri | The path to the Amazon S3 location where logs for this cluster are stored. Only s3n protocol is supported as opposed to s3n and s3a. | `string` | `""` |
| master\_instance\_group\_ebs\_size | Master instances volume size, in gibibytes (GiB) | `number` | n/a |
| master\_instance\_group\_ebs\_type | Master instances volume type. Valid options are `gp2`, `io1`, `standard` and `st1` | `string` | `"gp2"` |
| master\_instance\_group\_ebs\_volumes\_per\_instance | The number of EBS volumes with this configuration to attach to each EC2 instance in the Master instance group | `number` | `1` |
| master\_instance\_group\_instance\_count | Target number of instances for the Master instance group. Must be at least 1 | `number` | `1` |
| master\_instance\_group\_instance\_type | EC2 instance type for all instances in the Master instance group | `string` | n/a |
| name | Name of the application | `string` | `"voyager"` |
| owner | Owner of the pipeline. | `string` | n/a |
| private\_route\_table\_ids | The Private Route Table IDs to deploy the EMR instance into | `list(string)` | n/a |
| project\_name | Name of the project. | `string` | `"voyager"` |
| regex\_file\_name | Name of the regex map to enable the EMR to utilise the correct config file. | `string` | n/a |
| regex\_prefix | List of kafka topics for the regex prefix used in the pre\_deploy.sh hook | `list(string)` | `[]` |
| region | AWS region | `string` | `"eu-west-1"` |
| release\_label | The release label for the Amazon EMR release. https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-release-5x.html | `string` | `"emr-5.25.0"` |
| s3\_raw\_transfer\_bucket\_arn | The bucket arn for the transfer bucket | `string` | n/a |
| s3\_raw\_transfer\_bucket\_name | The bucket name for the transfer bucket | `string` | n/a |
| step\_concurrency\_level | The number of steps that can be executed concurrently. You can specify a maximum of 256 steps. Only valid for EMR clusters with release\_label 5.28.0 or greater. | `number` | `256` |
| subnet\_id | The Subnet ID to deploy the EMR instance into | `string` | n/a |
| subnet\_type | Type of VPC subnet ID where you want the job flow to launch. Supported values are `private` or `public` | `string` | `"private"` |
| visible\_to\_all\_users | Whether the job flow is visible to all IAM users of the AWS account associated with the job flow | `bool` | `true` |
| voyager\_app\_branch | What branch/version of voyager\_app to download from | `string` | `"develop_lime"` |
| voyager\_app\_repo | Git URL for the voyager-app repo for pre\_deploy.sh to clone from | `string` | `"github.com:JSainsburyPLC/voyager-app.git"` |
| voyager\_artefacts\_dir | Local path for a directory that contains the voyager artefacts created via CI/CD | `string` | `""` |
| voyager\_artefacts\_dir\_regex | A regex pattern for the voyager artefacts that should be uploaded to the artefacts bucket. | `string` | `""` |
| vpc\_cidr | The VPC CIDR range to deploy the EMR instance into | `string` | n/a |
| vpc\_id | The VPC ID to deploy the EMR instance into | `string` | n/a |

#### Outputs

| Name | Description |
|------|-------------|
| cluster\_id | EMR cluster ID |
| cluster\_name | EMR cluster name |
| ec2\_role\_arn | ARN of the EC2 role that is created |
| ec2\_role\_name | Name of the EC2 role that is created |
| emr\_cluster\_arn | Name of the EC2 role that is created |
| emr\_role\_arn | ARN of the EMR role that is created |
| emr\_role\_name | Name of the EMR role that is created |
| master\_host | Name of the cluster CNAME record for the master nodes in the parent DNS zone |
| master\_public\_dns | Master public DNS |
| master\_security\_group\_id | Master security group ID |
| slave\_security\_group\_id | Slave security group ID |
| voyager\_artefacts\_bucket\_name | Name of the artefacts bucket created |

