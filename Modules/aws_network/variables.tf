
variable "default_tags" {
  default = { }
  type        = map(any)
  description = "Default tags to be applied to all AWS resources"
}

# prefixed name
variable "prefix" {

  type        = string
  description = "assignment1 "
}

# Provisioning private subnets 
variable "private_cidr_b" {

  type        = list(string)
  description = "Prsc"
}

# Provisioning public subnets
variable "public_cidr_b" {

  type        = list(string)
  description = "pscs"
  
}


variable "vpc_cidr" {

  type        = string
  description = "directed to host static web site"
}

# signaling environment via variables 
variable "environment" {
  default     = "nonprod"
  type        = string
  description = "env"
}


