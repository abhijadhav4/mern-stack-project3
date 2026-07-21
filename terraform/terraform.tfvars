project_name = "mern-stack"
environment = "dev"
aws_region = "ap-south-1"

cluster_name = "mern-eks-cluster"
kubernetes_version = "1.30"
node_instance_type = "c7i-flex.large"

desired_size = 1
min_size = 1
max_size = 2

vpc_cidr = "10.0.0.0/16"
public_subnet_1_cidr = "10.0.1.0/24"
public_subnet_2_cidr = "10.0.2.0/24"
private_subnet_1_cidr = "10.0.3.0/24"
private_subnet_2_cidr = "10.0.4.0/24"