#for Private Subnets
output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

# for private ip
output "private_ip" {

  value = var.priv_cidr_b

}

output "vpc_id" {
  value = aws_vpc.vpc_prod.id

}
# CIDR block output
output "prod_vpc_cidr" {
  value = var.vpc_cidr
}
