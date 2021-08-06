# CodePipeline Terraform Module

This module creates the resources for create a CodeBuild/CodePipeline setup  
for voyager.

This needs to be run as part of the bootstrap process for the first time so  
that the pipeline can be created and used for any subsequent runs. Following  
that initial deployment, you can use this module to update your Pipeline.

Some manual steps are required for deployment:

1. Add a private ssh key to a parameter store secure string and set it in your buildspec  
2. Add a github token to a parameter store secure string and set it in a var  
3. Add your change api key to parameter store and set the name as part of the buildspec  
4. Setup a codestar connection in the project where codepipeline will run and pass it as tfvar  
5. If using this component for pull requests, you will need to authenticate  
the pull request code build job manually against Github so it can clone the  
repo

#### Extra Vars

| Name                 | Description                                  | Default   |
| -------------------- | -------------------------------------------- | --------- |
| build\_docker\_image   | Boolean on whether to build a docker image   | True      |

#### Requirements

No requirements.

#### Providers

| Name | Version |
|------|---------|
| aws | n/a |

#### Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| account\_number | AWS account number | `string` | n/a |
| application\_source\_branch | Branch of repository containing source code | `string` | `"integrate-change-api"` |
| approval\_enable | Enable wait for manual approval before the Deploy stage | `bool` | `false` |
| assignment\_group | Name of the assignment group in service now | `string` | n/a |
| aws\_region | The region to deploy to | `string` | `"eu-west-1"` |
| build\_enable | Feature switch for build job | `bool` | `true` |
| build\_job\_env\_variables | Build job variables to be passed into job | <pre>list(object({<br>    name  = string<br>    value = string<br>    type  = string<br>  }))</pre> | `[]` |
| build\_job\_privileged\_mode | Start docker daemon in job | `bool` | `false` |
| change\_api\_key | Name of the parameter store item that holds the change api key | `string` | n/a |
| code\_analysis\_terraform\_enable | If set to true, enable running on terraform code analysis in all branches | `bool` | `false` |
| codestar\_connection\_arn | The ARN of the github codestar connection | `string` | n/a |
| cross\_account\_roles | ARNS of Roles that will be assumed from other AWS accounts | `list(string)` | `[]` |
| deploy\_enable | Feature switch for deploy job | `bool` | `true` |
| deploy\_job\_env\_variables | Deploy job variables to be passed into job | <pre>list(object({<br>    name  = string<br>    value = string<br>    type  = string<br>  }))</pre> | `[]` |
| deploy\_job\_privileged\_mode | Start docker daemon in job | `bool` | `true` |
| deployment\_item | Name of the deployment item in service now | `string` | n/a |
| docker\_image | The docker image to use for build, test and deploy stages | `string` | `"aws/codebuild/amazonlinux2-x86_64-standard:2.0"` |
| ecr\_url | The ECR url for the docker image to build | `string` | n/a |
| environment | The environment that the component will be deployed to | `string` | `"dev"` |
| git\_clone\_depth | Git Clone depth for CodeBuild projects. Set to 0 for full clone. | `number` | `1` |
| git\_submodules | If set to true, fetches Git submodules for the AWS CodeBuild build project. Requires HTTPS submodule URL | `bool` | `false` |
| github\_token | Name of the parameter store item that holds the github token | `string` | n/a |
| initialise\_job\_env\_variables | Initialise job variables to be passed into job | <pre>list(object({<br>    name  = string<br>    value = string<br>    type  = string<br>  }))</pre> | `[]` |
| post\_deploy\_enable | Feature switch for post deploy job | `bool` | `true` |
| post\_deploy\_job\_env\_variables | Post deploy job variables to be passed into job | <pre>list(object({<br>    name  = string<br>    value = string<br>    type  = string<br>  }))</pre> | `[]` |
| post\_deploy\_job\_privileged\_mode | Start docker daemon in job | `bool` | `false` |
| pull\_request\_enable | If set to true, enable running on Pull Requests | `bool` | `false` |
| pull\_request\_run\_test\_enable | If set to true, enable running the test job on Pull Requests | `bool` | `false` |
| repo\_name | Name of the service | `string` | `"voyager"` |
| request\_change\_enable | Feature switch the Change API for non production deploys | `bool` | `false` |
| service\_name | Name of the service | `string` | `"voyager-poc"` |
| tags | The tags to use for resources | `map(string)` | <pre>{<br>  "servicename": "voyager-poc"<br>}</pre> |
| test\_enable | Feature switch for test job | `bool` | `true` |
| test\_job\_env\_variables | Test job variables to be passed into job | <pre>list(object({<br>    name  = string<br>    value = string<br>    type  = string<br>  }))</pre> | `[]` |

#### Outputs

No output.

