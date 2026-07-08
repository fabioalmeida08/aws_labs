output "subnet_id" {
  value = module.vpc.private_subnets[0]
}

output "vpc_id" {
  value = module.vpc.vpc_id
  
}

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}