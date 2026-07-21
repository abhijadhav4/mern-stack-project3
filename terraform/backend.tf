/*
===========================================
Terraform Remote State Backend
===========================================

Stores Terraform state in S3 so it is
never committed to git and is shared
across team members.

Before using this, create the S3 bucket:

aws s3api create-bucket \
  --bucket mern-stack-terraform-state \
  --region ap-south-1 \
  --create-bucket-configuration LocationConstraint=ap-south-1

Then run: terraform init

===========================================
*/

terraform {
  backend "s3" {

    bucket = "mern-stack-terraform-state"
    key    = "mern-stack/dev/terraform.tfstate"
    region = "ap-south-1"

    encrypt = true
  }
}
