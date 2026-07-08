output "ec2_instance_connect_endpoint_sg_id" {
  value = module.ec2_instance_connect_endpoint_sg.security_group_id
}

output "ec2_security_group_id" {
  value = module.ec2_instance_sg.security_group_id
}