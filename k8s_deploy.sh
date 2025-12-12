#!/bin/bash
# Kubernetes Deployment Script for Azure AKS (Using Helm)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TERRAFORM_DIR="${SCRIPT_DIR}/terraform/environments/DEVOPS_env"
HELM_CHART_DIR="${SCRIPT_DIR}/devops-app"
NAMESPACE="devops"
RELEASE_NAME="devops-app"

# Get Terraform outputs
cd "${TERRAFORM_DIR}"
echo "Getting Terraform outputs..."
ACR_LOGIN_SERVER=$(terraform output -raw acr_login_server 2>/dev/null || echo "")
IMAGE_REPO="${ACR_LOGIN_SERVER}/devops-app"

if [ -z "$ACR_LOGIN_SERVER" ]; then
    echo "ERROR: Terraform outputs not found. Have you run 'terraform apply'?"
    exit 1
fi

echo "Using image repository: ${IMAGE_REPO}"

# Create namespace
echo "Creating namespace ${NAMESPACE}..."
kubectl create namespace "${NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f -

# Deploy using Helm
echo "Deploying application with Helm..."
cd "${SCRIPT_DIR}"

helm upgrade --install "${RELEASE_NAME}" "${HELM_CHART_DIR}" \
    --namespace "${NAMESPACE}" \
    --set image.repository="${IMAGE_REPO}" \
    --set image.tag="latest" \
    --set image.pullPolicy="Always" \
    --wait \
    --timeout=300s

# Wait for deployment
echo "Waiting for deployment to be ready..."
kubectl rollout status deployment/${RELEASE_NAME} -n "${NAMESPACE}" --timeout=120s

echo "Deployment complete!"
kubectl get pods,svc,hpa -n "${NAMESPACE}"
