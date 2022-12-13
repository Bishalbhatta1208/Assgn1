# displaying Instances type
variable "instance_type" {
  default = {
    "prod"    = "t3.medium"
    "nonprod" = "t2.micro"
  }
  description = "instances"
  type        = map(string)
}


variable "default_tags" {
  default = {
    "Owner" = "bishal"
    "App"   = "Web"
  }
  type        = map(any)
  description = "applied to all AWS resources"
}


variable "prefix" {
  default     = "assignment1"
  type        = string
  description = "prefixed name"
}


variable "environment" {
  default     = "nonprod"
  type        = string
  description = "dev env"
}




