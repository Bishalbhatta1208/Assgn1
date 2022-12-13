# Instance type
variable "instance_type" {
  default = {
    "prod"    = "t3.medium"
  }
  description = "instance type"
  type        = map(string)
}

# Name prefix
variable "prefix" {
  default     = "assignment1-prodkey1"
  type        = string
  description = "prefixed name"
}

# Default tags
variable "default_tags" {
  default = {
    "Owner" = "bishal"
    "App"   = "Web"
  }
  type        = map(any)
  description = "applied to all AWS resources"
}


# signalling to the environment 
variable "env" {
  default     = "prod"
  type        = string
  description = "prod dep env"
}





