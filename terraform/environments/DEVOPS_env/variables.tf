# =============================================================================
# DEVOPS Environment - Variables
# =============================================================================

# =============================================================================
# Azure Subscription
# =============================================================================

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

# =============================================================================
# General Variables
# =============================================================================

variable "project_name" {
  description = "Name of the project, used as prefix for all resources"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "owner" {
  description = "Owner of the resources for tagging"
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# =============================================================================
# Network Variables
# =============================================================================

variable "vnet_address_space" {
  description = "Address space for the Virtual Network"
  type        = string
}

variable "subnet_aks_address_prefix" {
  description = "Address prefix for AKS subnet"
  type        = string
}

variable "subnet_storage_address_prefix" {
  description = "Address prefix for Storage subnet"
  type        = string
}

variable "service_cidr" {
  description = "Service CIDR for Kubernetes services"
  type        = string
}

variable "dns_service_ip" {
  description = "DNS service IP (must be within service_cidr)"
  type        = string
}

# =============================================================================
# AKS Variables
# =============================================================================

variable "kubernetes_version" {
  description = "Kubernetes version for AKS cluster"
  type        = string
}

variable "aks_sku_tier" {
  description = "SKU tier for AKS (Free or Standard)"
  type        = string
}

variable "aks_network_plugin" {
  description = "Network plugin for AKS (azure or kubenet)"
  type        = string
}

variable "aks_network_policy" {
  description = "Network policy for AKS (calico, azure)"
  type        = string
}

# System Node Pool
variable "system_node_pool_name" {
  description = "Name of the system node pool"
  type        = string
}

variable "system_node_count" {
  description = "Initial number of system nodes"
  type        = number
}

variable "system_node_min_count" {
  description = "Minimum number of system nodes"
  type        = number
}

variable "system_node_max_count" {
  description = "Maximum number of system nodes"
  type        = number
}

variable "system_node_vm_size" {
  description = "VM size for system nodes"
  type        = string
}

variable "system_node_os_disk_size_gb" {
  description = "OS disk size for system nodes in GB"
  type        = number
}

# User Node Pool
variable "user_node_pool_name" {
  description = "Name of the user node pool"
  type        = string
}

variable "user_node_count" {
  description = "Initial number of user nodes"
  type        = number
}

variable "user_node_min_count" {
  description = "Minimum number of user nodes"
  type        = number
}

variable "user_node_max_count" {
  description = "Maximum number of user nodes"
  type        = number
}

variable "user_node_vm_size" {
  description = "VM size for user nodes"
  type        = string
}

variable "user_node_os_disk_size_gb" {
  description = "OS disk size for user nodes in GB"
  type        = number
}

# AKS Add-ons
variable "aks_azure_policy_enabled" {
  description = "Enable Azure Policy add-on"
  type        = bool
}

variable "aks_http_application_routing_enabled" {
  description = "Enable HTTP application routing"
  type        = bool
}

variable "aks_automatic_channel_upgrade" {
  description = "Automatic upgrade channel"
  type        = string
}

# =============================================================================
# ACR Variables
# =============================================================================

variable "acr_sku" {
  description = "SKU for Azure Container Registry"
  type        = string
}

variable "acr_admin_enabled" {
  description = "Enable admin user for ACR"
  type        = bool
}

variable "acr_georeplication_locations" {
  description = "Geo-replication locations (Premium only)"
  type        = list(string)
  default     = []
}

variable "acr_public_network_access_enabled" {
  description = "Enable public network access"
  type        = bool
}

variable "acr_quarantine_policy_enabled" {
  description = "Enable quarantine policy (Premium only)"
  type        = bool
}

variable "acr_retention_policy_days" {
  description = "Retention policy days (Premium only)"
  type        = number
}

# =============================================================================
# Storage Variables
# =============================================================================

variable "storage_account_tier" {
  description = "Storage account tier"
  type        = string
}

variable "storage_account_replication_type" {
  description = "Storage replication type"
  type        = string
}

variable "storage_account_kind" {
  description = "Storage account kind"
  type        = string
}

variable "storage_min_tls_version" {
  description = "Minimum TLS version"
  type        = string
}

variable "storage_enable_https_traffic_only" {
  description = "Force HTTPS only"
  type        = bool
}

variable "storage_blob_delete_retention_days" {
  description = "Blob retention days"
  type        = number
}

variable "storage_container_delete_retention_days" {
  description = "Container retention days"
  type        = number
}

variable "create_storage_containers" {
  description = "Create storage containers"
  type        = bool
}

variable "storage_containers" {
  description = "Storage containers to create"
  type = list(object({
    name                  = string
    container_access_type = string
  }))
}

# =============================================================================
# Monitoring Variables
# =============================================================================

variable "log_analytics_sku" {
  description = "SKU for Log Analytics"
  type        = string
}

variable "log_analytics_retention_days" {
  description = "Retention period in days"
  type        = number
}

variable "enable_container_insights" {
  description = "Enable Container Insights"
  type        = bool
}

# =============================================================================
# Observability Variables (Prometheus & Grafana)
# =============================================================================

variable "grafana_admin_password" {
  description = "Admin password for Grafana dashboard"
  type        = string
  sensitive   = true
  default     = "admin123!"  # Change in production!
}

variable "deploy_app_service_monitor" {
  description = "Deploy ServiceMonitor for the application (set to true after app deployment)"
  type        = bool
  default     = false
}

variable "app_namespace" {
  description = "Namespace where the application is deployed"
  type        = string
  default     = "default"
}
