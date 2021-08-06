provider "aws" {
  region = var.region[terraform.workspace]
}

provider "aws" {
  version = "~> 3.0"
  region  = var.region[terraform.workspace]
  alias   = "dns_zones"
}