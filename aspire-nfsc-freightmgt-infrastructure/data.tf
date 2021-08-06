data "aws_caller_identity" "current" {}

data "aws_ami" "freightmgmt_ec2_tactical" {
  filter {
    name   = "state"
    values = ["available"]
  }
  owners = ["self"]
  filter {
    name   = "tag:Name"
    values = ["${terraform.workspace}-knn-packer-ansible-tactical"]
  }

  most_recent = true
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "example" {
  vpc_id = data.aws_vpc.default.id
}

output "subnet_first_cidr_id" {
  value = sort(data.aws_subnet_ids.example.ids)[0]
}

data "aws_subnet" "subnet1" {
  for_each = data.aws_subnet_ids.example.ids
  id       = each.value
}

data "aws_security_groups" "test" {
  filter {
    name   = "group-name"
    values = ["${terraform.workspace}-freightmgt-sg-tactical"]
  }
}
