#!/bin/bash

set -e

# =============================================
# Deploy MERN Stack to AWS EKS via Helm
# =============================================

AWS_REGION="ap-south-1"
EKS_CLUSTER_NAME="mern-eks-cluster"

echo "=== Connecting to EKS ==="
aws eks update-kubeconfig \
  --region $AWS_REGION \
  --name $EKS_CLUSTER_NAME

echo "=== Deploying with Helm ==="
helm upgrade --install mern-stack ./helm/mern-stack \
  --namespace mern \
  --create-namespace

echo "=== Verifying Deployment ==="
kubectl get pods -n mern
kubectl get svc -n mern
kubectl get deployment -n mern

echo "=== Deployment Complete ==="
