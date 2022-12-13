# provider information
provider "aws" {
  alias  = "east"
  region = "us-east-1"
}

# Data for us-east-1 region
data "aws_availability_zones" "available" {
  state = "available"
}


locals {
  default_tags = merge(module.globalvars.default_tags, { "env" = var.env })
  prefix       = module.globalvars.prefix
  name_prefix  = "${local.prefix}-${var.env}"
}

module "globalvars" {
  source = "/home/ec2-user/environment/130377229_assignment1/Modules/globalvars"
}


#new vpc is created
resource "aws_vpc" "vpc_prod" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = merge(
    var.default_tags, {
      Name = "${var.prefix}-vpc"
    }
  )
}

# provisioning the private subnet
resource "aws_subnet" "private_subnet" {
  count             = length(var.priv_cidr_b)
  vpc_id            = aws_vpc.vpc_prod.id
  cidr_block        = var.priv_cidr_b[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge(
    local.default_tags, {
      Name = "${var.prefix}-Prod-private-subnet-${count.index}"
    }
  )
}
