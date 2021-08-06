# stage/test.txt
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = ""

    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = ""
    encrypt        = ""
    dynamodb_table = ""
  }
}

# stage/test.txt
generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = ""
}
EOF
}