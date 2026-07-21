/*
===========================================
Terraform Outputs
===========================================

Outputs display important information
after Terraform finishes creating
your infrastructure.

Run:

terraform apply

At the end Terraform will print these
values automatically.

===========================================
*/

#############################################
# VPC ID
#############################################

output "vpc_id" {

  description = "VPC ID"

  value = aws_vpc.main.id

}

#############################################
# Public Subnets
#############################################

output "public_subnet_1" {

  description = "Public Subnet 1"

  value = aws_subnet.public_subnet_1.id

}

output "public_subnet_2" {

  description = "Public Subnet 2"

  value = aws_subnet.public_subnet_2.id

}

#############################################
# Private Subnets
#############################################

output "private_subnet_1" {

  description = "Private Subnet 1"

  value = aws_subnet.private_subnet_1.id

}

output "private_subnet_2" {

  description = "Private Subnet 2"

  value = aws_subnet.private_subnet_2.id

}

#############################################
# EKS Cluster
#############################################

output "eks_cluster_name" {

  description = "Amazon EKS Cluster Name"

  value = aws_eks_cluster.eks.name

}

output "eks_cluster_endpoint" {

  description = "EKS API Endpoint"

  value = aws_eks_cluster.eks.endpoint

}

#############################################
# Worker Node Group
#############################################

output "worker_node_group" {

  description = "Managed Node Group"

  value = aws_eks_node_group.worker_nodes.node_group_name

}

#############################################
# Frontend ECR Repository
#############################################

output "frontend_repository_url" {

  description = "Frontend ECR Repository"

  value = aws_ecr_repository.frontend.repository_url

}

#############################################
# Backend ECR Repository
#############################################

output "backend_repository_url" {

  description = "Backend ECR Repository"

  value = aws_ecr_repository.backend.repository_url

}

#############################################
# AWS Region
#############################################

output "aws_region" {

  description = "AWS Region"

  value = var.aws_region

}

output "github_actions_role_arn" {

  description = "ARN of the GitHub Actions OIDC role"

  value = aws_iam_role.github_actions.arn

}