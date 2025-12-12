# Azure AKS Solution - DevOps Homework

  Running This Solution

If you want to run this solution in your own environment:
1. Fork this repository to your GitHub account
2. Clone your forked repository
3. Create your own Azure Service Principal and configure GitHub secret (AZZZURETEST)
4. Update terraform.tfvars with your Azure subscription ID
5. Update .github/workflows/ci-cd.yaml with your resource names (if different)

The CI/CD pipeline will run automatically on push to main branch in your forked repository.
---
## IMPORTANT - Required Configuration
Before running this solution, you MUST update the following values in terraform/environments/DEVOPS_env/terraform.tfvars:

# Finding Your Azure Subscription ID

Login to Azure and list available subscriptions:
az login
az account list --output table
Set the subscription you want to use:
az account set --subscription "<YOUR_SUBSCRIPTION_ID>"
Verify selected subscription:
az account show --output table
REQUIRED:
subscription_id        = "<YOUR_AZURE_SUBSCRIPTION_ID>"    # Your Azure subscription ID
 or run with terraform apply -auto-approve -var="subscription_id=xxxxxx-xxxxx-xxxx-xxxxxx"

OPTIONAL (can be customized):
environment            = "dev"                              # Environment name (dev, staging, prod)
location               = "westeurope"                       # Azure region
resource_group_name    = "devopshomework-dev-rg"           # Resource group name
cluster_name           = "devopshomework-dev-aks"          # AKS cluster name
acr_name               = "devopshomeworkdev"               # Azure Container Registry name
app_namespace          = "devops"                          # Kubernetes namespace for app
grafana_admin_password = "admin123!"                       # Grafana admin password (change for production!)

If you fork this repo and want to use CI/CD pipeline, also update .github/workflows/ci-cd.yaml:
env:
  AZURE_RESOURCE_GROUP: devopshomework-dev-rg      # Must match terraform resource_group_name
  AKS_CLUSTER_NAME: devopshomework-dev-aks         # Must match terraform cluster_name
  ACR_NAME: devopshomeworkdev                      # Must match terraform acr_name

Note: These values are derived from Terraform outputs. Keep them consistent with terraform.tfvars.
## Used OS
Name: Ubuntu WSL2
Version: v22.04.3

## Used tools
Name           Version
terraform      v1.6.6
azure-cli      v2.81.0
docker         v24.0.7
kubectl        v1.32.9
helm           v3.14.0

# How to use this solution (Azure AKS)

1. Download this repo.
2. Be sure you have all tools from the list above.
3. Login to Azure CLI with an account that has Contributor permissions:
   az login
4. Update your subscription ID in `terraform/environments/DEVOPS_env/terraform.tfvars`:
  
   subscription_id = "<YOUR_SUBSCRIPTION_ID>"
  
5. cd to the terraform/environments/DEVOPS_env directory:
   cd terraform/environments/DEVOPS_env
6. Run Terraform:
   terraform init
   terraform plan
   terraform apply
   or  terraform apply -auto-approve -var="subscription_id="<YOUR_SUBSCRIPTION_ID>"
7. Wait for the infrastructure to be created (approximately 10-15 minutes).
8. Go back to the main dir and run `docker_bp_kubeconfig.sh`. It should:
   - Log you into the ACR (Azure Container Registry)
   - Build the Docker image
   - Tag and push it to ACR
   - Get AKS credentials and switch kubectl context
9. Verify the cluster is working:
    kubectl get nodes
    kubectl get pods -A
10. Run the deployment script k8s_deploy.sh. It will:
    - Deploy the application using Helm from devops-app/ chart
    - Create the namespace
    - Configure image repository from ACR automatically
    - Deploy with resources (deployment, service, ingress, HPA, PDB, NetworkPolicy)
11. Monitor the deployment:
    watch kubectl get pods,ingress,hpa -n devops
12. After pods show 1/1 Running and HPA shows metrics, get the Application Gateway/Load Balancer URL:
    kubectl get ingress -n devops
14. Test the application:
    - `/` - Returns "Hello, world!"
    - `/health` - Returns health status
15. To destroy the solution:
    - First run ./k8s_delete.sh to uninstall Helm release and clean up ACR images
    - Then run terraform destroy in the terraform directory /terraform/environments/DEVOPS_env
    - if subscriptionid is not in tfvarfile then run
    run with terraform destroy -auto-approve -var="subscription_id=xxxxxx-xxxxx-xxxx-xxxxxx"

## Quick Reference - Script Execution Order

Deploy:
1. terraform init && terraform plan && terraform apply    # Create infrastructure
2. ./docker_bp_kubeconfig.sh                              # Build image, push to ACR, get kubeconfig
3. ./k8s_deploy.sh                                        # Deploy app with Helm

Destroy:
1. ./k8s_delete.sh                                        # Remove app and clean ACR
2. terraform destroy                                      # Remove infrastructure

# Project Structure
azure-aks-solution/
├── .github/
│   └── workflows/
│       └── ci-cd.yaml        # GitHub Actions CI/CD pipeline
├── app/                      # application source code
│   ├── Dockerfile
│   ├── go.mod
│   └── main.go               # Includes Prometheus metrics endpoint
├── devops-app/               # Helm chart for application deployment
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
│       ├── deployment.yaml
│       ├── service.yaml
│       ├── ingress.yaml
│       ├── hpa.yaml
│       ├── pdb.yaml
│       ├── networkpolicy.yaml
│       ├── servicemonitor.yaml  # Prometheus ServiceMonitor
│       └── serviceaccount.yaml
├── terraform/                # Infrastructure as Code  Terraform
│   ├── environments/
│   │   └── DEVOPS_env/       # Environment-specific configuration
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       ├── terraform.tfvars
│   │       ├── observability.tf  # Prometheus & Grafana deployment
│   │       └── helm-releases.tf
│   └── modules/              # Reusable Terraform modules
│       ├── aks/              # AKS cluster module
│       ├── acr/              # Container Registry module
│       ├── network/          # VNet & subnets module
│       ├── storage/          # Storage Account module
│       ├── monitoring/       # Log Analytics module
│       └── observability/    # Prometheus & Grafana module
├── create_github_sp.sh      # create SP account with script
├── docker_bp_kubeconfig.sh   # Build, push, and configure kubeconfig
├── k8s_deploy.sh             # Deploy app using Helm
├── k8s_delete.sh             # Uninstall app using Helm
└── README.md

# Architecture - Solution Workflow

GitHub Push -> GitHub Actions -> Build Docker Image -> Push to ACR -> Deploy to AKS (Helm) -> NGINX Ingress -> Users

## Infrastructure Flow

Terraform -> Azure Resource Group -> VNet/Subnets -> AKS Cluster -> Node Pools -> App Pods

## Monitoring Flow

App Pods (/metrics) -> ServiceMonitor -> Prometheus (kube-prometheus-stack) -> Grafana Dashboards

## Traffic Flow

Users -> Azure Load Balancer -> NGINX Ingress Controller -> ClusterIP Service -> App Pods (HPA scaled)

## Architecture & Trade-off Reasoning

Design Decisions:
1. AKS over self-managed K8s: Reduces operational overhead, automatic upgrades, integrated Azure services
2. Azure CNI over Kubenet: Better network performance, pods get VNet IPs, required for Network Policies
3. System + User node pools: Isolation of system workloads, separate scaling for app workloads
4. Helm over raw manifests: Templating, versioning, easy upgrades and rollbacks
5. kube-prometheus-stack: Production-ready monitoring, includes Prometheus Operator, Grafana, AlertManager
6. NGINX Ingress over Azure App Gateway: Simpler setup, Kubernetes-native, cost-effective for dev/test
7. HPA + Cluster Autoscaler: Pod-level scaling for responsiveness, node-level for capacity

Trade-offs:
- Standard_B2s VMs: Cost-effective but limited resources (acceptable for homework/dev)
- Local Terraform state: Simple but not suitable for team collaboration (see improvements)
- Service Principal for CI/CD: Works but Managed Identity preferred for production
- LoadBalancer for Grafana: Quick access but exposes service externally (use ingress in production)

# General notes about the solution (Azure AKS)
1. The entire solution is based on Azure cloud, where I used:
   - ACR (Azure Container Registry) for private Docker images registry
   - VNet (Virtual Network) for the networking layer
   - AKS (Azure Kubernetes Service) for orchestration with node pools
   - Azure RBAC for access management and policies
   - Helm to deploy metrics server and NGINX ingress controller
2. I used some Terraform modules prepared for Azure (azurerm provider) to speed up development.
3. Some values are hardcoded to avoid using expensive VM sizes (Standard_B2s for cost efficiency).
4. Outputs are used for bash scripts to automate Docker build/push and k8s resource deployment.
5. For the app, I used a simple multi-stage Dockerfile.
6. Node pools configuration:
   - System pool: For AKS system components (CoreDNS, metrics-server, etc.)
   - User pool: For application workloads with autoscaling

7. VNet is configured with proper subnets:
   - AKS subnet with sufficient IP range for pods
   - Azure CNI networking for better network performance

8. AKS cluster configuration:
   - Managed identity (system-assigned)
   - Azure CNI networking
   - Cluster autoscaler enabled
   - Azure Policy addon for governance

9. The app is deployed via Helm chart (devops-app/) with:
   - Deployment with rolling update strategy
   - ClusterIP Service
   - Ingress (NGINX Ingress Controller)
   - HPA (Horizontal Pod Autoscaler)
   - PDB (Pod Disruption Budget)
   - NetworkPolicy for security
   - ServiceAccount with proper RBAC

10. No Terraform remote state storage (for this homework).
11. Scaling approach:
    - HPA for pod-level scaling
    - Cluster Autoscaler for node-level scaling
    - Load Balancer for traffic distribution

# CI/CD Pipeline

The project includes a GitHub Actions CI/CD pipeline (`.github/workflows/ci-cd.yaml`) that automates:
## Pipeline Stages
Stage:
- Buildi &Push: Build Docker image and push to ACR 
- Deploy: Deploy application to AKS using Helm 
## Pipeline Triggers
- Push to main`  branches
- Pull Requests to `main` (build only, no deploy)
- Manual trigger via `workflow_dispatch`
## Setting Up GitHub Actions CI/CD
### Step 1: Create Azure Service Principal
Run the following Azure CLI command:
```bash
az ad sp create-for-rbac --name "github-actions-sp" --role Contributor --scopes /subscriptions/<YOUR_SUBSCRIPTION_ID>
output:
json
{
  "appId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "displayName": "github-actions-sp",
  "password": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
  "tenant": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}


### Step 2: Format JSON for GitHub Secret
Convert the output to this format for GitHub Actions:
json
{
  "clientId": "<appId from output>",
  "clientSecret": "<password from output>",
  "subscriptionId": "<YOUR_SUBSCRIPTION_ID>",
  "tenantId": "<tenant from output>"
}

### Step 3: Configure GitHub Repository Secrets
1. Go to your GitHub repository
2. Navigate to Settings -> Secrets and variables -> Actions
3. Click New repository secret
4. Add the following secret:
   Secret Name: AZZZURETEST
   Value: Paste the entire JSON output from Step 1

# Step 4: Verify Pipeline Configuration
The pipeline uses these environment variables (already configured in `.github/workflows/ci-cd.yaml`):
env:
  AZURE_RESOURCE_GROUP: devopshomework-dev-rg
  AKS_CLUSTER_NAME: devopshomework-dev-aks
  ACR_NAME: devopshomeworkdev
  APP_NAME: devops-app
  APP_NAMESPACE: devops
!!! Update these values if your resource names are different.

# Step 5: Push Code to Trigger Pipeline
git push origin main
# Step 6: Monitor Pipeline Execution
1. Go to your GitHub repository
2. Click "Actions tab
3. Select the running workflow to view logs
# Manual Trigger
To manually run the pipeline:
1. Go to Actions -> CI/CD Pipeline
2. Click Run workflow
3. Select branch and click Run workflow

## Pipeline Workflow

Push/PR to main -> Build & Push Docker Image to ACR -> Deploy to AKS with Helm

# Troubleshooting
AZURE_CREDENTIALS error - Verify JSON format is correct and secret is properly saved
ACR push denied - Ensure Service Principal has AcrPush role on ACR
AKS deployment fails - Check Service Principal has Contributor role on resource group
Role assignment delete fails - Service Principal needs User Access Administrator role
Helm not found - Pipeline installs Helm automatically

## Running Locally (Alternative)

For local development, use the provided scripts:
./docker_bp_kubeconfig.sh    # Build, push image, and get kubeconfig
./k8s_deploy.sh              # Deploy application
./k8s_delete.sh              # Cleanup

# Observability

The solution includes a complete observability stack deployed via Terraform module.

# Components
Prometheus - Metrics collection & storage - Internal: prometheus-kube-prometheus-prometheus.monitoring:9090
Grafana - Visualization & dashboards - External: LoadBalancer IP on port 80
AlertManager - Alert routing - Internal: prometheus-kube-prometheus-alertmanager.monitoring:9093
Node Exporter - Node-level metrics - Automatic
Kube State Metrics - K8s object metrics - Automatic

## Accessing Grafana

# Get Grafana external IP
kubectl get svc -n monitoring prometheus-grafana -o jsonpath='{.status.loadBalancer.ingress[0].ip}'

# Credentials
Username: admin
Password: admin123!  (configurable via terraform.tfvars)

## Useful Commands

# Access Prometheus via port-forward
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090
# Access AlertManager via port-forward
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-alertmanager 9093:9093
# Build and push Docker image manually
docker build -t devopshomeworkdev.azurecr.io/devops-app:latest ./app
docker push devopshomeworkdev.azurecr.io/devops-app:latest
## Application Metrics
The Go application exposes Prometheus metrics at /metrics:

http_requests_total - Counter - Total HTTP requests by method, endpoint, status
http_request_duration_seconds - Histogram - Request latency distribution
app_info - Gauge - Application version info

## Grafana Dashboard
A ready-to-use dashboard is available at observability/grafana-dashboard.json
Import via Grafana UI: Dashboards -> New -> Import -> Upload JSON file

## Enabling App Metrics Scraping

Enable ServiceMonitor in terraform.tfvars (can be set before or after app deployment):

deploy_app_service_monitor = true
app_namespace              = "devops"

Note: ServiceMonitor is deployed to monitoring namespace and uses label selectors. If enabled before app deployment, Prometheus will automatically discover pods when app is deployed.

# Security Considerations

Current Implementation:
- NetworkPolicy restricts pod-to-pod communication
- ServiceAccount with minimal RBAC permissions
- Non-root container (distroless base image)
- Private ACR with managed identity access
- NGINX Ingress for controlled traffic entry

Production Recommendations:
- Enable Azure Defender for Containers
- Use Azure Policy for AKS governance
- Implement Pod Security Standards (restricted)
- Enable audit logging to Log Analytics
- Use private AKS cluster (private API server)
- Implement mTLS with service mesh (Istio/Linkerd)

# Potential Improvements and security consideration

# 1. Terraform Remote State (High Priority)
Current: Local state file (terraform.tfstate)
Recommended: Azure Storage Account with state locking
# 2. Azure Key Vault Integration
Current: Secrets in terraform.tfvars and Kubernetes secrets
- Store sensitive values in Key Vault (passwords, certificates, API keys)
- Use Key Vault CSI driver to mount secrets in pods
- Terraform reads secrets from Key Vault
- Managed Identity for authentication
Secrets to move to Key Vault:
- grafana_admin_password
- Service Principal credentials
- TLS certificates
- Database connection strings
# 3. Certificate Management
Current: No TLS configured
Recommended: cert-manager with Let's Encrypt
Components:
- cert-manager for automatic certificate provisioning
- ClusterIssuer for Let's Encrypt
- Automatic renewal before expiration
- Ingress annotation for TLS
# 4. Pipeline Security Scanning
# 5. Functional Testing
# 6. GitOps with ArgoCD/Flux
Benefits:
- Declarative deployments
- Git as single source of truth
- Automatic drift detection
- Easy rollbacks via git revert
- Audit trail in git history
# 7. Enhanced Observability
- Loki: Log aggregation (alternative to ELK)
- Tempo: Distributed tracing
- OpenTelemetry: Unified observability
- PagerDuty/OpsGenie: Alert routing
- Custom alerts for SLO/SLI
# 8. Disaster Recovery
Options:
- Velero: Kubernetes backup and restore
- Azure Site Recovery: VM-level DR
- Multi-region AKS: Active-active or active-passive
- Database replication: If using managed databases
# 9. Cost Optimization
Current: Standard_B2s (cost-effective)
Recommended: Additional optimizations
Options:
- Azure Spot instances for non-critical workloads
- Reserved instances for predictable workloads
- Cluster autoscaler with scale-to-zero
- Pod right-sizing based on actual usage
- Azure Cost Management alerts
# 10. Network Security
- Azure Firewall for egress control
- Network Security Groups (NSG) rules
- Private Link for Azure services
- Azure DDoS Protection
- Web Application Firewall (WAF)
# 11. API Gateway & Ingress Improvements
Current: NGINX Ingress Controller
Recommended: Azure Application Gateway or Istio Gateway
Azure Application Gateway Ingress Controller (AGIC): Native Azure integration, WAF built-in, SSL termination, auto-scaling
Istio Ingress Gateway: Advanced traffic management (canary, blue-green), mTLS, fine-grained policies
# 12. Service Mesh with Istio
Current: No service mesh
Recommended: Istio for production workloads
Benefits: mTLS encryption, traffic management, distributed tracing, authorization policies, fault injection
Components: Istiod (control plane), Envoy Proxy (sidecar), Istio Gateway, Kiali, Jaeger
Implementation: Install with istioctl/Helm, enable sidecar injection, configure VirtualService/DestinationRule
# kube-prometheus-stack (Prometheus Operator)
This solution uses kube-prometheus-stack Helm chart which provides:
Components: Prometheus Operator, Prometheus, Grafana, AlertManager, Node Exporter, Kube State Metrics, Prometheus Adapter
Why Prometheus Operator: Declarative CRDs, ServiceMonitor for auto-discovery, PrometheusRule for alerts, production-ready
ServiceMonitor for App: The application exposes /metrics endpoint scraped by Prometheus via ServiceMonitor CRD.
# GitOps with ArgoCD
For production deployments, consider using:
- ArgoCD for GitOps-based deployments
- Flux as an alternative GitOps tool
- Helm charts managed through Git repositories
Benefits: Declarative deployments, Git as single source of truth, automatic drift detection, easy rollbacks, audit trail
