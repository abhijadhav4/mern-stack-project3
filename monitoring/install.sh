#!/bin/bash

set -e

echo "=== Creating monitoring namespace ==="
kubectl apply -f monitoring/namespace.yaml

echo "=== Adding Helm repos ==="
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

echo "=== Installing Prometheus ==="
helm upgrade --install prometheus prometheus-community/prometheus \
  --namespace monitoring \
  --create-namespace \
  -f monitoring/prometheus-values.yaml

echo "=== Installing Grafana ==="
helm upgrade --install grafana grafana/grafana \
  --namespace monitoring \
  --create-namespace \
  -f monitoring/grafana-values.yaml

echo "=== Applying Alert Rules ==="
kubectl apply -f monitoring/alert-rules.yaml

echo "=== Applying ServiceMonitors ==="
kubectl apply -f monitoring/servicemonitor-backend.yaml
kubectl apply -f monitoring/servicemonitor-frontend.yaml

echo "=== Monitoring stack installed ==="
echo ""
echo "Prometheus:"
kubectl get svc prometheus-server -n monitoring

echo ""
echo "Grafana:"
kubectl get svc grafana -n monitoring
