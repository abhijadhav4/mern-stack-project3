#!/bin/bash

set -e

# =============================================
# Destroy MERN Stack Deployment and Infrastructure
# =============================================

AWS_REGION="ap-south-1"
EKS_CLUSTER_NAME="mern-eks-cluster"

echo "=== Connecting to EKS ==="
aws eks update-kubeconfig \
  --region $AWS_REGION \
  --name $EKS_CLUSTER_NAME

echo "=== Uninstalling Helm Release ==="
helm uninstall mern-stack --namespace mern || true

echo "=== Uninstalling Monitoring Stack ==="
helm uninstall prometheus --namespace monitoring || true
helm uninstall grafana --namespace monitoring || true

echo "=== Deleting Namespaces ==="
kubectl delete namespace mern --ignore-not-found
kubectl delete namespace monitoring --ignore-not-found

echo "=== Destroying Terraform Infrastructure ==="
cd terraform
terraform destroy -auto-approve
cd ..

echo "=== Destroy Complete ==="
