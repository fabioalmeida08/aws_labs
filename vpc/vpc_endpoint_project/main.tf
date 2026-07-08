module vpc {
  source = "./vpc"
}

module ec2 {
  source = "./ec2"
  subnet_id = module.vpc.subnet_id
  ec2_instance_profile = module.iam.instance_profile
  security_group_id = module.sg.ec2_security_group_id
}

module iam {
  source = "./iam"
  bucket_arn = module.s3.bucket_arn
}

module s3 {
  source = "./s3"
}

module sg {
  source = "./sg"
  vpc_id = module.vpc.vpc_id
}

module endpoints {
  source = "./endpoints"
  vpc_id = module.vpc.vpc_id
  security_group_id = module.sg.ec2_instance_connect_endpoint_sg_id
  subnet_id = module.vpc.subnet_id
  private_route_table_ids = module.vpc.private_route_table_ids
}

output "s3_bucket_name" {
  value = module.s3.bucket_id
}

output "ec2_instance_id" {
  value = module.ec2.ec2_instance_id
}