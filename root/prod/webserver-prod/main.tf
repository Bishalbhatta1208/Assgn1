#provider information
provider "aws" {
  region = "us-east-1"
}

# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


# retrieving data
data "terraform_remote_state" "networking1" {
  backend = "s3"
  config = {
    bucket = "prod-s3-assign1-bishal"
    key    = "network-prod/terraform.tfstate"
    region = "us-east-1"
  }
}

# Data source for us-east-1 region
data "aws_availability_zones" "available" {
  state = "available"
}

# local tags defined
locals {
  default_tags = merge(module.globalvars.default_tags, { "env" = var.env })
  prefix       = module.globalvars.prefix
  name_prefix  = "${local.prefix}-${var.env}"
}

module "globalvars" {
  source = "/home/ec2-user/environment/130377229_assignment1/Modules/globalvars"
}


# provisioning subnet by webserver
resource "aws_instance" "webserver" {
  count                       =  length(data.terraform_remote_state.networking1.outputs.private_subnet_ids)
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.web_key_prod.key_name
  subnet_id                   = data.terraform_remote_state.networking1.outputs.private_subnet_ids[count.index]
  security_groups             = [aws_security_group.web_sg.id]
  associate_public_ip_address = false
  user_data = templatefile("${path.module}/install_httpd.sh.tpl", {
    env    = upper(var.env),
    prefix = upper(var.prefix)
    }

  )

  root_block_device {
    encrypted = var.env == "prod" ? true : false
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
#provisioningsubnet via  Webserver-02
resource "aws_instance" "Webserver_Prod_2" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.web_key_prod.key_name
  subnet_id                   = data.terraform_remote_state.networking1.outputs.private_subnet_ids[1]
  security_groups             = [aws_security_group.web_sg.id]
  associate_public_ip_address = false


  root_block_device {
    encrypted = var.env == "prod" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${var.prefix}-Webserver-02"
    }
  )
}

*/

resource "aws_key_pair" "web_key_prod" {
  key_name   = var.prefix
  public_key = file("${var.prefix}.pub")
}


# Security Group for webserver 
resource "aws_security_group" "web_sg" {
  name        = "allow_http_ssh1"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.networking1.outputs.vpc_id



  ingress {
    description = "SSH from everywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"]

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
      "Name" = "${var.prefix}webserver-sg"
    }
  )
}


