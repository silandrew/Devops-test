#!/bin/bash
# Kubernetes Delete Script for Azure AKS - Helm Based
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TERRAFORM_DIR="${SCRIPT_DIR}/terraform/environments/DEVOPS_env"
RELEASE_NAME="devops-app"
NAMESPACE="devops"

# Uninstall Helm Release
echo "Uninstalling Helm release '${RELEASE_NAME}' from namespace '${NAMESPACE}'..."
if helm status "${RELEASE_NAME}" -n "${NAMESPACE}" &>/dev/null; then
    helm uninstall "${RELEASE_NAME}" -n "${NAMESPACE}"
    echo "Helm release uninstalled!"
else
    echo "Helm release not found"
fi

# Delete Namespace
echo "Deleting namespace '${NAMESPACE}'..."
if kubectl get namespace "${NAMESPACE}" &>/dev/null; then
    kubectl delete namespace "${NAMESPACE}" --wait=true --timeout=120s
    echo "Namespace deleted!"
else
    echo "Namespace not found"
fi

# Clean up ACR Images
echo "Cleaning up ACR images..."
cd "${TERRAFORM_DIR}"
ACR_NAME=$(terraform output -raw acr_name 2>/dev/null || echo "")
if [ -n "$ACR_NAME" ]; then
    az acr repository delete --name "${ACR_NAME}" --image devops-app:latest --yes 2>/dev/null || true
    echo "ACR images cleaned up!"
fi

echo "Cleanup complete!"
