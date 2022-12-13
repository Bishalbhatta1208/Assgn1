# we are declaring variables for Public Subnets
output "public_subnet_ids" {
  value = aws_subnet.pub_subnet[*].id
}

output "vpc_id" {
  value = aws_vpc.main.id
}


output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}


output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gw.id
}


output "aws_internet_gateway" {
  value = aws_internet_gateway.igw.id
}

 
 
output "aws_eip" {
  value = aws_eip.nat_eip.id
}



output "priv_route_table" {
  value = aws_route_table.priv_route_table.id
}


output "pub_route_table" {
  value = aws_route_table.pub_route_table.id
}




output "public_cidr_b" {
  value = var.public_cidr_b
}

output "private_cidr_b" {
  value = var.private_cidr_b
}