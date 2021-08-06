# Voyager-App

This component clones the voyager-app repository, builds the library and  
pushes it to the relevant repositories

You will need the following dependencies referenced in the variables:

1. A gemfury token for your squad, placed into parameter store as an encrypted string  
1. A github token for your squad, placed into parameter store as an encrypted string

Depending on the repositories, you may need the following dependencies:

1. A pypi repo (only codeartifact supported at the moment)  
1. A docker registry (tested with ECR)

#### Compatible Components

The following components have been tested with the voyager app component:

1. ECR  
2. CodeArtifact

#### Extra Vars
| Name                    | Description                                                     | Default |
|-------------------------|-----------------------------------------------------------------|---------|
| build\_docker\_image      | Whether to build the docker image                               | True    |
| build\_library           | Whether to build the library and push it to pypi                | True    |
| build\_ami               | Whether to build the ami                                        | True    |
| codeartifact\_owner      | The account id where codeartifact lives                         |         |
| voyager\_app\_git\_repo    | The repo to clone that has voyager-app code                     |         |
| voyager\_app\_git\_branch  | The reference of the voyager-app repo to use                    |         |
| gemfury\_token\_parameter | The parameter store secure string that holds your gemfury token |         |
| region                  | The AWS region to use                                           |         |

#### Requirements

No requirements.

#### Providers

No provider.

#### Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| codeartifact\_domain | The codeartifact domain of the repo | `string` | `"voyager"` |
| codeartifact\_repo | The codeartifact repo for storing the library | `string` | `"voyager"` |
| ecr\_url | The URL for ECR | `string` | `""` |
| vpc\_id | The vpc id for building the ami | `string` | `"vpc-00000000000"` |
| vpc\_subnet | The vpc subnet for building the ami | `string` | `"subnet-00000000000"` |

#### Outputs

No output.

