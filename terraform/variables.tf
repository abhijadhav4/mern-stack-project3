/*
===========================================
Terraform Variables
===========================================

This file declares all variables used
throughout the Terraform project.

The actual values will be provided in
terraform.tfvars.

===========================================
*/

# Project Name
variable "project_name" {

  description = "Project Name"

  type = string

}

# Environment
variable "environment" {

  description = "Environment Name"

  type = string

}

# AWS Region
variable "aws_region" {

  description = "AWS Region"

  type = string

}

# VPC CIDR Block
variable "vpc_cidr" {

  description = "VPC CIDR"

  type = string

}

# Public Subnet 1
variable "public_subnet_1_cidr" {

  description = "Public Subnet 1"

  type = string

}

# Public Subnet 2
variable "public_subnet_2_cidr" {

  description = "Public Subnet 2"

  type = string

}

# Private Subnet 1
variable "private_subnet_1_cidr" {

  description = "Private Subnet 1"

  type = string

}

# Private Subnet 2
variable "private_subnet_2_cidr" {

  description = "Private Subnet 2"

  type = string

}

# EKS Cluster Name
variable "cluster_name" {

  description = "EKS Cluster Name"

  type = string

}

# Kubernetes Version
variable "kubernetes_version" {

  description = "EKS Kubernetes Version"

  type = string

}

# EC2 Instance Type
variable "node_instance_type" {

  description = "EKS Worker Node Instance Type"

  type = string

}

# Minimum Worker Nodes
variable "desired_size" {

  description = "Desired Worker Nodes"

  type = number

}

# Minimum Nodes
variable "min_size" {

  description = "Minimum Worker Nodes"

  type = number

}

# Maximum Nodes
variable "max_size" {

  description = "Maximum Worker Nodes"

  type = number

}