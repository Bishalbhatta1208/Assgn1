
#  Define the provider
provider "aws" {
  region = "us-east-1"
}


data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# retrieving data
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "nonprod-acs730-assgn1-bishal"
    key    = "network_nonprod/terraform.tfstate"
    region = "us-east-1"
  }
}



data "aws_availability_zones" "available" {
  state = "available"
}



locals {
  default_tags = merge(module.globalvars.default_tags, { "env" = var.environment })
  prefix       = module.globalvars.prefix
  name_prefix  = "${local.prefix}-${var.environment}"
}

module "globalvars" {
  source = "/home/ec2-user/environment/130377229_assignment1/Modules/globalvars"
}


resource "aws_instance" "webserver" {
  count                       = length(data.terraform_remote_state.network.outputs.private_subnet_ids)
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.environment)
  key_name                    = aws_key_pair.web_key.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.private_subnet_ids[count.index]
  security_groups             = [aws_security_group.SG_WebServer.id]
  associate_public_ip_address = false
  user_data = templatefile("${path.module}/install_httpd.sh.tpl", {
    env    = upper(var.environment),
    prefix = upper(var.prefix)
    }

  )

  root_block_device {
    encrypted = var.environment == "prod" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${var.prefix}-webserver"
    }
  )
}

/*
resource "aws_instance" "Web_Server02" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.environment)
  key_name                    = aws_key_pair.web_key.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.private_subnet_ids[1]
  security_groups             = [aws_security_group.SG_WebServer.id]
  associate_public_ip_address = false
  user_data = templatefile("${path.module}/install_httpd.sh.tpl", {
    env  = upper(var.environment),
    prefix = upper(local.prefix)
    }

  )

  root_block_device {
    encrypted = var.environment == "prod" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${var.prefix}-Web_Server02"
    }
  )
}

*/
# generating ssh key for ec2 instances
resource "aws_key_pair" "web_key" {
  key_name   = var.prefix
  public_key = file("${var.prefix}.pub")
}


# Security Group For webserver
resource "aws_security_group" "SG_WebServer" {
  name        = "Allow_SSH_HTTP"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description      = "HTTP from everywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    security_groups  = [aws_security_group.SG_Bastion.id]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    security_groups  = [aws_security_group.SG_Bastion.id]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${var.prefix}-SG_WebServer-sg"
    }
  )
}



# Bastion server creation
resource "aws_instance" "Bastionhost" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.environment)
  key_name                    = aws_key_pair.web_key.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.public_subnet_ids[1]
  security_groups             = [aws_security_group.SG_Bastion.id]
  associate_public_ip_address = true


  root_block_device {
    encrypted = var.environment == "prod" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${var.prefix}-Bastionhost"
    }
  )
}


# Security Group
resource "aws_security_group" "SG_Bastion" {
  name        = "Allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id


  ingress {
    description      = "SSH from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${var.prefix}-SG_Bastion"
    }
  )
}
