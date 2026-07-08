module "ec2_instance_connect_endpoint_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "ec2_instance_connect_endpoint"
  description = "Security group for test with ssh enable "
  vpc_id      = var.vpc_id

  # ingress_with_cidr_blocks = [
  #   {
  #     from_port   = 22
  #     to_port     = 22
  #     protocol    = "tcp"
  #     description = "ssh port"
  #     cidr_blocks = "0.0.0.0/0"
  #   },
  # ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "all traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_ipv6_cidr_blocks = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      description      = "User-service ports (ipv6)"
      ipv6_cidr_blocks = "::/0"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "ec2_instance_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "ec2_instance"
  description = "Security group with ssh connection from ec2 instance connect endpoint sg allowed"
  vpc_id      = var.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 22
      to_port                  = 22
      protocol                 = "tcp"
      description              = "ssh"
      source_security_group_id = module.ec2_instance_connect_endpoint_sg.security_group_id
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "all traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_ipv6_cidr_blocks = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      description      = "User-service ports (ipv6)"
      ipv6_cidr_blocks = "::/0"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}