#!/bin/bash

# =============================================================================
# Create Service Principal for GitHub Actions CI/CD
# =============================================================================
# WARNING: This script assigns User Access Administrator role which grants
# elevated permissions. For production environments, consider:
# - Using Azure Managed Identity instead of Service Principal
# - Creating custom RBAC roles with minimal required permissions
# - Limiting scope to specific resources rather than resource group
# =============================================================================

# Get values
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
TENANT_ID=$(az account show --query tenantId -o tsv)
RG_NAME="devopshomework-dev-rg"
ACR_NAME="devopshomeworkdev"
SP_NAME="git-act-sp"

echo "Creating Service Principal with Contributor role..."
MSYS_NO_PATHCONV=1 az ad sp create-for-rbac --name "$SP_NAME" \
  --role Contributor \
  --scopes "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RG_NAME"

SP_APP_ID=$(az ad sp list --display-name "$SP_NAME" --query "[0].appId" -o tsv)

# Assign User Access Administrator role (required for creating/deleting role assignments)
# NOTE: This is a privileged role - use with caution in production
echo "Assigning User Access Administrator role for role assignment management..."
MSYS_NO_PATHCONV=1 az role assignment create --assignee $SP_APP_ID \
  --role "User Access Administrator" \
  --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RG_NAME" 2>/dev/null

# Assign AcrPush role
ACR_ID=$(az acr show --name $ACR_NAME --query id -o tsv)
MSYS_NO_PATHCONV=1 az role assignment create --assignee $SP_APP_ID --role AcrPush --scope "$ACR_ID" 2>/dev/null

echo ""
echo "Add subscriptionId to the JSON above:"
echo "  \"subscriptionId\": \"$SUBSCRIPTION_ID\""
echo ""
echo "Roles assigned to Service Principal:"
echo "  - Contributor (create/delete resources)"
echo "  - User Access Administrator (create/delete role assignments) - NOT RECOMMENDED FOR PRODUCTION"
echo "  - AcrPush (push images to ACR)"
echo ""
echo "SECURITY NOTE: For production, use Managed Identity or custom RBAC roles instead."
