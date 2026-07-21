# MERN Stack Three-Tier Deployment on AWS EKS

## Project Overview

This project deploys a Three-Tier MERN Stack application on AWS EKS using:

- ReactJS (Frontend)
- NodeJS + Express (Backend)
- MongoDB (Database)

DevOps Tools Used:

- Terraform
- Docker
- AWS ECR
- AWS EKS
- Kubernetes
- Helm
- GitHub Actions (CI/CD)
- ArgoCD (GitOps)
- Prometheus
- Grafana

---

# Project Structure

```
mern-stack-project3/

│
├── .github/
│   └── workflows/
│       └── deploy.yml
│
├── terraform/
│   ├── provider.tf
│   ├── variables.tf
│   ├── networking.tf
│   ├── iam.tf
│   ├── eks.tf
│   ├── ecr.tf
│   ├── outputs.tf
│   └── terraform.tfvars
│
├── k8s/
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secrets.yaml
│   ├── mongodb-pv.yaml
│   ├── mongodb-pvc.yaml
│   ├── mongodb-deployment.yaml
│   ├── mongodb-service.yaml
│   ├── backend-deployment.yaml
│   ├── backend-service.yaml
│   ├── frontend-deployment.yaml
│   ├── frontend-service.yaml
│   └── ingress.yaml
│
├── helm/
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
│
├── argocd/
│   └── application.yaml
│
├── prometheus/
│   └── prometheus-values.yaml
│
├── grafana/
│   └── grafana-values.yaml
│
└── Application-Code/
    ├── backend/
    └── frontend/
```

---

# Prerequisites

Install the following:

- AWS CLI
- Terraform
- Docker
- kubectl
- Helm
- Git
- NodeJS

---

# Step 1

Clone Repository

```bash
git clone https://github.com/abhijadhav4/mern-stack-project3.git

cd mern-stack-project3
```

---

# Step 2

Configure AWS

```bash
aws configure
```

Enter

```
AWS Access Key
AWS Secret Key
Region
Output format
```

---

# Step 3

Create Infrastructure

```bash
cd terraform

terraform init

terraform plan

terraform apply -auto-approve
```

Terraform creates

- VPC
- Public Subnets
- Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- EKS Cluster
- Node Group
- ECR Repositories

---

# Step 4

Connect kubectl

```bash
aws eks update-kubeconfig \
--region ap-south-1 \
--name mern-eks-cluster
```

Verify

```bash
kubectl get nodes
```

---

# Step 5

Build Docker Images

Backend

```bash
cd Application-Code/Application-Code/backend

docker build -t backend .
```

Frontend

```bash
cd ../frontend

docker build -t frontend .
```

---

# Step 6

Push Images to ECR

```bash
aws ecr get-login-password \
| docker login \
--username AWS \
--password-stdin 224193574273.dkr.ecr.ap-south-1.amazonaws.com
```

Push

```bash
docker tag backend 224193574273.dkr.ecr.ap-south-1.amazonaws.com/backend:latest

docker push 224193574273.dkr.ecr.ap-south-1.amazonaws.com/backend:latest

docker tag frontend 224193574273.dkr.ecr.ap-south-1.amazonaws.com/frontend:latest

docker push 224193574273.dkr.ecr.ap-south-1.amazonaws.com/frontend:latest
```

---

# Step 7

Deploy Kubernetes Resources

```bash
kubectl apply -f k8s/
```

Verify

```bash
kubectl get all -n mern
```

---

# Step 8

Deploy using Helm

```bash
helm install mern-stack ./helm
```

Upgrade

```bash
helm upgrade mern-stack ./helm
```

---

# Step 9

Install ArgoCD

```bash
kubectl create namespace argocd

kubectl apply -n argocd \
-f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Deploy Application

```bash
kubectl apply -f argocd/application.yaml
```

---

# Step 10

Install Prometheus

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

helm install prometheus prometheus-community/prometheus \
-f prometheus/prometheus-values.yaml
```

---

# Step 11

Install Grafana

```bash
helm repo add grafana https://grafana.github.io/helm-charts

helm repo update

helm install grafana grafana/grafana \
-f grafana/grafana-values.yaml
```

---

# Step 12

GitHub Secrets

Create these secrets inside GitHub Repository

```
AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY
```

---

# Step 13

GitHub Actions

Push code

```bash
git add .

git commit -m "Initial Commit"

git push origin main
```

GitHub Actions will automatically

- Build Docker Images
- Push Images to ECR
- Connect to EKS
- Deploy using Helm

---

# Useful Commands

Pods

```bash
kubectl get pods -n mern
```

Services

```bash
kubectl get svc -n mern
```

Deployments

```bash
kubectl get deployment -n mern
```

Logs

```bash
kubectl logs POD_NAME -n mern
```

Describe Pod

```bash
kubectl describe pod POD_NAME -n mern
```

---

# Monitoring

Prometheus

```
http://PROMETHEUS-LOADBALANCER
```

Grafana

```
http://GRAFANA-LOADBALANCER
```

Default Login

```
Username : admin

Password : admin123
```

---

# Technologies Used

- ReactJS
- NodeJS
- Express
- MongoDB
- Docker
- Terraform
- AWS ECR
- AWS EKS
- Kubernetes
- Helm
- GitHub Actions
- ArgoCD
- Prometheus
- Grafana