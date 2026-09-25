#!/bin/bash

set -e

echo "=== Creating argocd namespace ==="
kubectl create namespace argocd || true

echo "=== Installing ArgoCD ==="
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "=== Applying ArgoCD Application manifest ==="
kubectl apply -f argocd/application.yaml

echo "=== ArgoCD install complete ==="
kubectl get pods -n argocd || true
