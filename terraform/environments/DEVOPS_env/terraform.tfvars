
# Environment: DEVOPS 

# Azure Subscription

subscription_id = "48a00000-0000-0000-0000-c460c2e00c61"
## terraform apply -auto-approve -var="subscription_id=xxxx-xxxx2xxx8a-xxxxf-xxxxxxx"


# General Settings

project_name = "devopshomework"
environment  = "dev"
location     = "westeurope"
owner        = "DevOps Team"

tags = {
  ManagedBy   = "Terraform"
  CostCenter  = "DevOps"
  Team        = "Platform"
  Environment = "DEVOPS"
}

# Network Settings


vnet_address_space            = "10.100.0.0/16"
subnet_aks_address_prefix     = "10.100.0.0/23"
subnet_storage_address_prefix = "10.100.4.0/24"
service_cidr                  = "10.200.0.0/16"
dns_service_ip                = "10.200.0.10"


# AKS Cluster Settings


kubernetes_version = "1.32"
aks_sku_tier       = "Free"
aks_network_plugin = "azure"
aks_network_policy = "calico"

# System Node Pool
system_node_pool_name       = "system"
system_node_count           = 1
system_node_min_count       = 1
system_node_max_count       = 3
system_node_vm_size         = "Standard_B2s"
system_node_os_disk_size_gb = 50

# User Node Pool
user_node_pool_name       = "devops"
user_node_count           = 2
user_node_min_count       = 1
user_node_max_count       = 5
user_node_vm_size         = "Standard_B2s"
user_node_os_disk_size_gb = 50

# AKS Add-ons
aks_azure_policy_enabled             = true
aks_http_application_routing_enabled = false
aks_automatic_channel_upgrade        = "patch"


# ACR Settings


acr_sku                           = "Basic"
acr_admin_enabled                 = true
acr_georeplication_locations      = []
acr_public_network_access_enabled = true
acr_quarantine_policy_enabled     = false
acr_retention_policy_days         = 7


# Storage Settings


storage_account_tier                    = "Standard"
storage_account_replication_type        = "LRS"
storage_account_kind                    = "StorageV2"
storage_min_tls_version                 = "TLS1_2"
storage_enable_https_traffic_only       = true
storage_blob_delete_retention_days      = 7
storage_container_delete_retention_days = 7
create_storage_containers               = true

storage_containers = [
  {
    name                  = "data"
    container_access_type = "private"
  },
  {
    name                  = "backups"
    container_access_type = "private"
  },
  {
    name                  = "logs"
    container_access_type = "private"
  }
]


# Monitoring Settings

log_analytics_sku            = "PerGB2018"
log_analytics_retention_days = 30
enable_container_insights    = true
grafana_admin_password       = "admin123!"