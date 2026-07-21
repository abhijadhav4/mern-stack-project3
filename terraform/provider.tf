/*
===========================================
AWS Provider Configuration
===========================================

This file connects Terraform to AWS.

Terraform will use:

1. AWS CLI credentials
2. Selected AWS Region

Before running Terraform, make sure you have
already configured AWS CLI using:

aws configure

Enter:
- AWS Access Key
- AWS Secret Key
- Region
- Output Format

===========================================
*/

provider "aws" {

  # AWS Region
  region = var.aws_region

  # Default tags added to every AWS resource
  default_tags {

    tags = {

      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"

    }

  }

}