/*
===========================================
Security Groups
===========================================

This file creates:

1. EKS Control Plane Security Group
2. EKS Worker Node Security Group

===========================================
*/

#############################
# EKS Cluster Security Group
#############################

resource "aws_security_group" "eks_cluster_sg" {
  name        = "${local.project}-eks-cluster-sg"
  description = "Security Group for EKS Cluster"
  vpc_id      = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project}-eks-cluster-sg"
    }
  )
}

#############################
# Worker Node Security Group
#############################

resource "aws_security_group" "worker_node_sg" {
  name        = "${local.project}-worker-node-sg"
  description = "Security Group for Worker Nodes"
  vpc_id      = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project}-worker-node-sg"
    }
  )
}

#############################
# Worker Nodes -> Worker Nodes (Internal Communication)
#############################

resource "aws_security_group_rule" "worker_ingress_self" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  security_group_id        = aws_security_group.worker_node_sg.id
  source_security_group_id = aws_security_group.worker_node_sg.id
}

#############################
# Cluster -> Worker Nodes (Kubelet)
#############################

resource "aws_security_group_rule" "cluster_to_worker" {
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.worker_node_sg.id
  source_security_group_id = aws_security_group.eks_cluster_sg.id
}

#############################
# Worker Nodes -> Cluster (API Server)
#############################

resource "aws_security_group_rule" "worker_to_cluster" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster_sg.id
  source_security_group_id = aws_security_group.worker_node_sg.id
}

#############################
# Internet -> Cluster API (HTTPS)
#############################

resource "aws_security_group_rule" "cluster_api_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks_cluster_sg.id
}

#############################
# Worker Nodes Outbound (All Traffic)
#############################

resource "aws_security_group_rule" "worker_egress" {
  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.worker_node_sg.id
}

#############################
# Cluster Outbound (All Traffic)
#############################

resource "aws_security_group_rule" "cluster_egress" {
  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks_cluster_sg.id
}
