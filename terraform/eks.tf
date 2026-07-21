/*
===========================================
Amazon EKS Cluster
===========================================

This file creates

1. IAM Role for EKS Cluster
2. IAM Role for Worker Nodes
3. IAM Policy Attachments
4. EKS Cluster
5. Managed Node Group

===========================================
*/

#################################################
# IAM Role for EKS Cluster
#################################################

resource "aws_iam_role" "eks_cluster_role" {

  name = "${local.project}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "eks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.common_tags
}

#################################################
# Attach Policies to EKS Cluster Role
#################################################

resource "aws_iam_role_policy_attachment" "cluster_policy" {

  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

}

resource "aws_iam_role_policy_attachment" "vpc_resource_controller" {

  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"

}

#################################################
# Create EKS Cluster
#################################################

resource "aws_eks_cluster" "eks" {

  name     = local.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  version = var.kubernetes_version

  vpc_config {

    subnet_ids = [
      aws_subnet.public_subnet_1.id,
      aws_subnet.public_subnet_2.id,
      aws_subnet.private_subnet_1.id,
      aws_subnet.private_subnet_2.id
    ]

    endpoint_private_access = true
    endpoint_public_access  = true

    security_group_ids = [
      aws_security_group.eks_cluster_sg.id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy,
    aws_iam_role_policy_attachment.vpc_resource_controller
  ]

  tags = merge(
    local.common_tags,
    {
      Name = local.cluster_name
    }
  )
}

#################################################
# IAM Role for Worker Nodes
#################################################

resource "aws_iam_role" "worker_node_role" {

  name = "${local.project}-worker-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.common_tags
}

#################################################
# Worker Node IAM Policies
#################################################

resource "aws_iam_role_policy_attachment" "worker_node_policy" {

  role       = aws_iam_role.worker_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

}

resource "aws_iam_role_policy_attachment" "cni_policy" {

  role       = aws_iam_role.worker_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"

}

resource "aws_iam_role_policy_attachment" "ecr_read_only" {

  role       = aws_iam_role.worker_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

}

#################################################
# Managed Node Group
#################################################

resource "aws_eks_node_group" "worker_nodes" {

  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${local.project}-workers"

  node_role_arn = aws_iam_role.worker_node_role.arn

  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  capacity_type = "ON_DEMAND"

  instance_types = [
    var.node_instance_type
  ]

  scaling_config {

    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size

  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [

    aws_eks_cluster.eks,

    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.ecr_read_only

  ]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project}-workers"
    }
  )
}