
variable "default_tags" {
  default = {
    "Owner" = "bishal"
    "App"   = "Web"
  }
  type        = map(any)
  description = "tags"
}

# prefixed name
variable "prefix" {
  default     = "assignment1"
  type        = string
  description = "prefixed name"
}

# Provisioning private subnets

variable "priv_cidr_b" {
  default     = ["10.100.3.0/24", "10.100.4.0/24"]
  type        = list(string)
  description = "private cider block"
}

# vpc cidr

variable "vpc_cidr" {
  default     = "10.100.0.0/16"
  type        = string
  description = "vpc cidr"
}

# signalling to the current environment

variable "env" {
  default     = "prod"
  type        = string
  description = "prod env"
}

