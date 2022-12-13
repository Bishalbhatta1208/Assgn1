
terraform {
  backend "s3" {
    bucket = "prod-s3-assign1-bishal"
    key    = "network-prod/terraform.tfstate"
    region = "us-east-1"
  }
}
