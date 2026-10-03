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

echo "=== Generating VPA admission-controller TLS certificates ==="
VPA_CERT_DIR="$(mktemp -d)"
trap 'rm -rf "$VPA_CERT_DIR"' EXIT
cat > "$VPA_CERT_DIR/server.conf" <<'EOF'
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[v3_req]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, serverAuth
subjectAltName = DNS:vpa-webhook.kube-system.svc
EOF
openssl genrsa -out "$VPA_CERT_DIR/caKey.pem" 2048
openssl req -x509 -new -nodes -key "$VPA_CERT_DIR/caKey.pem" \
  -days 100000 \
  -out "$VPA_CERT_DIR/caCert.pem" \
  -subj "/CN=vpa_webhook_ca" \
  -addext "subjectAltName = DNS:vpa_webhook_ca"
openssl genrsa -out "$VPA_CERT_DIR/serverKey.pem" 2048
openssl req -new -key "$VPA_CERT_DIR/serverKey.pem" \
  -out "$VPA_CERT_DIR/server.csr" \
  -subj "/CN=vpa-webhook.kube-system.svc" \
  -config "$VPA_CERT_DIR/server.conf"
openssl x509 -req -in "$VPA_CERT_DIR/server.csr" \
  -CA "$VPA_CERT_DIR/caCert.pem" \
  -CAkey "$VPA_CERT_DIR/caKey.pem" \
  -CAcreateserial \
  -out "$VPA_CERT_DIR/serverCert.pem" \
  -days 100000 \
  -extensions v3_req \
  -extfile "$VPA_CERT_DIR/server.conf"
kubectl create secret generic vpa-tls-certs \
  --namespace=kube-system \
  --from-file=caKey.pem="$VPA_CERT_DIR/caKey.pem" \
  --from-file=caCert.pem="$VPA_CERT_DIR/caCert.pem" \
  --from-file=serverKey.pem="$VPA_CERT_DIR/serverKey.pem" \
  --from-file=serverCert.pem="$VPA_CERT_DIR/serverCert.pem" \
  --dry-run=client -o yaml | kubectl apply -f -
rm -rf "$VPA_CERT_DIR"
trap - EXIT

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
