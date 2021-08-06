/**
 * # Voyager-App
 *
 * This component clones the voyager-app repository, builds the library and
 * pushes it to the relevant repositories
 *
 * You will need the following dependencies referenced in the variables:
 *
 * 1. A gemfury token for your squad, placed into parameter store as an encrypted string
 * 1. A github token for your squad, placed into parameter store as an encrypted string
 *
 * Depending on the repositories, you may need the following dependencies:
 *
 * 1. A pypi repo (only codeartifact supported at the moment)
 * 1. A docker registry (tested with ECR)
 *
 * #### Compatible Components
 *
 * The following components have been tested with the voyager app component:
 *
 * 1. ECR
 * 2. CodeArtifact
 *
 * #### Extra Vars
 * | Name                    | Description                                                     | Default |
 * |-------------------------|-----------------------------------------------------------------|---------|
 * | build_docker_image      | Whether to build the docker image                               | True    |
 * | build_library           | Whether to build the library and push it to pypi                | True    |
 * | build_ami               | Whether to build the ami                                        | True    |
 * | codeartifact_owner      | The account id where codeartifact lives                         |         |
 * | voyager_app_git_repo    | The repo to clone that has voyager-app code                     |         |
 * | voyager_app_git_branch  | The reference of the voyager-app repo to use                    |         |
 * | gemfury_token_parameter | The parameter store secure string that holds your gemfury token |         |
 * | region                  | The AWS region to use                                           |         |
 */
