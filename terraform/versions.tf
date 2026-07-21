/*
===========================================
Terraform Version Configuration
===========================================

This file tells Terraform:

1. Which Terraform version is required.
2. Which AWS Provider version is required.

Keeping versions fixed helps avoid unexpected
changes after future updates.
*/

terraform {

  # Minimum Terraform version required
  required_version = ">= 1.6.0"

  # Required providers
  required_providers {

    aws = {

      source  = "hashicorp/aws"

      version = "~> 5.50"

    }

  }

}