module "freightmgt_ec2_tactical" {
  source      = "git@github.com:JSainsburyPLC/aspire-common-terraform-modules.git//modules/ec2?ref=master"
  namespace   = var.project
  environment = terraform.workspace
  stack       = "freightmgmt"
  name        = "ec2-tactical"
  ami         = data.aws_ami.freightmgmt_ec2_tactical.id

  subnet_id = sort(data.aws_subnet_ids.example.ids)[0]

  vpc_security_group_ids = ["${sort(data.aws_security_groups.test.ids)[0]}"]

  iam_instance_profile_role_name = "${terraform.workspace}-freightmgt-ec2-role-tactical"
  key_name                       = "${terraform.workspace}-freightmgt-keypair-tactical"

  associate_public_ip_address = true

  instance_type    = local.size
  ebs_volume_count = 1
  ebs_volume_size  = "8"
  ebs_volume_type  = "standard"

  tags = local.common_tags
}