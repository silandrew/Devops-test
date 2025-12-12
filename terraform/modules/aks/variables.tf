
# AKS Module - Variables


variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aks_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "aks_dns_prefix" {
  description = "DNS prefix for AKS"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
}

variable "aks_sku_tier" {
  description = "SKU tier (Free or Standard)"
  type        = string
  default     = "Free"
}

# Network
variable "subnet_aks_id" {
  description = "ID of the AKS subnet"
  type        = string
}

variable "vnet_id" {
  description = "ID of the VNet for role assignment"
  type        = string
}

variable "aks_network_plugin" {
  description = "Network plugin (azure or kubenet)"
  type        = string
  default     = "azure"
}

variable "aks_network_policy" {
  description = "Network policy (calico or azure)"
  type        = string
  default     = "calico"
}

variable "service_cidr" {
  description = "Service CIDR"
  type        = string
}

variable "dns_service_ip" {
  description = "DNS service IP"
  type        = string
}

# System Node Pool
variable "system_node_pool_name" {
  description = "Name of system node pool"
  type        = string
  default     = "system"
}

variable "system_node_count" {
  description = "Initial system node count"
  type        = number
  default     = 1
}

variable "system_node_min_count" {
  description = "Minimum system nodes"
  type        = number
  default     = 1
}

variable "system_node_max_count" {
  description = "Maximum system nodes"
  type        = number
  default     = 3
}

variable "system_node_vm_size" {
  description = "VM size for system nodes"
  type        = string
  default     = "Standard_B2s"
}

variable "system_node_os_disk_size_gb" {
  description = "OS disk size for system nodes"
  type        = number
  default     = 50
}

# User Node Pool
variable "user_node_pool_name" {
  description = "Name of user node pool"
  type        = string
  default     = "user"
}

variable "user_node_count" {
  description = "Initial user node count"
  type        = number
  default     = 2
}

variable "user_node_min_count" {
  description = "Minimum user nodes"
  type        = number
  default     = 1
}

variable "user_node_max_count" {
  description = "Maximum user nodes"
  type        = number
  default     = 5
}

variable "user_node_vm_size" {
  description = "VM size for user nodes"
  type        = string
  default     = "Standard_B2s"
}

variable "user_node_os_disk_size_gb" {
  description = "OS disk size for user nodes"
  type        = number
  default     = 50
}

# Add-ons
variable "aks_azure_policy_enabled" {
  description = "Enable Azure Policy"
  type        = bool
  default     = true
}

variable "aks_http_application_routing_enabled" {
  description = "Enable HTTP application routing"
  type        = bool
  default     = false
}

variable "aks_automatic_channel_upgrade" {
  description = "Automatic upgrade channel"
  type        = string
  default     = "patch"
}

# Monitoring
variable "enable_container_insights" {
  description = "Enable container insights"
  type        = bool
  default     = true
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
