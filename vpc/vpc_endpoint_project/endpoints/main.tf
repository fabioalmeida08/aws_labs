resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = var.private_route_table_ids

  tags = { 
    Name = "s3-vpc-endpoint", 
    Terraform = "true",
    Environment = "dev" 
  }
}


resource "aws_ec2_instance_connect_endpoint" "example" {
  subnet_id = var.subnet_id
  security_group_ids = [var.security_group_id]
  
  tags = { 
    Name = "ec2-instance-connect-endpoint", 
    Terraform = "true",
    Environment = "dev" 
  }
}
