#!/bin/bash

set -e

# =============================================
# Build and Push Docker Images to ECR
# =============================================

AWS_REGION="ap-south-1"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

echo "=== Logging into ECR ==="
aws ecr get-login-password --region $AWS_REGION \
  | docker login --username AWS --password-stdin $ECR_URL

echo "=== Building Backend Image ==="
docker build -t backend ./Application-Code/backend
docker tag backend:latest $ECR_URL/backend:latest
docker push $ECR_URL/backend:latest
echo "Backend pushed: $ECR_URL/backend:latest"

echo "=== Building Frontend Image ==="
docker build -t frontend ./Application-Code/frontend
docker tag frontend:latest $ECR_URL/frontend:latest
docker push $ECR_URL/frontend:latest
echo "Frontend pushed: $ECR_URL/frontend:latest"

echo "=== Build and Push Complete ==="
