terraform {
  backend "s3" {
    bucket = "nonprod-acs730-assgn1-bishal"        // Bucket where to SAVE Terraform State
    key    = "webserver_nonprod/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
    region = "us-east-1"                           // Region where bucket is created
  }
}