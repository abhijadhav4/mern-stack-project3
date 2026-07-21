locals {
  project = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  vpc_name                  = "${local.project}-vpc"
  public_subnet_1_name      = "${local.project}-public-subnet-1"
  public_subnet_2_name      = "${local.project}-public-subnet-2"
  private_subnet_1_name     = "${local.project}-private-subnet-1"
  private_subnet_2_name     = "${local.project}-private-subnet-2"
  internet_gateway_name     = "${local.project}-igw"
  public_route_table_name   = "${local.project}-public-rt"
  private_route_table_name  = "${local.project}-private-rt"
  nat_gateway_name          = "${local.project}-nat"

  cluster_name     = var.cluster_name
  node_group_name  = "${local.project}-node-group"

  frontend_repository = "frontend"
  backend_repository  = "backend"
}
