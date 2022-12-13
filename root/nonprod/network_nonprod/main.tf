
module "vpc-dev" {
  source              = "/home/ec2-user/environment/130377229_assignment1/Modules/aws_network"
  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  private_cidr_b = var.private_subnet_cidrs
  public_cidr_b  = var.public_subnet_cidrs
  prefix              = var.prefix
  default_tags        = var.default_tags

}