terraform {
  backend "s3" {
    bucket = "prod-s3-assign1-bishal"
    key    = "webserver-prod/terraform.tfstate"
    region = "us-east-1"
  }
}