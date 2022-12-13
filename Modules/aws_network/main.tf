

#  Defining the aws provider
provider "aws" {
  region = "us-east-1"
}

# describing the data source for us-east-1 availability zone
data "aws_availability_zones" "available" {
  state = "available"
}


# tags are locally defined
locals {
  default_tags = merge(module.globalvars.default_tags, { "environment" = var.environment })
  prefix       = module.globalvars.prefix
  name_prefix  = "${local.prefix}-${var.environment}"
}

module "globalvars" {
  source = "/home/ec2-user/environment/130377229_assignment1/Modules/globalvars"
}


# new vpc is being created 
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = merge(
    local.default_tags, {
      Name = "${var.prefix}-vpc"
    }
  )
}


#provisioning of the public subnet
resource "aws_subnet" "pub_subnet" {
  count             = length(var.public_cidr_b)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_cidr_b[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge(
    local.default_tags, {
      Name = "${var.prefix}-public-subnet-${count.index}"
    }
  )
}

# #provisioning of the private subnet
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_cidr_b)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_cidr_b[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge(
    local.default_tags, {
      Name = "${var.prefix}-private-subnet-${count.index}"
    }
  )
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.default_tags,
    {
      "Name" = "${var.prefix}-igw"
    }
  )
}


resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.pub_subnet[0].id

  tags = merge(
    local.default_tags, {
      Name = "${var.prefix}-nat_gw"
    }
  )
}


resource "aws_eip" "nat_eip" {
  vpc   = true
  tags = {
    Name = "${var.prefix}-natgw"
  }
depends_on = [aws_internet_gateway.igw]
}


resource "aws_route_table" "pub_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.prefix}-pub_route_table"
  }
}

resource "aws_route_table_association" "pub_rou_tab_ass" {
  route_table_id = aws_route_table.pub_route_table.id
  subnet_id      = aws_subnet.pub_subnet[0].id
}



resource "aws_route_table" "priv_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }
   tags = merge(
    local.default_tags, {
      Name = "${var.prefix}-priv_route_table"
    }
  )
}

resource "aws_route_table_association" "priv_rou_tab_ass" {
  count          = length(aws_subnet.private_subnet[*].id)
  route_table_id = aws_route_table.priv_route_table.id
  subnet_id      = aws_subnet.private_subnet[count.index].id
}

