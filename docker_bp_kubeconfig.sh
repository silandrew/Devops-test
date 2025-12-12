#!/bin/bash
# =============================================================================
# Azure ACR Login, Docker Build, Push & AKS Kubeconfig Setup
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TERRAFORM_DIR="${SCRIPT_DIR}/terraform/environments/DEVOPS_env"

cd "${TERRAFORM_DIR}"

# Get Terraform outputs
ACR_NAME=$(terraform output -raw acr_name)
ACR_LOGIN_SERVER=$(terraform output -raw acr_login_server)
RESOURCE_GROUP=$(terraform output -raw resource_group_name)
AKS_NAME=$(terraform output -raw aks_cluster_name)

# Variables
APP_NAME="devops-app"
NAMESPACE="devops"
IMAGE_TAG="${ACR_LOGIN_SERVER}/devops-app:latest"

echo "ACR: ${ACR_NAME}"
echo "Image: ${IMAGE_TAG}"
echo "AKS: ${AKS_NAME}"

# Login to ACR
az acr login --name ${ACR_NAME}

# Build and push
cd "${SCRIPT_DIR}"
docker build -t ${IMAGE_TAG} -f app/Dockerfile ./app
docker push ${IMAGE_TAG}

# Update kubeconfig
az aks get-credentials --resource-group ${RESOURCE_GROUP} --name ${AKS_NAME} --overwrite-existing
kubectl cluster-info
