# Storage Module - Variables


variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "storage_name" {
  description = "Name of the storage account (must be globally unique)"
  type        = string
}

variable "storage_account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"
}

variable "storage_account_replication_type" {
  description = "Replication type"
  type        = string
  default     = "LRS"
}

variable "storage_account_kind" {
  description = "Storage account kind"
  type        = string
  default     = "StorageV2"
}

variable "storage_min_tls_version" {
  description = "Minimum TLS version"
  type        = string
  default     = "TLS1_2"
}

variable "storage_enable_https_traffic_only" {
  description = "Force HTTPS"
  type        = bool
  default     = true
}

variable "storage_blob_delete_retention_days" {
  description = "Blob retention days"
  type        = number
  default     = 7
}

variable "storage_container_delete_retention_days" {
  description = "Container retention days"
  type        = number
  default     = 7
}

variable "create_storage_containers" {
  description = "Create storage containers"
  type        = bool
  default     = true
}

variable "storage_containers" {
  description = "Storage containers to create"
  type = list(object({
    name                  = string
    container_access_type = string
  }))
  default = []
}

variable "subnet_aks_id" {
  description = "AKS subnet ID for network rules"
  type        = string
  default     = ""
}

variable "aks_kubelet_identity_object_id" {
  description = "AKS kubelet identity for role assignment"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
