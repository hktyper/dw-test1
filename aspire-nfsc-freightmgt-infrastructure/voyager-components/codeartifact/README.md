\*# CodeArtifact Component

\*Component that creates a CodeArtifact Domain and Repo. Also can just create a single repo with an existing domain as an input

\*## Example Usage

\*```
*module "codeartifact" {
 source = "git::git@github.com:JSainsburyPLC/voyager-terraform-modules.git//code_artifact?ref=v1.1"
 codeartifact_domain_key_desc = var.codeartifact_domain_key_desc
 codeartifact_create_domain = var.codeartifact_create_domain
 codeartifact_domain_name = var.codeartifact_domain_name
 codeartifact_repository = var.codeartifact_repository
*}
*
```

#### Requirements

No requirements.

#### Providers

No provider.

#### Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| codeartifact\_create\_domain | Toggle whether to create a domain resource or not | `string` | `true` |
| codeartifact\_domain | The codeartifact domain resource to use, defaults to using the resource created by this module | `string` | `""` |
| codeartifact\_domain\_key\_desc | Description for the KMS key created for the domain | `string` | `"Domain Key for CodeArtifact Module Domain"` |
| codeartifact\_domain\_name | The codeartifact domain name to create | `string` | `"defaultcodeartifactdomain"` |
| codeartifact\_repository | The codeartifact repository name to create | `string` | n/a |
| region | AWS region | `string` | `"eu-west-1"` |

#### Outputs

| Name | Description |
|------|-------------|
| codeartifact\_domain\_arn | n/a |
| codeartifact\_domain\_id | n/a |
| codeartifact\_domain\_name | n/a |
| codeartifact\_repository\_arn | n/a |
| codeartifact\_repository\_id | n/a |
| codeartifact\_repository\_name | n/a |

