
# provider information
provider "aws" {
  region = "us-east-1"
}

# remote state

data "terraform_remote_state" "prod_remote" {
  backend = "s3"
  config = {
    bucket = "prod-s3-assign1-bishal"
    key    = "network-prod/terraform.tfstate"
    region = "us-east-1"
  }
}


data "terraform_remote_state" "nonprod_remote" {
  backend = "s3"
  config = {
    bucket = "nonprod-acs730-assgn1-bishal"
    key    = "network_nonprod/terraform.tfstate"
    region = "us-east-1"
  }
}

# for vpc peering Conncection 

resource "aws_vpc_peering_connection" "peering_of_vpc" {
  peer_vpc_id = data.terraform_remote_state.prod_remote.outputs.vpc_id
  vpc_id      = data.terraform_remote_state.nonprod_remote.outputs.vpc_id
  auto_accept = true
  tags = {
    Name = "peer Conncection"
  }
}

resource "aws_vpc_peering_connection_options" "peer_connection" {
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_of_vpc.id
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
  requester {
    allow_remote_vpc_dns_resolution = true
  }
}
#Creating Route table for Peering connection 

resource "aws_route_table" "acceptor_route_table" {
  vpc_id = data.terraform_remote_state.prod_remote.outputs.vpc_id 
  route {
    cidr_block                = "10.1.2.0/24"
    vpc_peering_connection_id = aws_vpc_peering_connection.peering_of_vpc.id
  }
  depends_on = [aws_vpc_peering_connection.peering_of_vpc]
  tags = {
    Name = "acceptor route table"
  }
}

#Requestor Route table 
resource "aws_route_table" "requestor_route_table" {
  vpc_id = data.terraform_remote_state.nonprod_remote.outputs.vpc_id 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.terraform_remote_state.nonprod_remote.outputs.aws_internet_gateway
  }
  route {
    cidr_block                = data.terraform_remote_state.prod_remote.outputs.prod_vpc_cidr  
    vpc_peering_connection_id = aws_vpc_peering_connection.peering_of_vpc.id
  }
  depends_on = [aws_vpc_peering_connection.peering_of_vpc]
  tags = {
    Name = "Requestor Route table"
  }
}

# association of acceptor route table 
resource "aws_route_table_association" "acceptor_routes_assn" {
  count          = length(data.terraform_remote_state.prod_remote.outputs.private_subnet_ids)
  route_table_id = aws_route_table.acceptor_route_table.id
  subnet_id      = data.terraform_remote_state.prod_remote.outputs.private_subnet_ids[count.index]
}

# association of requestor Route table   
resource "aws_route_table_association" "requestor_routes_assn" {
  route_table_id = aws_route_table.requestor_route_table.id
  subnet_id      = data.terraform_remote_state.nonprod_remote.outputs.public_subnet_ids[1]
}


