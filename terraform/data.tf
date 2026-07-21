/*
===========================================
AWS Data Sources
===========================================

Data sources read information from AWS.

They DO NOT create resources.

We will use them later while creating:

1. VPC
2. Subnets
3. EKS Cluster
4. IAM Roles

===========================================
*/

# Get current AWS account information
data "aws_caller_identity" "current" {}

# Get current AWS region
data "aws_region" "current" {}

# Get all available Availability Zones
data "aws_availability_zones" "available" {

  state = "available"

}