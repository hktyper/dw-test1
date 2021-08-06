# Voyager CLI

This python script is here to help with common Voyager functions such as
generating config and orchestrating terragrunt functionality.

This can be used both locally or in CICD. It's primary function is to take the
voyager yaml configuration, pull down any resources, generate code and execute
terragrunt across terraform modules.

## Commands

The voyager cli has a command to list all options with `--help`. The primary
commands you will use are as follows:

### voyager generate --env dev --file batch-s3

This command will clone and generate component configuration but without
running terragrunt. This will also for iterative development and debugging
without running terraform. The file referenced will be in the following path
`configuration/dev/batch-s3.yaml` relative from the current directory. File can
be omitted to generate config for everything in the environment directory.

### voyager deploy --env dev --file batch-s3 --stage plan

This command will do what `generate` does but will also run terragrunt across
all components specified. `--file` and `--stage` can be omitted, where all
components will be processed within the env directory but only a `plan` will be
executed. You need to pass `--stage apply` to explicitly apply the components
to your environments. Please note, the apply is automated and won't prompt you
for verification of the plan.

## Component Configuration Object

An explicit config object is expected per component:

```
component_name: # A name that needs to be unique
  description: "" # An arbitrary description
  component_folder: <component_folder> # REQUIRED: Which component to use by folder name
  version: <git_ref> # REQUIRED: The git ref to clone the component from
  enable: <true|false> # OPTIONAL: A field to enable or disable the component
  terraform_state: # REQUIRED
    bucket: # The bucket where the state is stored
    key: <key>/terraform.tfstate # Where to store the state. Supports terragrunt functions
    dynamodb_table: # The dynamodb_table to use for locking
  auth: # REQUIRED
    aws_profile: <local_aws_profile> # The aws profile to use when running locally. Must match the profiles in your ~/.aws/profile file
    iam_role: <iam_role_to_assume_cicd> # The role to use if deploying this component in CICD outside of the project where your CICD is running
  terragrunt_vars: # An object representing the entire terragrunt config file apart from the remote state and provider config which is auto-generated
    dependency: # The place to define terragrunt dependencies if you need to chain components together and pass through outputs to inputs
      <component_name>:
        config_path: ../<component_folder>
        mock_outputs:
          terraform_output_variable: "dummy id"
          terraform_output_list:
            - dummy
            - list
      <component_name>:
        config_path: ../<component_folder>
        skip_outputs: true
    terraform: # This is required if you need the component to run it's hooks
      before_hook:
        <hook_name>:
          commands:
            - "plan"
          execute:
            - "/bin/sh"
            - "./pre_deploy.sh"
      after_hook:
        <hook_name>:
          commands:
            - "plan"
          execute:
            - "/bin/sh"
            - "./pre_deploy.sh"
    inputs: # The inputs field of the terragrunt config, supports terragrunt interpolation syntax and functions
      terraform_variable: voyager
    extra_vars: # OPTIONAL: A list of keys that are injected into each component for use by scripts. This generates a json file at `extra_vars.json` in the component
      script_input: voyager
```
