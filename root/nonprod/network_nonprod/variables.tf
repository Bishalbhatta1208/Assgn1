# defined default tags
variable "default_tags" {
  default = {
    "Owner" = "Bishal130377229"
    "App"   = "Gateways"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}


variable "prefix" {
  type        = string
  default     = "assgn1"
  description = "Name prefix"
}


# Provisioning private subnets
variable "private_subnet_cidrs" {
  default     = ["10.1.3.0/24", "10.1.4.0/24"]
  type        = list(string)
  description = "PrScs"
}

# Provisioning public subnets 
variable "public_subnet_cidrs" {
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
  type        = list(string)
  description = "PScs"
}



variable "vpc_cidr" {
  default     = "10.1.0.0/16"
  type        = string
  description = "host static web site"
}

#signaling current env
variable "environment" {
  default     = "nonprod"
  type        = string
  description = "Deployment Env"
}

