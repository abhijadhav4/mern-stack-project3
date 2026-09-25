#!/bin/bash

set -euo pipefail

# =============================================
# Destroy MERN Stack Deployment and Infrastructure
# =============================================

AWS_REGION="ap-south-1"
EKS_CLUSTER_NAME="mern-eks-cluster"

echo "=== Connecting to EKS ==="
aws eks update-kubeconfig \
  --region $AWS_REGION \
  --name $EKS_CLUSTER_NAME

echo "=== Removing ArgoCD application ==="
kubectl delete application mern-stack -n argocd --ignore-not-found --wait=false

echo "=== Uninstalling application Helm release ==="
helm uninstall mern-stack --namespace mern || true

echo "=== Uninstalling Monitoring Stack ==="
helm uninstall prometheus --namespace monitoring || true
helm uninstall grafana --namespace monitoring || true

echo "=== Removing ArgoCD installation ==="
kubectl delete namespace argocd --ignore-not-found --wait=true

echo "=== Deleting application and monitoring namespaces ==="
kubectl delete namespace mern --ignore-not-found --wait=true
kubectl delete namespace monitoring --ignore-not-found --wait=true

echo "=== Removing operator CRDs ==="
kubectl get crd -o name | grep -E '/(argoproj.io|monitoring.coreos.com)$' | xargs -r kubectl delete --ignore-not-found || true

echo "=== Destroying Terraform Infrastructure ==="
cd terraform
terraform destroy -auto-approve
cd ..

echo "=== Destroy Complete ==="
