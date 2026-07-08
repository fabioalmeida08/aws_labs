module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = var.instance_name
  ami  = var.amazonlinux_ami

  instance_type          = "t2.micro"
  monitoring             = false
  subnet_id              = var.subnet_id
  iam_instance_profile   = var.ec2_instance_profile
  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

