/*
*# CodeArtifact Component
*
*Component that creates a CodeArtifact Domain and Repo. Also can just create a single repo with an existing domain as an input
*
*
*## Example Usage
*
*```
*module "codeartifact" {
*  source = "git::git@github.com:JSainsburyPLC/voyager-terraform-modules.git//code_artifact?ref=v1.1"
*  codeartifact_domain_key_desc = var.codeartifact_domain_key_desc
*  codeartifact_create_domain = var.codeartifact_create_domain
*  codeartifact_domain_name = var.codeartifact_domain_name
*  codeartifact_repository = var.codeartifact_repository
*}
*```
*/

module "codeartifact" {
  /*
    This module creates a codeartifact domain and repository based on the below vars
  */
  source                       = "git::git@github.com:JSainsburyPLC/voyager-terraform-modules.git//codeartifact?ref=v1.1"
  codeartifact_domain_key_desc = var.codeartifact_domain_key_desc
  codeartifact_create_domain   = var.codeartifact_create_domain
  codeartifact_domain_name     = var.codeartifact_domain_name
  codeartifact_repository      = var.codeartifact_repository
}
