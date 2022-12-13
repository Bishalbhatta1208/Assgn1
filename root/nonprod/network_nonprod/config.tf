
terraform {
  backend "s3" {
    bucket = "nonprod-acs730-assgn1-bishal"      // its a same name as that of the bucket created earlier
    key    = "network_nonprod/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
    region = "us-east-1"                         // Region name as per availability zone
  }
}