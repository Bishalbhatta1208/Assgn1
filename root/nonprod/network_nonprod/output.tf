# Output variables  lists
output "public_subnet_ids" {
  value = module.vpc-dev.public_subnet_ids
}

output "vpc_id" {
  value = module.vpc-dev.vpc_id
}

output "private_subnet_ids" {
  value = module.vpc-dev.private_subnet_ids
}
/*
output "aws_nat_gateway" {
  value = module.vpc-dev.nat_gateway_id
}

output "aws_internet_gateway" {
  value = module.vpc-dev.aws_internet_gateway
}

output "public_cidr_blocks" {
  value = module.vpc-dev.public_cidr_b
}


output "private_cidr_b" {
  value = module.vpc-dev.private_cidr_b
}

output "public_route_table" {
  value = module.vpc-dev.pub_route_table
}


output "private_route_table" {
  value = module.vpc-dev.priv_route_table
}


output "aws_eip" {
  value = module.vpc-dev.aws_eip
}

*/