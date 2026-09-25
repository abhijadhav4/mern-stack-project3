#!/bin/bash

set -euo pipefail

echo "=== Creating monitoring namespace ==="
kubectl apply -f monitoring/namespace.yaml
kubectl delete pvc -n monitoring storage-prometheus-alertmanager-0 --ignore-not-found || true

echo "=== Adding Helm repos ==="
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

echo "=== Removing legacy Grafana release ==="
helm uninstall grafana --namespace monitoring || true

echo "=== Installing Prometheus Operator CRDs ==="
helm show crds prometheus-community/kube-prometheus-stack | kubectl apply --server-side -f -
kubectl wait --for=condition=Established \
  --timeout=120s \
  crd/servicemonitors.monitoring.coreos.com

echo "=== Installing VPA ==="
kubectl apply -f https://raw.githubusercontent.com/kubernetes/autoscaler/master/vertical-pod-autoscaler/deploy/vpa-v1-crd-gen.yaml
kubectl apply -k https://github.com/kubernetes/autoscaler//vertical-pod-autoscaler/deploy?ref=master

if [[ -z "${SLACK_WEBHOOK_URL:-}" ]]; then
  echo "SLACK_WEBHOOK_URL must be set before installing monitoring. Add the secret in GitHub Actions or export it in your shell." >&2
  exit 1
fi
kubectl create secret generic alertmanager-slack \
  --namespace monitoring \
  --from-literal=slack-webhook-url="$SLACK_WEBHOOK_URL" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "=== Installing Prometheus Operator stack ==="
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  -f monitoring/prometheus-values.yaml

echo "=== Applying Alert Rules ==="
kubectl apply -f monitoring/alert-rules.yaml

echo "=== Applying ServiceMonitors ==="
kubectl apply -f monitoring/servicemonitor-backend.yaml
kubectl apply -f monitoring/servicemonitor-frontend.yaml

echo "=== Monitoring stack installed ==="
echo ""
echo "Prometheus:"
kubectl get svc prometheus-kube-prometheus-prometheus -n monitoring

echo ""
echo "Grafana:"
kubectl get svc prometheus-grafana -n monitoring
